using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using OpenIddict.Server;
using SpecPour.Tests.Acceptance.Support;

namespace SpecPour.Tests.Acceptance;

/// <summary>
/// John's ruling (2026-07-14) on the T051/T052 session-revocation gap: self-contained
/// access tokens are validated locally with no per-request DB check, so revoking a
/// session/deactivating an account only blocks future refresh grants — it cannot kill
/// an already-issued access token. A short access-token lifetime bounds that exposure
/// window; this test is the "config assertion" half of the ruling's Rider 1 (the
/// behavioral half — refresh actually gets rejected on revoke — is covered by
/// US02_Identity.feature scenarios 15/16). Asserts the real running configuration, not
/// just the IdentityModule.cs source line, so a future edit that silently regresses
/// the lifetime fails here.
/// </summary>
public sealed class TokenLifetimeTests
{
    [Fact]
    public void AccessTokenLifetimeIsBoundedToTenMinutesOrLess()
    {
        var options = AcceptanceHooks.Factory.Services
            .GetRequiredService<IOptionsMonitor<OpenIddictServerOptions>>()
            .CurrentValue;

        Assert.NotNull(options.AccessTokenLifetime);
        Assert.True(
            options.AccessTokenLifetime <= TimeSpan.FromMinutes(10),
            $"Access token lifetime must stay bounded to limit the post-revocation exposure window; was {options.AccessTokenLifetime}.");
    }
}
