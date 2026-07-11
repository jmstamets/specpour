using Reqnroll;
using SpecPour.Tests.Acceptance.Support;

namespace SpecPour.Tests.Acceptance.Features.Steps;

[Binding]
public sealed class HarnessSmokeSteps
{
    private HttpResponseMessage _response = null!;
    private string _responseBody = string.Empty;

    [When(@"I request ""(.*)""")]
    public async Task WhenIRequestAsync(string path)
    {
        using var client = AcceptanceHooks.Factory.CreateClient();
        _response = await client.GetAsync(new Uri(path, UriKind.Relative));
        _responseBody = await _response.Content.ReadAsStringAsync();
    }

    [Then(@"the response status is (\d+)")]
    public void ThenTheResponseStatusIs(int statusCode) =>
        Assert.Equal(statusCode, (int)_response.StatusCode);

    [Then(@"the response body contains ""(.*)""")]
    public void ThenTheResponseBodyContains(string expected) =>
        Assert.Contains(expected, _responseBody, StringComparison.Ordinal);
}
