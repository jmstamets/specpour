using System.Net.Http.Json;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.WebUtilities;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Reqnroll;
using SpecPour.Modules.Notifications.Domain;
using SpecPour.Modules.Notifications.Infrastructure;
using SpecPour.Tests.Acceptance.Support;

namespace SpecPour.Tests.Acceptance.Features.Steps;

/// <summary>
/// T151: inbox-read and channel-preference acceptance steps. Own copy of the
/// register+PKCE-token-acquisition helper (same duplication convention as every
/// other feature file's [Binding] class — see US02IdentitySteps' identical
/// comment) rather than reaching into US02IdentitySteps' private state, since
/// Reqnroll step bindings resolve across the whole assembly and "Given a
/// registered adult user" is already bound there.
/// </summary>
[Binding]
public sealed class NotificationsSteps
{
    private const string RedirectUri = "http://localhost:5173/callback";
    private const string ClientId = "specpour-app";

    private HttpClient _sessionClient = null!;
    private Guid _userId;
    private string _accessToken = string.Empty;
    private HttpResponseMessage _lastResponse = null!;
    private JsonDocument? _lastJson;
    private Guid _inboxMessageId;
    private DateTimeOffset? _firstReadAt;

    [Given(@"a signed-up user")]
    public async Task GivenASignedUpUser()
    {
        _sessionClient = AcceptanceHooks.Factory.CreateClient(new WebApplicationFactoryClientOptions { AllowAutoRedirect = false });

        var email = $"notif-{Guid.NewGuid():N}@example.test";
        var response = await _sessionClient.PostAsJsonAsync(
            new Uri("/api/v1/auth/register", UriKind.Relative),
            new
            {
                email,
                password = "correct horse battery staple",
                displayName = "Notifications Test User",
                dateOfBirth = DateOnly.FromDateTime(DateTime.UtcNow.AddYears(-30)).ToString("yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture),
            });
        var body = await response.Content.ReadAsStringAsync();
        if (!response.IsSuccessStatusCode)
        {
            throw new InvalidOperationException($"Registration failed ({response.StatusCode}): {body}");
        }

        using var registerJson = JsonDocument.Parse(body);
        _userId = registerJson.RootElement.GetProperty("userId").GetGuid();
        _accessToken = await AcquireAccessTokenAsync();
    }

    [Given(@"an inbox message exists for the signed-up user")]
    public async Task GivenAnInboxMessageExistsForTheSignedUpUser()
    {
        using var scope = AcceptanceHooks.Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<NotificationsDbContext>();
        var clock = scope.ServiceProvider.GetRequiredService<SpecPour.BuildingBlocks.Time.IClock>();

        var message = new InboxMessage
        {
            Id = Guid.NewGuid(),
            UserId = _userId,
            Type = "prep_expiry",
            PayloadJson = "{}",
            CreatedAt = clock.UtcNow,
        };
        db.InboxMessages.Add(message);
        await db.SaveChangesAsync();
        _inboxMessageId = message.Id;
    }

    [When(@"the signed-up user fetches their channel preferences")]
    public async Task WhenTheSignedUpUserFetchesTheirChannelPreferences() => await GetChannelsAsync();

    [Then(@"both notification channels are present and opted out")]
    public void ThenBothNotificationChannelsArePresentAndOptedOut()
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        var channels = _lastJson!.RootElement.GetProperty("channels").EnumerateArray().ToList();
        Assert.Equal(2, channels.Count);
        Assert.All(channels, c => Assert.False(c.GetProperty("optedIn").GetBoolean()));
    }

    [When(@"the signed-up user opts into the email channel")]
    public async Task WhenTheSignedUpUserOptsIntoTheEmailChannel()
    {
        using var client = AuthorizedClient();
        _lastResponse = await client.PutAsJsonAsync(
            new Uri("/api/v1/me/channels", UriKind.Relative),
            new { channels = new[] { new { channel = "email", optedIn = true } } });
    }

    [Then(@"the signed-up user's channel preferences show email opted in")]
    public async Task ThenTheSignedUpUsersChannelPreferencesShowEmailOptedIn()
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);

        await GetChannelsAsync();
        var channels = _lastJson!.RootElement.GetProperty("channels").EnumerateArray().ToList();
        var email = channels.Single(c => c.GetProperty("channel").GetString() == "email");
        Assert.True(email.GetProperty("optedIn").GetBoolean());
    }

    [When(@"the signed-up user tries to update an unrecognized channel")]
    public async Task WhenTheSignedUpUserTriesToUpdateAnUnrecognizedChannel()
    {
        using var client = AuthorizedClient();
        _lastResponse = await client.PutAsJsonAsync(
            new Uri("/api/v1/me/channels", UriKind.Relative),
            new { channels = new[] { new { channel = "carrier_pigeon", optedIn = true } } });
    }

    [Then(@"the channel update attempt is rejected")]
    public void ThenTheChannelUpdateAttemptIsRejected() => Assert.Equal(400, (int)_lastResponse.StatusCode);

    [When(@"the signed-up user marks that inbox message as read")]
    [When(@"the signed-up user marks that inbox message as read again")]
    public async Task WhenTheSignedUpUserMarksThatInboxMessageAsRead()
    {
        using var client = AuthorizedClient();
        _lastResponse = await client.PostAsync(new Uri($"/api/v1/inbox/{_inboxMessageId}/read", UriKind.Relative), content: null);

        // Captured on the first call only, regardless of which scenario is
        // running — scenario 5's "unchanged from the first mark" assertion needs
        // this even though it never reaches the "shows as read" Then step below.
        _firstReadAt ??= await FetchReadAtAsync();
    }

    [Then(@"the inbox message shows as read")]
    public void ThenTheInboxMessageShowsAsRead()
    {
        Assert.Equal(204, (int)_lastResponse.StatusCode);
        Assert.NotNull(_firstReadAt);
    }

    [When(@"notification time passes")]
    public static void WhenNotificationTimePasses() => AcceptanceHooks.Factory.Clock.Advance(TimeSpan.FromMinutes(5));

    [Then(@"the inbox message's read time is unchanged from the first mark")]
    public async Task ThenTheInboxMessagesReadTimeIsUnchangedFromTheFirstMark()
    {
        Assert.Equal(204, (int)_lastResponse.StatusCode);

        var readAt = await FetchReadAtAsync();
        Assert.Equal(_firstReadAt, readAt);
    }

    private async Task<DateTimeOffset?> FetchReadAtAsync()
    {
        using var client = AuthorizedClient();
        var response = await client.GetAsync(new Uri("/api/v1/inbox", UriKind.Relative));
        using var json = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
        var item = json.RootElement.GetProperty("items").EnumerateArray()
            .Single(i => i.GetProperty("id").GetGuid() == _inboxMessageId);
        var readAtProperty = item.GetProperty("readAt");
        return readAtProperty.ValueKind == JsonValueKind.Null ? null : readAtProperty.GetDateTimeOffset();
    }

    private async Task GetChannelsAsync()
    {
        using var client = AuthorizedClient();
        _lastResponse = await client.GetAsync(new Uri("/api/v1/me/channels", UriKind.Relative));
        var body = await _lastResponse.Content.ReadAsStringAsync();
        _lastJson?.Dispose();
        _lastJson = JsonDocument.Parse(body);
    }

    private HttpClient AuthorizedClient()
    {
        var client = AcceptanceHooks.Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _accessToken);
        return client;
    }

    private async Task<string> AcquireAccessTokenAsync()
    {
        var codeVerifier = Convert.ToBase64String(RandomNumberGenerator.GetBytes(32)).TrimEnd('=').Replace('+', '-').Replace('/', '_');
        var codeChallenge = Convert.ToBase64String(SHA256.HashData(Encoding.ASCII.GetBytes(codeVerifier))).TrimEnd('=').Replace('+', '-').Replace('/', '_');

        var authorizeUri = QueryHelpers.AddQueryString("/connect/authorize", new Dictionary<string, string?>
        {
            ["client_id"] = ClientId,
            ["response_type"] = "code",
            ["redirect_uri"] = RedirectUri,
            ["scope"] = "openid email profile offline_access",
            ["code_challenge"] = codeChallenge,
            ["code_challenge_method"] = "S256",
            ["state"] = Guid.NewGuid().ToString("N"),
        });

        var authorizeResponse = await _sessionClient.GetAsync(new Uri(authorizeUri, UriKind.Relative));
        var location = authorizeResponse.Headers.Location
            ?? throw new InvalidOperationException($"/connect/authorize did not redirect (status {authorizeResponse.StatusCode}).");
        var code = QueryHelpers.ParseQuery(location.Query)["code"].ToString();
        if (string.IsNullOrEmpty(code))
        {
            throw new InvalidOperationException($"No authorization code in redirect: {location}");
        }

        var tokenResponse = await _sessionClient.PostAsync(
            new Uri("/connect/token", UriKind.Relative),
            new FormUrlEncodedContent(new Dictionary<string, string>
            {
                ["grant_type"] = "authorization_code",
                ["code"] = code,
                ["redirect_uri"] = RedirectUri,
                ["client_id"] = ClientId,
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
}
