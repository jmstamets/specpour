using System.Security.Claims;
using AspNet.Security.OAuth.Apple;

namespace SpecPour.Modules.Identity.Infrastructure.ExternalProviders;

/// <summary>
/// Apple only ever includes email/name on the caller's very first authorization of
/// this app (a well-known Apple platform quirk, unrelated to this adapter) — later
/// sign-ins carry only the subject claim. DisplayName is best-effort and commonly
/// null; the account-linking flow (ExternalAuthEndpoints) must tolerate that.
/// </summary>
public sealed class AppleExternalIdentityProviderAdapter : IExternalIdentityProviderPort
{
    public string ProviderKey => "apple";

    public string AuthenticationScheme => AppleAuthenticationDefaults.AuthenticationScheme;

    public ExternalIdentity Normalize(ClaimsPrincipal principal) => new(
        Subject: principal.FindFirstValue(ClaimTypes.NameIdentifier) ?? throw new InvalidOperationException("Apple identity has no subject claim."),
        Email: principal.FindFirstValue(ClaimTypes.Email),
        DisplayName: principal.FindFirstValue(ClaimTypes.Name));
}
