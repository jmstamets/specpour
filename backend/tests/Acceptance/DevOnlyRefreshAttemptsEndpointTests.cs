using System.Net;
using System.Net.Http.Json;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.WebUtilities;
using Microsoft.Extensions.Hosting;
using SpecPour.Tests.Acceptance.Support;

namespace SpecPour.Tests.Acceptance;

/// <summary>
/// ADR-0005 (T177 #100) hygiene rider: /dev/refresh-attempts (and the
/// RefreshAttemptCounter increment it reads) exist purely to make the cross-tab
/// election mechanism test assertable — they must never be an observable
/// production surface (John's rider). Uses its OWN Production-configured host
/// (WithWebHostBuilder(UseEnvironment), same "own separately-constructed
/// instance" pattern RateLimitingTests already established for an
/// environment-shaped concern the shared AcceptanceHooks.Factory doesn't
/// exercise) rather than the shared Development-configured host every other
/// acceptance test runs against.
///
/// [Collection] pins this to the same collection as RateLimitingTests (see its
/// correctness note) so the two never boot their own separate factories
/// concurrently — both re-run OpenIddictClientSeedingHostedService's sync against
/// the same seeded application row on every start, and without this, running
/// them together reproduced a DbUpdateConcurrencyException 5/5 times.
/// </summary>
[Collection("ReqnrollNonParallelizableFeatures")]
public sealed class DevOnlyRefreshAttemptsEndpointTests
{
    private const string Password = "correct horse battery staple";
    private const string RedirectUri = "http://localhost:5001/connect/spa-callback";

    [Fact]
    public async Task TheEndpointDoesNotExistUnderProduction()
    {
        using var factory = new SpecPourWebApplicationFactory(AcceptanceHooks.ConnectionString)
            .WithWebHostBuilder(builder => builder.UseEnvironment(Environments.Production));
        using var client = factory.CreateClient();

        // No auth header at all — if the route existed, an authorization failure
        // (401) would prove the endpoint is mapped-but-gated; 404 proves the
        // route itself was never registered under Production, matching
        // TokenEndpoints.Map's `if (IsDevelopment())` guard around MapGet.
        var response = await client.GetAsync(new Uri("/dev/refresh-attempts", UriKind.Relative));

        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
    }

    [Fact]
    public async Task TheAttemptCounterIsInertAndDoesNotDisruptARealRefreshUnderProduction()
    {
        using var factory = new SpecPourWebApplicationFactory(AcceptanceHooks.ConnectionString)
            .WithWebHostBuilder(builder => builder.UseEnvironment(Environments.Production));

        // A real register -> authorization_code -> refresh_token round trip under
        // the Production-configured host: proves the environment check inside
        // TokenEndpoints.HandleTokenAsync (skip incrementing the Development-only
        // counter) doesn't throw or otherwise disrupt the real refresh path when
        // it's skipped — "inert" demonstrated by the ordinary flow completing
        // normally, not by reading a counter that (by design, per the first Fact
        // above) has no readable surface under Production at all.
        using var sessionClient = factory.CreateClient(new WebApplicationFactoryClientOptions { AllowAutoRedirect = false });
        var email = $"devgate-{Guid.NewGuid():N}@example.test";

        var registerResponse = await sessionClient.PostAsJsonAsync(
            new Uri("/api/v1/auth/register", UriKind.Relative),
            new
            {
                email,
                password = Password,
                displayName = "Dev Gate Test User",
                dateOfBirth = DateOnly.FromDateTime(DateTime.UtcNow.AddYears(-30))
                    .ToString("yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture),
            });
        Assert.True(registerResponse.IsSuccessStatusCode, await registerResponse.Content.ReadAsStringAsync());

        var (_, refreshToken) = await AcquireTokenPairAsync(sessionClient);

        using var refreshClient = factory.CreateClient();
        var refreshResponse = await refreshClient.PostAsync(
            new Uri("/connect/token", UriKind.Relative),
            new FormUrlEncodedContent(new Dictionary<string, string>
            {
                ["grant_type"] = "refresh_token",
                ["refresh_token"] = refreshToken,
                ["client_id"] = "specpour-app",
            }));

        Assert.True(refreshResponse.IsSuccessStatusCode, await refreshResponse.Content.ReadAsStringAsync());
    }

    private static async Task<(string AccessToken, string RefreshToken)> AcquireTokenPairAsync(HttpClient client)
    {
        var codeVerifier = Convert.ToBase64String(RandomNumberGenerator.GetBytes(32)).TrimEnd('=').Replace('+', '-').Replace('/', '_');
        var codeChallenge = Convert.ToBase64String(SHA256.HashData(Encoding.ASCII.GetBytes(codeVerifier))).TrimEnd('=').Replace('+', '-').Replace('/', '_');

        var authorizeUri = QueryHelpers.AddQueryString("/connect/authorize", new Dictionary<string, string?>
        {
            ["client_id"] = "specpour-app",
            ["response_type"] = "code",
            ["redirect_uri"] = RedirectUri,
            ["scope"] = "openid email profile offline_access",
            ["code_challenge"] = codeChallenge,
            ["code_challenge_method"] = "S256",
            ["state"] = Guid.NewGuid().ToString("N"),
        });

        var authorizeResponse = await client.GetAsync(new Uri(authorizeUri, UriKind.Relative));
        var location = authorizeResponse.Headers.Location
            ?? throw new InvalidOperationException($"/connect/authorize did not redirect (status {authorizeResponse.StatusCode}).");
        var code = QueryHelpers.ParseQuery(location.Query)["code"].ToString();

        var tokenResponse = await client.PostAsync(
            new Uri("/connect/token", UriKind.Relative),
            new FormUrlEncodedContent(new Dictionary<string, string>
            {
                ["grant_type"] = "authorization_code",
                ["code"] = code,
                ["redirect_uri"] = RedirectUri,
                ["client_id"] = "specpour-app",
                ["code_verifier"] = codeVerifier,
            }));

        var tokenBody = await tokenResponse.Content.ReadAsStringAsync();
        if (!tokenResponse.IsSuccessStatusCode)
        {
            throw new InvalidOperationException($"/connect/token failed ({tokenResponse.StatusCode}): {tokenBody}");
        }

        using var tokenJson = JsonDocument.Parse(tokenBody);
        return (
            tokenJson.RootElement.GetProperty("access_token").GetString()!,
            tokenJson.RootElement.GetProperty("refresh_token").GetString()!);
    }
}
