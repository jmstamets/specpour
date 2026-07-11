using Microsoft.AspNetCore; // OpenIddictServerAspNetCoreHelpers: HttpContext.GetOpenIddictServerRequest()
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Routing;
using OpenIddict.Abstractions;
using OpenIddict.Server.AspNetCore;
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
    }

    private static async Task<IResult> HandleAuthorizeAsync(HttpContext httpContext, UserManager<ApplicationUser> userManager)
    {
        var result = await httpContext.AuthenticateAsync(CookieAuthenticationDefaults.AuthenticationScheme);
        if (result.Succeeded is not true || result.Principal is null)
        {
            return Results.Challenge(
                authenticationSchemes: [CookieAuthenticationDefaults.AuthenticationScheme],
                properties: new AuthenticationProperties { RedirectUri = httpContext.Request.GetEncodedUrl() });
        }

        var user = await userManager.GetUserAsync(result.Principal)
            ?? throw new InvalidOperationException("The cookie principal no longer maps to a user account.");

        var request = httpContext.GetOpenIddictServerRequest()
            ?? throw new InvalidOperationException("The OpenIddict authorization request cannot be retrieved.");

        var principal = OpenIddictPrincipalFactory.Create(user, request.GetScopes());
        return Results.SignIn(principal, authenticationScheme: OpenIddictServerAspNetCoreDefaults.AuthenticationScheme);
    }

    private static async Task<IResult> HandleTokenAsync(HttpContext httpContext, UserManager<ApplicationUser> userManager)
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

        // Re-issue fresh claims on every token/refresh, rather than trusting the
        // stored principal verbatim, so a display-name change or lifecycle-state
        // transition takes effect on the next refresh without waiting for re-login.
        var principal = OpenIddictPrincipalFactory.Create(user, authenticateResult.Principal.GetScopes());
        return Results.SignIn(principal, authenticationScheme: OpenIddictServerAspNetCoreDefaults.AuthenticationScheme);
    }
}
