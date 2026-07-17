using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Routing;
using Microsoft.AspNetCore.WebUtilities;
using SpecPour.BuildingBlocks.Http;
using SpecPour.BuildingBlocks.Identifiers;
using SpecPour.BuildingBlocks.Time;
using SpecPour.Modules.Compliance.Contracts;
using SpecPour.Modules.Identity.Application;
using SpecPour.Modules.Identity.Application.Ports;
using SpecPour.Modules.Identity.Domain;
using SpecPour.Modules.Identity.Infrastructure.ExternalProviders;

namespace SpecPour.Modules.Identity.Infrastructure.Endpoints;

/// <summary>
/// GET /api/v1/auth/external/{provider} (+callback), POST /api/v1/auth/external/
/// complete-registration (T049, contracts/api-v1-surface.md). A real browser-redirect
/// OAuth handshake — not a "submit a token you already have" endpoint — driven by each
/// provider's own proven ASP.NET Core handler (IdentityModule.RegisterServices). The
/// callback derives which provider/identity it's handling from ASP.NET Core Identity's
/// own IdentityConstants.ExternalScheme cookie (via SignInManager.
/// GetExternalLoginInfoAsync) rather than trusting the {provider} route segment, which
/// exists only for URL clarity matching the surface doc's documented shape.
/// </summary>
public static class ExternalAuthEndpoints
{
    private const string ReturnToKey = "returnTo";

    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        group.MapGet("/auth/external/providers", ListConfiguredProviders);
        group.MapGet("/auth/external/{provider}", ChallengeAsync);
        group.MapGet("/auth/external/{provider}/callback", CallbackAsync);
        group.MapPost("/auth/external/complete-registration", CompleteRegistrationAsync);
    }

    /// <summary>
    /// T173: which social providers are actually configured (IdentityModule only
    /// registers a provider's <see cref="IExternalIdentityProviderPort"/> when its
    /// ClientId is set) — names only, never secrets. Anonymous, sibling route to the
    /// existing /auth/external/{provider} family (not the Authorization module's
    /// /me/entitlements, which is about capability/tier, a different concern from
    /// "which auth methods exist" — this needed its own small surface). The client
    /// renders a provider's button only if its key appears here, so a login screen
    /// never shows a button that would 400 "unknown provider" when tapped.
    /// </summary>
    private static Ok<ExternalProvidersResponse> ListConfiguredProviders(
        IEnumerable<IExternalIdentityProviderPort> providers)
    {
        return TypedResults.Ok(new ExternalProvidersResponse(
            [.. providers.Select(p => p.ProviderKey)]));
    }

    private static Results<ChallengeHttpResult, ProblemHttpResult> ChallengeAsync(
        string provider,
        string redirectUri,
        IEnumerable<IExternalIdentityProviderPort> providers)
    {
        var adapter = providers.SingleOrDefault(p => string.Equals(p.ProviderKey, provider, StringComparison.OrdinalIgnoreCase));
        if (adapter is null)
        {
            return TypedResults.Problem(title: "Unknown provider", statusCode: StatusCodes.Status400BadRequest);
        }

        var properties = new AuthenticationProperties
        {
            RedirectUri = $"/api/v1/auth/external/{adapter.ProviderKey}/callback",
        };
        properties.Items[ReturnToKey] = redirectUri;

        return TypedResults.Challenge(properties, [adapter.AuthenticationScheme]);
    }

    private static async Task<RedirectHttpResult> CallbackAsync(
        HttpContext httpContext,
        SignInManager<ApplicationUser> signInManager,
        UserManager<ApplicationUser> userManager,
        IdentityDbContext db,
        IEnumerable<IExternalIdentityProviderPort> providers,
        CancellationToken cancellationToken)
    {
        var info = await signInManager.GetExternalLoginInfoAsync();
        var returnTo = "/";
        if (info?.AuthenticationProperties?.Items.TryGetValue(ReturnToKey, out var storedReturnTo) == true && storedReturnTo is not null)
        {
            returnTo = storedReturnTo;
        }

        if (info is null)
        {
            return TypedResults.Redirect(AppendQuery(returnTo, "error", "external_auth_failed"));
        }

        var adapter = providers.SingleOrDefault(p => string.Equals(p.AuthenticationScheme, info.LoginProvider, StringComparison.Ordinal));
        if (adapter is null)
        {
            return TypedResults.Redirect(AppendQuery(returnTo, "error", "external_auth_failed"));
        }

        var identity = adapter.Normalize(info.Principal);
        var user = await userManager.FindByLoginAsync(adapter.ProviderKey, identity.Subject)
            ?? (identity.Email is not null ? await userManager.FindByEmailAsync(identity.Email) : null);

        if (user is null)
        {
            // No matching account: leave the ExternalScheme cookie in place —
            // CompleteRegistrationAsync reads it once the client supplies the date of
            // birth FR-002/FR-002c requires for every registration method, social
            // sign-in included (spec.md US2).
            return TypedResults.Redirect(AppendQuery(returnTo, "needsDateOfBirth", "true"));
        }

        if (await userManager.FindByLoginAsync(adapter.ProviderKey, identity.Subject) is null)
        {
            // Matched by email to an account that hasn't used this provider before —
            // link it rather than erroring or duplicating the account.
            await userManager.AddLoginAsync(user, new UserLoginInfo(adapter.ProviderKey, identity.Subject, adapter.ProviderKey));
        }

        await httpContext.SignOutAsync(IdentityConstants.ExternalScheme);
        var loginResponse = await AuthEndpoints.SignInOrChallengeMfaAsync(user, httpContext, signInManager, db, cancellationToken);

        return TypedResults.Redirect(AppendQuery(returnTo, "requiresMfa", loginResponse.RequiresMfa ? "true" : "false"));
    }

    private static async Task<Results<Created<AuthAccountResponse>, ProblemHttpResult>> CompleteRegistrationAsync(
        CompleteExternalRegistrationRequest request,
        HttpContext httpContext,
        SignInManager<ApplicationUser> signInManager,
        UserManager<ApplicationUser> userManager,
        IEnumerable<IExternalIdentityProviderPort> providers,
        ILegalDrinkingAgePort legalDrinkingAge,
        IDateOfBirthCipher cipher,
        IUuidGenerator uuidGenerator,
        IClock clock,
        CancellationToken cancellationToken)
    {
        var info = await signInManager.GetExternalLoginInfoAsync();
        var adapter = info is null ? null : providers.SingleOrDefault(p => string.Equals(p.AuthenticationScheme, info.LoginProvider, StringComparison.Ordinal));
        if (info is null || adapter is null)
        {
            return TypedResults.Problem(
                title: "No pending external sign-in",
                detail: "Start at GET /auth/external/{provider} first.",
                statusCode: StatusCodes.Status400BadRequest);
        }

        var identity = adapter.Normalize(info.Principal);
        if (identity.Email is null)
        {
            return TypedResults.Problem(
                title: "Registration failed",
                detail: "This provider did not share an email address.",
                statusCode: StatusCodes.Status400BadRequest);
        }

        // FR-002c: identical underage handling to email/password registration — the
        // check happens before anything is persisted.
        var rule = await legalDrinkingAge.ResolveFromIpAsync(httpContext.Connection.RemoteIpAddress, cancellationToken);
        var today = DateOnly.FromDateTime(clock.UtcNow.UtcDateTime);
        var age = AgeCalculator.CalculateAge(request.DateOfBirth, today);
        if (age < rule.LegalDrinkingAge)
        {
            await httpContext.SignOutAsync(IdentityConstants.ExternalScheme);
            return TypedResults.Problem(
                title: "Underage registration",
                detail: "Registration requires meeting the applicable legal drinking age.",
                statusCode: StatusCodes.Status403Forbidden);
        }

        // Generated before the object initializer (T164): the AAD-bound DOB cipher
        // needs the id, but the object doesn't exist yet inside its own initializer.
        var newUserId = uuidGenerator.NewId();
        var user = new ApplicationUser
        {
            Id = newUserId,
            UserName = identity.Email,
            Email = identity.Email,
            EmailConfirmed = true,
            DisplayName = !string.IsNullOrWhiteSpace(identity.DisplayName) ? identity.DisplayName : request.DisplayName,
            // No password (data-model.md User: "password hash (nullable when social-only)").
            EncryptedDateOfBirth = cipher.Encrypt(newUserId, request.DateOfBirth),
            UnitPreference = AuthEndpoints.ParseUnitPreference(request.UnitPreference),
            Locale = string.IsNullOrWhiteSpace(request.Locale) ? "en-US" : request.Locale,
            CreatedAt = clock.UtcNow,
        };

        var createResult = await userManager.CreateAsync(user);
        if (!createResult.Succeeded)
        {
            return TypedResults.Problem(
                title: "Registration failed",
                detail: string.Join("; ", createResult.Errors.Select(e => e.Description)),
                statusCode: StatusCodes.Status400BadRequest);
        }

        await userManager.AddLoginAsync(user, new UserLoginInfo(adapter.ProviderKey, identity.Subject, adapter.ProviderKey));
        await httpContext.SignOutAsync(IdentityConstants.ExternalScheme);
        await signInManager.SignInAsync(user, isPersistent: true);

        return TypedResults.Created("/api/v1/me", new AuthAccountResponse(user.Id, user.Email!, user.DisplayName));
    }

    private static string AppendQuery(string uri, string key, string value) =>
        QueryHelpers.AddQueryString(uri, key, value);
}

/// <summary>T173: provider keys only ("google", "microsoft", "apple") — never secrets, never full config.</summary>
public sealed record ExternalProvidersResponse(IReadOnlyList<string> Providers);

public sealed record CompleteExternalRegistrationRequest(
    DateOnly DateOfBirth,
    string DisplayName,
    string? UnitPreference,
    string? Locale);
