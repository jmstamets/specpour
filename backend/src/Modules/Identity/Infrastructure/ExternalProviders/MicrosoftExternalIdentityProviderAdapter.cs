using System.Security.Claims;
using Microsoft.AspNetCore.Authentication.MicrosoftAccount;

namespace SpecPour.Modules.Identity.Infrastructure.ExternalProviders;

public sealed class MicrosoftExternalIdentityProviderAdapter : IExternalIdentityProviderPort
{
    public string ProviderKey => "microsoft";

    public string AuthenticationScheme => MicrosoftAccountDefaults.AuthenticationScheme;

    public ExternalIdentity Normalize(ClaimsPrincipal principal) => new(
        Subject: principal.FindFirstValue(ClaimTypes.NameIdentifier) ?? throw new InvalidOperationException("Microsoft identity has no subject claim."),
        Email: principal.FindFirstValue(ClaimTypes.Email),
        DisplayName: principal.FindFirstValue(ClaimTypes.Name));
}
