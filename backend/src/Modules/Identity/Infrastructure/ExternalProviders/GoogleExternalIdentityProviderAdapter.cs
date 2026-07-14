using System.Security.Claims;
using Microsoft.AspNetCore.Authentication.Google;

namespace SpecPour.Modules.Identity.Infrastructure.ExternalProviders;

public sealed class GoogleExternalIdentityProviderAdapter : IExternalIdentityProviderPort
{
    public string ProviderKey => "google";

    public string AuthenticationScheme => GoogleDefaults.AuthenticationScheme;

    public ExternalIdentity Normalize(ClaimsPrincipal principal) => new(
        Subject: principal.FindFirstValue(ClaimTypes.NameIdentifier) ?? throw new InvalidOperationException("Google identity has no subject claim."),
        Email: principal.FindFirstValue(ClaimTypes.Email),
        DisplayName: principal.FindFirstValue(ClaimTypes.Name));
}
