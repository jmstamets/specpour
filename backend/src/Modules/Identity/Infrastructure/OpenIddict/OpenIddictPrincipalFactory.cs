using System.Security.Claims;
using OpenIddict.Abstractions;
using static OpenIddict.Abstractions.OpenIddictConstants;

using TokenValidationParameters = Microsoft.IdentityModel.Tokens.TokenValidationParameters;

namespace SpecPour.Modules.Identity.Infrastructure.OpenIddict;

/// <summary>
/// Builds the claims principal OpenIddict signs into access/identity tokens for a given
/// user (shared by the /connect/authorize code-issuance step and the /connect/token
/// refresh step, so both paths always mint the same claim shape). Destinations control
/// which claims land in the access token vs. the identity token — per OpenIddict's
/// documented pattern, nothing is emitted anywhere unless explicitly marked.
/// </summary>
public static class OpenIddictPrincipalFactory
{
    public static ClaimsPrincipal Create(ApplicationUser user, IEnumerable<string> scopes)
    {
        var identity = new ClaimsIdentity(
            authenticationType: TokenValidationParameters.DefaultAuthenticationType,
            nameType: Claims.Name,
            roleType: Claims.Role);

        identity.SetClaim(Claims.Subject, user.Id.ToString())
            .SetClaim(Claims.Email, user.Email)
            .SetClaim(Claims.Name, user.DisplayName)
            .SetClaim(Claims.PreferredUsername, user.UserName);

        var principal = new ClaimsPrincipal(identity);
        principal.SetScopes(scopes);

        foreach (var claim in principal.Claims)
        {
            claim.SetDestinations(GetDestinations(claim, principal));
        }

        return principal;
    }

    private static IEnumerable<string> GetDestinations(Claim claim, ClaimsPrincipal principal)
    {
        // Every claim lands in the access token (resource APIs read it via the
        // validation handler); only a narrow, OIDC-conventional subset also lands in
        // the identity token, per OpenIddict's documented least-privilege pattern.
        yield return Destinations.AccessToken;

        if (claim.Type is Claims.Name or Claims.PreferredUsername && principal.HasScope(Scopes.Profile))
        {
            yield return Destinations.IdentityToken;
        }

        if (claim.Type == Claims.Email && principal.HasScope(Scopes.Email))
        {
            yield return Destinations.IdentityToken;
        }
    }
}
