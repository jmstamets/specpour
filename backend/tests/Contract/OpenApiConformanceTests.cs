using System.Net.Http.Json;
using SpecPour.Tests.Contract.Support;

namespace SpecPour.Tests.Contract;

/// <summary>
/// T027: validates every currently-implemented endpoint's actual HTTP response
/// against its documented schema in contracts/openapi/. New endpoints are added to
/// this suite as each story's own contract-first path lands — it never falls behind
/// because CI's client-regen-drift-check already fails a commit that adds an
/// endpoint without a matching contract; this suite catches the next failure mode,
/// where the contract and the implementation silently disagree on shape.
/// </summary>
[Collection(ComposedHostCollection.Name)]
public sealed class OpenApiConformanceTests(ComposedHostFixture host)
{
    [Fact]
    public async Task GetMyEntitlements_conforms_to_its_schema()
    {
        var response = await host.Client.GetAsync(new Uri("/api/v1/me/entitlements", UriKind.Relative));
        var body = await response.Content.ReadAsStringAsync();

        var result = await OpenApiResponseValidator.ValidateAsync("GET", "/api/v1/me/entitlements", (int)response.StatusCode, body);

        Assert.True(result.IsValid, DescribeErrors(result, body));
    }

    [Fact]
    public async Task GetAgeGate_conforms_to_its_schema()
    {
        var response = await host.Client.GetAsync(new Uri("/api/v1/compliance/age-gate?surface=registration", UriKind.Relative));
        var body = await response.Content.ReadAsStringAsync();

        var result = await OpenApiResponseValidator.ValidateAsync("GET", "/api/v1/compliance/age-gate", (int)response.StatusCode, body);

        Assert.True(result.IsValid, DescribeErrors(result, body));
    }

    [Fact]
    public async Task GetInbox_without_a_token_conforms_to_its_401_schema()
    {
        var response = await host.Client.GetAsync(new Uri("/api/v1/inbox", UriKind.Relative));
        var body = await response.Content.ReadAsStringAsync();

        Assert.Equal(System.Net.HttpStatusCode.Unauthorized, response.StatusCode);

        var result = await OpenApiResponseValidator.ValidateAsync("GET", "/api/v1/inbox", (int)response.StatusCode, body);

        Assert.True(result.IsValid, DescribeErrors(result, body));
    }

    [Fact]
    public async Task PostAuthRegister_conforms_to_its_schema()
    {
        var payload = new
        {
            email = $"conformance-{Guid.NewGuid():N}@example.test",
            password = "correct horse battery staple",
            displayName = "Conformance Test",
            dateOfBirth = "1990-01-01",
        };

        // Fresh client: registering sets a cookie, and host.Client is shared across
        // every test in this fixture — other tests assume anonymous state on it.
        using var client = host.CreateFreshClient();
        var response = await client.PostAsJsonAsync(new Uri("/api/v1/auth/register", UriKind.Relative), payload);
        var body = await response.Content.ReadAsStringAsync();

        Assert.Equal(System.Net.HttpStatusCode.Created, response.StatusCode);
        Assert.DoesNotContain("dateOfBirth", body, StringComparison.OrdinalIgnoreCase);

        var result = await OpenApiResponseValidator.ValidateAsync("POST", "/api/v1/auth/register", (int)response.StatusCode, body);

        Assert.True(result.IsValid, DescribeErrors(result, body));
    }

    [Fact]
    public async Task PostAuthRegister_underage_conforms_to_its_403_schema()
    {
        var payload = new
        {
            email = $"conformance-underage-{Guid.NewGuid():N}@example.test",
            password = "correct horse battery staple",
            displayName = "Conformance Test",
            dateOfBirth = DateTime.UtcNow.AddYears(-10).ToString("yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture),
        };

        var response = await host.Client.PostAsJsonAsync(new Uri("/api/v1/auth/register", UriKind.Relative), payload);
        var body = await response.Content.ReadAsStringAsync();

        Assert.Equal(System.Net.HttpStatusCode.Forbidden, response.StatusCode);

        var result = await OpenApiResponseValidator.ValidateAsync("POST", "/api/v1/auth/register", (int)response.StatusCode, body);

        Assert.True(result.IsValid, DescribeErrors(result, body));
    }

    [Fact]
    public async Task PostAuthLogin_conforms_to_its_401_schema()
    {
        var payload = new { email = "no-such-user@example.test", password = "whatever12345" };

        var response = await host.Client.PostAsJsonAsync(new Uri("/api/v1/auth/login", UriKind.Relative), payload);
        var body = await response.Content.ReadAsStringAsync();

        Assert.Equal(System.Net.HttpStatusCode.Unauthorized, response.StatusCode);

        var result = await OpenApiResponseValidator.ValidateAsync("POST", "/api/v1/auth/login", (int)response.StatusCode, body);

        Assert.True(result.IsValid, DescribeErrors(result, body));
    }

    [Fact]
    public async Task PostAuthLogin_conforms_to_its_200_schema()
    {
        var email = $"conformance-login-{Guid.NewGuid():N}@example.test";
        const string password = "correct horse battery staple";

        // Fresh clients throughout: host.Client is shared across every test in this
        // fixture, and registering/signing in sets a cookie — using it here would
        // leak a signed-in session onto other tests that assume anonymous state.
        using var registrationClient = host.CreateFreshClient();
        await registrationClient.PostAsJsonAsync(
            new Uri("/api/v1/auth/register", UriKind.Relative),
            new { email, password, displayName = "Conformance Login Test", dateOfBirth = "1990-01-01" });

        using var freshClient = host.CreateFreshClient();
        var response = await freshClient.PostAsJsonAsync(new Uri("/api/v1/auth/login", UriKind.Relative), new { email, password });
        var body = await response.Content.ReadAsStringAsync();

        Assert.Equal(System.Net.HttpStatusCode.OK, response.StatusCode);
        Assert.DoesNotContain("dateOfBirth", body, StringComparison.OrdinalIgnoreCase);

        var result = await OpenApiResponseValidator.ValidateAsync("POST", "/api/v1/auth/login", (int)response.StatusCode, body);

        Assert.True(result.IsValid, DescribeErrors(result, body));
    }

    [Fact]
    public async Task PostAuthRecovery_conforms_to_its_202_schema()
    {
        // No-such-account case: still 202 (no account enumeration), same generic-failure
        // rationale as PostAuthLogin_conforms_to_its_401_schema.
        var payload = new { email = "no-such-user@example.test" };

        var response = await host.Client.PostAsJsonAsync(new Uri("/api/v1/auth/recovery", UriKind.Relative), payload);

        // No response body to validate against a schema (202 with no content, both in
        // the contract and the implementation) — the status code itself is the contract.
        Assert.Equal(System.Net.HttpStatusCode.Accepted, response.StatusCode);
    }

    [Fact]
    public async Task PostAuthRecoveryConfirm_invalid_conforms_to_its_400_schema()
    {
        var payload = new { email = "no-such-user@example.test", token = "not-a-real-token", newPassword = "correct horse battery staple" };

        var response = await host.Client.PostAsJsonAsync(new Uri("/api/v1/auth/recovery/confirm", UriKind.Relative), payload);
        var body = await response.Content.ReadAsStringAsync();

        Assert.Equal(System.Net.HttpStatusCode.BadRequest, response.StatusCode);

        var result = await OpenApiResponseValidator.ValidateAsync("POST", "/api/v1/auth/recovery/confirm", (int)response.StatusCode, body);

        Assert.True(result.IsValid, DescribeErrors(result, body));
    }

    [Fact]
    public async Task PostAuthLoginMfa_without_a_pending_challenge_conforms_to_its_400_schema()
    {
        using var client = host.CreateFreshClient();
        var response = await client.PostAsJsonAsync(new Uri("/api/v1/auth/login/mfa", UriKind.Relative), new { code = "000000" });
        var body = await response.Content.ReadAsStringAsync();

        Assert.Equal(System.Net.HttpStatusCode.BadRequest, response.StatusCode);

        var result = await OpenApiResponseValidator.ValidateAsync("POST", "/api/v1/auth/login/mfa", (int)response.StatusCode, body);

        Assert.True(result.IsValid, DescribeErrors(result, body));
    }

    [Fact]
    public async Task GetMeMfa_without_a_token_conforms_to_its_401_schema()
    {
        var response = await host.Client.GetAsync(new Uri("/api/v1/me/mfa", UriKind.Relative));
        var body = await response.Content.ReadAsStringAsync();

        Assert.Equal(System.Net.HttpStatusCode.Unauthorized, response.StatusCode);

        var result = await OpenApiResponseValidator.ValidateAsync("GET", "/api/v1/me/mfa", (int)response.StatusCode, body);

        Assert.True(result.IsValid, DescribeErrors(result, body));
    }

    [Fact]
    public async Task PostMeMfaBackupCodes_without_a_token_conforms_to_its_401_schema()
    {
        var response = await host.Client.PostAsync(new Uri("/api/v1/me/mfa/backup-codes", UriKind.Relative), content: null);
        var body = await response.Content.ReadAsStringAsync();

        Assert.Equal(System.Net.HttpStatusCode.Unauthorized, response.StatusCode);

        var result = await OpenApiResponseValidator.ValidateAsync("POST", "/api/v1/me/mfa/backup-codes", (int)response.StatusCode, body);

        Assert.True(result.IsValid, DescribeErrors(result, body));
    }

    [Fact]
    public async Task GetAuthExternal_for_an_unconfigured_provider_conforms_to_its_400_schema()
    {
        // T049: no ExternalProviders:* credentials exist in any test environment (real
        // Google/Apple/Microsoft app registrations aren't available here) — every
        // provider is genuinely unconfigured, exercising the real "unknown provider"
        // rejection path rather than a fake/mocked one.
        var response = await host.Client.GetAsync(new Uri("/api/v1/auth/external/google?redirectUri=/", UriKind.Relative));
        var body = await response.Content.ReadAsStringAsync();

        Assert.Equal(System.Net.HttpStatusCode.BadRequest, response.StatusCode);

        var result = await OpenApiResponseValidator.ValidateAsync("GET", "/api/v1/auth/external/google", (int)response.StatusCode, body);

        Assert.True(result.IsValid, DescribeErrors(result, body));
    }

    [Fact]
    public async Task PostAuthExternalCompleteRegistration_without_a_pending_sign_in_conforms_to_its_400_schema()
    {
        var payload = new { dateOfBirth = "1990-01-01", displayName = "Someone" };

        using var client = host.CreateFreshClient();
        var response = await client.PostAsJsonAsync(new Uri("/api/v1/auth/external/complete-registration", UriKind.Relative), payload);
        var body = await response.Content.ReadAsStringAsync();

        Assert.Equal(System.Net.HttpStatusCode.BadRequest, response.StatusCode);

        var result = await OpenApiResponseValidator.ValidateAsync("POST", "/api/v1/auth/external/complete-registration", (int)response.StatusCode, body);

        Assert.True(result.IsValid, DescribeErrors(result, body));
    }

    private static string DescribeErrors(Json.Schema.EvaluationResults result, string body)
    {
        var errors = (result.Details ?? [])
            .Where(d => !d.IsValid)
            .SelectMany(d => (d.Errors ?? new Dictionary<string, string>()).Select(e => $"{d.InstanceLocation}: {e.Key} = {e.Value}"));
        return $"Response body: {body}\nSchema violations:\n{string.Join('\n', errors)}";
    }
}
