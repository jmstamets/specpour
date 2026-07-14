using System.Security.Claims;

namespace SpecPour.Modules.Identity.Infrastructure.ExternalProviders;

/// <summary>
/// T049: one implementation per social sign-in provider (Google, Apple, Microsoft).
/// Token validation and the OAuth handshake itself are handled by each provider's own
/// proven ASP.NET Core authentication handler (R6) — this port's only job is
/// normalizing the resulting <see cref="ClaimsPrincipal"/> into a common shape, since
/// each provider maps its identity claims slightly differently (most notably Apple,
/// which only ever supplies email/name on the caller's very first authorization).
/// </summary>
public interface IExternalIdentityProviderPort
{
    /// <summary>Matches the lowercase key stored in ASP.NET Identity's own AspNetUserLogins.LoginProvider (data-model.md ExternalLogin.provider key) and the {provider} route segment.</summary>
    string ProviderKey { get; }

    /// <summary>The ASP.NET Core authentication scheme name this provider's handler was registered under (IdentityModule.RegisterServices).</summary>
    string AuthenticationScheme { get; }

    ExternalIdentity Normalize(ClaimsPrincipal principal);
}

/// <summary>Email/DisplayName may be null — not every provider (notably Apple) reliably supplies them.</summary>
public sealed record ExternalIdentity(string Subject, string? Email, string? DisplayName);
