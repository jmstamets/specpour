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

    private static string DescribeErrors(Json.Schema.EvaluationResults result, string body)
    {
        var errors = (result.Details ?? [])
            .Where(d => !d.IsValid)
            .SelectMany(d => (d.Errors ?? new Dictionary<string, string>()).Select(e => $"{d.InstanceLocation}: {e.Key} = {e.Value}"));
        return $"Response body: {body}\nSchema violations:\n{string.Join('\n', errors)}";
    }
}
