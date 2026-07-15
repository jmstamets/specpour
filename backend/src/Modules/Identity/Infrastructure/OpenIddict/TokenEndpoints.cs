using Microsoft.AspNetCore; // OpenIddictServerAspNetCoreHelpers: HttpContext.GetOpenIddictServerRequest()
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using OpenIddict.Abstractions;
using OpenIddict.Server.AspNetCore;
using SpecPour.BuildingBlocks.Identifiers;
using SpecPour.BuildingBlocks.Time;
using SpecPour.Modules.Identity.Domain;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Identity.Infrastructure.OpenIddict;

/// <summary>
/// /connect/authorize and /connect/token (T017: authorization-code + refresh flows).
/// The authorization endpoint delegates "is this caller signed in" to cookie
/// authentication — there is no interactive login UI wired up yet (that's T047/T055),
/// so this endpoint is infrastructure-complete but only exercisable once something
/// establishes a cookie session (registration/sign-in). The token endpoint is fully
/// self-contained and exercisable today for the refresh_token grant once an
/// authorization exists.
/// </summary>
public static class TokenEndpoints
{
    public static void Map(IEndpointRouteBuilder endpoints)
    {
        endpoints.MapMethods("/connect/authorize", ["GET", "POST"], HandleAuthorizeAsync);
        endpoints.MapPost("/connect/token", HandleTokenAsync);

        // ADR-0003 web PKCE landing target. The Flutter web client can't read a
        // 302's Location header (browser XHR follows redirects opaquely and
        // dio_web_adapter discards xhr.responseURL into Response.realUri — verified
        // 2026-07-15), so instead of chasing the Location it lets the /connect/authorize
        // redirect land here (this endpoint is the client's registered redirect_uri on
        // web), reads the authorization code straight off the final same-origin URL via
        // XMLHttpRequest.responseURL, and posts it to /connect/token itself. This page
        // is never actually rendered — the XHR reads only its URL — so the body is just
        // a graceful fallback for a human who somehow lands here directly. Native
        // clients keep the standard custom-scheme redirect (com.specpour.app://callback)
        // and read the Location header normally, so this is web-only infrastructure.
        endpoints.MapGet("/connect/spa-callback", (HttpContext http) =>
        {
            // T174: the redirected URL carries the one-time authorization code, so its
            // response must never be cached (a cached response could leak the
            // code-bearing URL). The code is also single-use and PKCE-bound, and this
            // page is only ever read via fetch's Response.url in the initiating JS
            // context (never navigated to → no browser-history entry), so no other
            // browsing context can observe it.
            http.Response.Headers.CacheControl = "no-store";
            return Results.Content(
                "<!doctype html><meta charset=\"utf-8\"><title>Signing you in…</title>" +
                "<p>Signing you in… you can close this window if it doesn't return automatically.</p>",
                "text/html");
        });
    }

    private static async Task<IResult> HandleAuthorizeAsync(HttpContext httpContext, UserManager<ApplicationUser> userManager)
    {
        var result = await httpContext.AuthenticateAsync(IdentityConstants.ApplicationScheme);
        if (result.Succeeded is not true || result.Principal is null)
        {
            return Results.Challenge(
                authenticationSchemes: [IdentityConstants.ApplicationScheme],
                properties: new AuthenticationProperties { RedirectUri = httpContext.Request.GetEncodedUrl() });
        }

        var user = await userManager.GetUserAsync(result.Principal)
            ?? throw new InvalidOperationException("The cookie principal no longer maps to a user account.");

        var request = httpContext.GetOpenIddictServerRequest()
            ?? throw new InvalidOperationException("The OpenIddict authorization request cannot be retrieved.");

        var principal = OpenIddictPrincipalFactory.Create(user, request.GetScopes());
        return Results.SignIn(principal, authenticationScheme: OpenIddictServerAspNetCoreDefaults.AuthenticationScheme);
    }

    private static async Task<IResult> HandleTokenAsync(
        HttpContext httpContext,
        UserManager<ApplicationUser> userManager,
        IdentityDbContext db,
        IUuidGenerator uuidGenerator,
        IClock clock)
    {
        var request = httpContext.GetOpenIddictServerRequest()
            ?? throw new InvalidOperationException("The OpenIddict token request cannot be retrieved.");

        if (!request.IsAuthorizationCodeGrantType() && !request.IsRefreshTokenGrantType())
        {
            return Results.Problem(
                title: "Unsupported grant type",
                detail: "Only authorization_code and refresh_token grants are supported.",
                statusCode: StatusCodes.Status400BadRequest);
        }

        // The code/refresh-token was already validated by the OpenIddict server
        // middleware before this handler runs; it hands back the principal that was
        // attached when the code/token was originally issued.
        var authenticateResult = await httpContext.AuthenticateAsync(OpenIddictServerAspNetCoreDefaults.AuthenticationScheme);
        if (authenticateResult.Succeeded is not true || authenticateResult.Principal is null)
        {
            return Results.Forbid(authenticationSchemes: [OpenIddictServerAspNetCoreDefaults.AuthenticationScheme]);
        }

        var subject = authenticateResult.Principal.GetClaim(Claims.Subject)
            ?? throw new InvalidOperationException("The token principal is missing a subject claim.");

        var user = await userManager.FindByIdAsync(subject);
        if (user is null)
        {
            return Results.Forbid(authenticationSchemes: [OpenIddictServerAspNetCoreDefaults.AuthenticationScheme]);
        }

        // T051: SessionDevice tracking. The authorization code/refresh token's
        // principal already carries OpenIddict's own internal authorization id (set
        // when the authorization was first created during /connect/authorize) — the
        // SAME id for every token minted off that authorization, code exchange or
        // any later refresh. A brand-new authorization_code grant means a brand-new
        // session; a refresh_token grant just means an existing one is still alive.
        var authorizationId = authenticateResult.Principal.GetAuthorizationId();
        if (authorizationId is not null)
        {
            if (request.IsAuthorizationCodeGrantType())
            {
                db.SessionDevices.Add(new SessionDevice
                {
                    Id = uuidGenerator.NewId(),
                    UserId = user.Id,
                    AuthorizationId = authorizationId,
                    DeviceDescription = httpContext.Request.Headers.UserAgent.ToString() is { Length: > 0 } userAgent
                        ? userAgent
                        : "Unknown device",
                    CreatedAt = clock.UtcNow,
                    LastSeenAt = clock.UtcNow,
                });
            }
            else
            {
                var existing = await db.SessionDevices.SingleOrDefaultAsync(s => s.AuthorizationId == authorizationId, httpContext.RequestAborted);
                if (existing is not null)
                {
                    existing.LastSeenAt = clock.UtcNow;
                }
            }

            await db.SaveChangesAsync(httpContext.RequestAborted);
        }

        // Re-issue fresh claims on every token/refresh, rather than trusting the
        // stored principal verbatim, so a display-name change or lifecycle-state
        // transition takes effect on the next refresh without waiting for re-login.
        var principal = OpenIddictPrincipalFactory.Create(user, authenticateResult.Principal.GetScopes());
        return Results.SignIn(principal, authenticationScheme: OpenIddictServerAspNetCoreDefaults.AuthenticationScheme);
    }
}
