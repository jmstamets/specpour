using System.Net.Http.Json;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.WebUtilities;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Reqnroll;
using SpecPour.Modules.Authorization.Infrastructure;
using SpecPour.Modules.Identity.Contracts;
using SpecPour.Modules.Identity.Infrastructure;
using SpecPour.Tests.Acceptance.Support;

namespace SpecPour.Tests.Acceptance.Features.Steps;

/// <summary>
/// T045: US2 acceptance steps. Registration/login exercise the real HTTP surface
/// (AuthEndpoints); AcquireAccessTokenAsync drives the actual authorization-code+PKCE
/// exchange against /connect/authorize + /connect/token (ADR-0003) in C#, standing in
/// for what the Flutter client (T055) will do, so entitlements/predicate scenarios can
/// be verified against a real bearer token rather than stubbed.
/// </summary>
[Binding]
public sealed class US02IdentitySteps
{
    private const string Password = "correct horse battery staple";
    private const string RedirectUri = "http://localhost:5173/callback";

    private HttpResponseMessage _lastResponse = null!;
    private JsonDocument? _lastJson;
    private string _lastResponseBody = string.Empty;
    private string _registeredEmail = string.Empty;
    private Guid _registeredUserId;
    private HttpClient? _sessionClient;

    [When(@"a visitor registers with a valid adult date of birth")]
    public async Task WhenAVisitorRegistersWithAValidAdultDateOfBirth() =>
        await RegisterAsync(DateOnly.FromDateTime(DateTime.UtcNow.AddYears(-30)));

    [When(@"a visitor registers with an underage date of birth")]
    public async Task WhenAVisitorRegistersWithAnUnderageDateOfBirth() =>
        await RegisterAsync(DateOnly.FromDateTime(DateTime.UtcNow.AddYears(-10)));

    private async Task RegisterAsync(DateOnly dateOfBirth)
    {
        _registeredEmail = $"us02-{Guid.NewGuid():N}@example.test";
        _sessionClient = NewClientWithoutRedirects();

        _lastResponse = await _sessionClient.PostAsJsonAsync(
            new Uri("/api/v1/auth/register", UriKind.Relative),
            new
            {
                email = _registeredEmail,
                password = Password,
                displayName = "US2 Test User",
                dateOfBirth = dateOfBirth.ToString("yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture),
            });
        await CaptureJsonAsync();

        if (_lastResponse.IsSuccessStatusCode)
        {
            _registeredUserId = _lastJson!.RootElement.GetProperty("userId").GetGuid();
        }
    }

    [Then(@"the account is created")]
    public void ThenTheAccountIsCreated() => Assert.Equal(201, (int)_lastResponse.StatusCode);

    [Then(@"the stored date of birth is encrypted, never the plaintext value")]
    public async Task ThenTheStoredDateOfBirthIsEncryptedNeverThePlaintextValue()
    {
        using var scope = AcceptanceHooks.Factory.Services.CreateScope();
        var identityDb = scope.ServiceProvider.GetRequiredService<IdentityDbContext>();
        var user = await identityDb.Users.SingleAsync(u => u.Id == _registeredUserId);

        Assert.False(string.IsNullOrWhiteSpace(user.EncryptedDateOfBirth));
        Assert.DoesNotContain("-30", user.EncryptedDateOfBirth, StringComparison.Ordinal);
        Assert.DoesNotContain(DateTime.UtcNow.AddYears(-30).Year.ToString(System.Globalization.CultureInfo.InvariantCulture), user.EncryptedDateOfBirth, StringComparison.Ordinal);
    }

    [Then(@"the registration response never contains a date of birth")]
    public void ThenTheRegistrationResponseNeverContainsADateOfBirth() =>
        Assert.DoesNotContain("dateOfBirth", _lastResponseBody, StringComparison.OrdinalIgnoreCase);

    [Then(@"the registration is rejected")]
    public void ThenTheRegistrationIsRejected() => Assert.Equal(403, (int)_lastResponse.StatusCode);

    [Then(@"no account exists for that attempt")]
    public async Task ThenNoAccountExistsForThatAttempt()
    {
        using var scope = AcceptanceHooks.Factory.Services.CreateScope();
        var identityDb = scope.ServiceProvider.GetRequiredService<IdentityDbContext>();
        var exists = await identityDb.Users.AnyAsync(u => u.Email == _registeredEmail);
        Assert.False(exists, "FR-002c: an underage attempt must persist no identifying record.");
    }

    [Given(@"a registered adult user")]
    public async Task GivenARegisteredAdultUser() =>
        await RegisterAsync(DateOnly.FromDateTime(DateTime.UtcNow.AddYears(-30)));

    [When(@"the user signs in with their password")]
    public async Task WhenTheUserSignsInWithTheirPassword()
    {
        using var freshClient = NewClientWithoutRedirects();
        _lastResponse = await freshClient.PostAsJsonAsync(
            new Uri("/api/v1/auth/login", UriKind.Relative),
            new { email = _registeredEmail, password = Password });
        await CaptureJsonAsync();
    }

    [Then(@"the sign-in succeeds")]
    public void ThenTheSignInSucceeds() => Assert.Equal(200, (int)_lastResponse.StatusCode);

    [When(@"the user requests account recovery")]
    public async Task WhenTheUserRequestsAccountRecovery()
    {
        // T050 (not yet built) — expected to 404 until recovery lands.
        using var client = AcceptanceHooks.Factory.CreateClient();
        _lastResponse = await client.PostAsJsonAsync(new Uri("/api/v1/auth/recovery", UriKind.Relative), new { email = _registeredEmail });
    }

    [Then(@"the recovery request is accepted")]
    public void ThenTheRecoveryRequestIsAccepted() => Assert.Equal(202, (int)_lastResponse.StatusCode);

    [When(@"the user requests their data export")]
    public async Task WhenTheUserRequestsTheirDataExport()
    {
        // T053 (not yet built) — expected to 404 until export lands.
        var token = await AcquireAccessTokenAsync();
        using var client = AcceptanceHooks.Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        _lastResponse = await client.GetAsync(new Uri("/api/v1/me/export", UriKind.Relative));
        await CaptureJsonAsync();
    }

    [Then(@"the export includes their date of birth")]
    public void ThenTheExportIncludesTheirDateOfBirth()
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        Assert.Contains("dateOfBirth", _lastResponseBody, StringComparison.OrdinalIgnoreCase);
    }

    [When(@"the user requests account deletion")]
    public async Task WhenTheUserRequestsAccountDeletion()
    {
        // T053 (not yet built) — expected to 404 until deletion lands.
        var token = await AcquireAccessTokenAsync();
        using var client = AcceptanceHooks.Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        _lastResponse = await client.DeleteAsync(new Uri("/api/v1/me", UriKind.Relative));
    }

    [Then(@"the account is deleted")]
    public void ThenTheAccountIsDeleted() => Assert.Equal(204, (int)_lastResponse.StatusCode);

    [When(@"the user requests their entitlements")]
    public async Task WhenTheUserRequestsTheirEntitlements()
    {
        var token = await AcquireAccessTokenAsync();
        using var client = AcceptanceHooks.Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        _lastResponse = await client.GetAsync(new Uri("/api/v1/me/entitlements", UriKind.Relative));
        await CaptureJsonAsync();
    }

    [Then(@"the entitlements reflect the default tier")]
    public void ThenTheEntitlementsReflectTheDefaultTier()
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        Assert.Equal("default", _lastJson!.RootElement.GetProperty("tier").GetString());
    }

    [When(@"a feature checks whether the user is of legal drinking age")]
    public async Task WhenAFeatureChecksWhetherTheUserIsOfLegalDrinkingAge()
    {
        using var scope = AcceptanceHooks.Factory.Services.CreateScope();
        var agePredicate = scope.ServiceProvider.GetRequiredService<IAgePredicatePort>();
        _predicateResult = await agePredicate.IsOfLegalDrinkingAgeAsync(_registeredUserId, "default", CancellationToken.None);
    }

    private bool _predicateResult;

    [Then(@"the predicate check succeeds without exposing the raw date of birth")]
    public void ThenThePredicateCheckSucceedsWithoutExposingTheRawDateOfBirth() =>
        Assert.True(_predicateResult, "A 30-year-old registrant must be of legal drinking age under the default (21) rule.");

    [Then(@"the predicate check is audit-logged")]
    public async Task ThenThePredicateCheckIsAuditLogged()
    {
        using var scope = AcceptanceHooks.Factory.Services.CreateScope();
        var authzDb = scope.ServiceProvider.GetRequiredService<AuthorizationDbContext>();
        var logged = await authzDb.AuditLogEntries.AnyAsync(e =>
            e.ActorUserId == _registeredUserId && e.ActionKey == "identity.age_predicate_checked");

        Assert.True(logged, "FR-002b: every decrypt of a stored date of birth must be audit-logged.");
    }

    /// <summary>
    /// Drives the real authorization-code+PKCE exchange (ADR-0003) against the
    /// already-cookie-authenticated <see cref="_sessionClient"/> from registration,
    /// standing in for the PKCE logic the Flutter client (T055) will implement.
    /// </summary>
    private async Task<string> AcquireAccessTokenAsync()
    {
        var client = _sessionClient ?? throw new InvalidOperationException("No signed-in session — register or sign in first.");

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
        if (string.IsNullOrEmpty(code))
        {
            throw new InvalidOperationException($"No authorization code in redirect: {location}");
        }

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
        return tokenJson.RootElement.GetProperty("access_token").GetString()!;
    }

    private static HttpClient NewClientWithoutRedirects() =>
        AcceptanceHooks.Factory.CreateClient(new WebApplicationFactoryClientOptions { AllowAutoRedirect = false });

    private async Task CaptureJsonAsync()
    {
        _lastJson?.Dispose();
        _lastJson = null;

        _lastResponseBody = await _lastResponse.Content.ReadAsStringAsync();
        if (!string.IsNullOrWhiteSpace(_lastResponseBody) && _lastResponse.Content.Headers.ContentType?.MediaType?.Contains("json", StringComparison.OrdinalIgnoreCase) == true)
        {
            _lastJson = JsonDocument.Parse(_lastResponseBody);
        }
    }
}
