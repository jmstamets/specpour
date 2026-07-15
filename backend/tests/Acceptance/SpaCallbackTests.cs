using System.Net;
using SpecPour.Tests.Acceptance.Support;

namespace SpecPour.Tests.Acceptance;

/// <summary>
/// T174 (#1 rider): the web PKCE landing endpoint (/connect/spa-callback) receives
/// the one-time authorization code in its URL, so its response must be non-cacheable.
/// The rest of the PKCE guarantees are covered elsewhere: the code-verifier exchange
/// is enforced by OpenIddict's RequireProofKeyForCodeExchange and exercised end-to-end
/// by US02IdentitySteps.AcquireAccessTokenAsync; `state` validation happens client-side
/// in web_authorize.dart and is exercised by the headless-Chrome registration test.
/// </summary>
public sealed class SpaCallbackTests
{
    [Fact]
    public async Task Spa_callback_response_is_non_cacheable()
    {
        using var client = AcceptanceHooks.Factory.CreateClient();

        var response = await client.GetAsync(new Uri("/connect/spa-callback?code=example", UriKind.Relative));

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        Assert.Contains("no-store", response.Headers.CacheControl?.ToString() ?? string.Empty, StringComparison.OrdinalIgnoreCase);
    }
}
