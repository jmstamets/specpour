using System.Net.Http.Json;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.WebUtilities;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Reqnroll;
using SpecPour.Modules.Authorization.Infrastructure;
using SpecPour.Modules.Identity.Application.Lifecycle;
using SpecPour.Modules.Identity.Application.Mfa;
using SpecPour.Modules.Identity.Contracts;
using SpecPour.Modules.Identity.Domain;
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
    private HttpClient? _loginClient;
    private string _mfaSecret = string.Empty;
    private string _currentPassword = Password;
    private readonly List<Guid> _sessionIds = [];
    private readonly List<string> _deviceTokens = [];
    private List<string> _backupCodes = [];
    private List<string> _originalBackupCodes = [];
    private string? _lastConsumedBackupCode;
    private string? _deactivationToken;
    private string? _deactivationRefreshToken;
    private readonly List<string> _deviceRefreshTokens = [];

    [When(@"a visitor registers with a valid adult date of birth")]
    public async Task WhenAVisitorRegistersWithAValidAdultDateOfBirth() =>
        await RegisterAsync(DateOnly.FromDateTime(DateTime.UtcNow.AddYears(-30)));

    [When(@"a visitor registers with an underage date of birth")]
    public async Task WhenAVisitorRegistersWithAnUnderageDateOfBirth() =>
        await RegisterAsync(DateOnly.FromDateTime(DateTime.UtcNow.AddYears(-10)));

    private async Task RegisterAsync(DateOnly dateOfBirth)
    {
        _registeredEmail = $"us02-{Guid.NewGuid():N}@example.test";
        _currentPassword = Password;
        _sessionClient = NewClientWithoutRedirects();

        _lastResponse = await _sessionClient.PostAsJsonAsync(
            new Uri("/api/v1/auth/register", UriKind.Relative),
            new
            {
                email = _registeredEmail,
                password = _currentPassword,
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
    [When(@"the user signs in with their new password")]
    public async Task WhenTheUserSignsInWithTheirPassword()
    {
        // Kept alive (not `using`) rather than disposed at the end of this step: T050's
        // MFA-required scenario needs the same cookie jar for the follow-up
        // POST /auth/login/mfa call, which reads the interim MfaPendingScheme cookie
        // this request may set. _currentPassword tracks the live password across a
        // T163 recovery-confirm reset (see WhenTheUserResetsTheirPasswordViaAccountRecovery).
        _loginClient = NewClientWithoutRedirects();
        _lastResponse = await _loginClient.PostAsJsonAsync(
            new Uri("/api/v1/auth/login", UriKind.Relative),
            new { email = _registeredEmail, password = _currentPassword });
        await CaptureJsonAsync();
    }

    [Then(@"the sign-in succeeds")]
    public void ThenTheSignInSucceeds() => Assert.Equal(200, (int)_lastResponse.StatusCode);

    [Then(@"the sign-in requires an MFA code")]
    public void ThenTheSignInRequiresAnMfaCode()
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        Assert.True(_lastJson!.RootElement.GetProperty("requiresMfa").GetBoolean());
    }

    [When(@"the user completes sign-in with a valid MFA code")]
    public async Task WhenTheUserCompletesSignInWithAValidMfaCode()
    {
        var client = _loginClient ?? throw new InvalidOperationException("No pending login session — sign in with a password first.");
        var code = TotpCodeGenerator.ComputeCurrentCode(_mfaSecret);
        _lastResponse = await client.PostAsJsonAsync(new Uri("/api/v1/auth/login/mfa", UriKind.Relative), new { code });
        await CaptureJsonAsync();
    }

    [When(@"the user enrolls TOTP multi-factor authentication")]
    public async Task WhenTheUserEnrollsTotpMultiFactorAuthentication()
    {
        var token = await AcquireAccessTokenAsync();
        using var client = AcceptanceHooks.Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);

        var startResponse = await client.PostAsJsonAsync(new Uri("/api/v1/me/mfa", UriKind.Relative), new { });
        using var startJson = JsonDocument.Parse(await startResponse.Content.ReadAsStringAsync());
        _mfaSecret = startJson.RootElement.GetProperty("secret").GetString()!;

        var code = TotpCodeGenerator.ComputeCurrentCode(_mfaSecret);
        _lastResponse = await client.PostAsJsonAsync(new Uri("/api/v1/me/mfa", UriKind.Relative), new { code });
        await CaptureJsonAsync();

        // T163: the confirm-that-enables response carries the initial backup-code set.
        if (_lastResponse.IsSuccessStatusCode
            && _lastJson!.RootElement.TryGetProperty("backupCodes", out var backupCodesElement)
            && backupCodesElement.ValueKind == JsonValueKind.Array)
        {
            _backupCodes = [.. backupCodesElement.EnumerateArray().Select(e => e.GetString()!)];
        }
    }

    [Then(@"MFA is enabled for the account")]
    public void ThenMfaIsEnabledForTheAccount()
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        Assert.True(_lastJson!.RootElement.GetProperty("enabled").GetBoolean());
    }

    [Then(@"the enrollment secret is never shown again")]
    public async Task ThenTheEnrollmentSecretIsNeverShownAgain()
    {
        // T162 security audit, item 7c (live-HTTP half — the schema-level half is
        // MfaStatus/confirm-response simply having no populated secret field): the
        // start-enrollment response is the ONE deliberate secret-bearing surface
        // (inherent to TOTP — the authenticator app needs it once); after
        // confirmation, neither the confirm response nor GET /me/mfa may ever carry
        // the raw secret again.
        Assert.False(string.IsNullOrEmpty(_mfaSecret), "Scenario ordering bug: no enrollment secret was captured.");
        Assert.DoesNotContain(_mfaSecret, _lastResponseBody, StringComparison.Ordinal);

        var token = await AcquireAccessTokenAsync();
        using var client = AcceptanceHooks.Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        var statusResponse = await client.GetAsync(new Uri("/api/v1/me/mfa", UriKind.Relative));
        var statusBody = await statusResponse.Content.ReadAsStringAsync();

        Assert.Equal(200, (int)statusResponse.StatusCode);
        Assert.DoesNotContain(_mfaSecret, statusBody, StringComparison.Ordinal);
    }

    [Given(@"a registered adult user with MFA enabled")]
    public async Task GivenARegisteredAdultUserWithMfaEnabled()
    {
        await RegisterAsync(DateOnly.FromDateTime(DateTime.UtcNow.AddYears(-30)));
        await WhenTheUserEnrollsTotpMultiFactorAuthentication();
    }

    [When(@"the user disables MFA")]
    public async Task WhenTheUserDisablesMfa()
    {
        var token = await AcquireAccessTokenAsync();
        using var client = AcceptanceHooks.Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        _lastResponse = await client.DeleteAsync(new Uri("/api/v1/me/mfa", UriKind.Relative));
    }

    [Then(@"MFA is no longer enabled for the account")]
    public async Task ThenMfaIsNoLongerEnabledForTheAccount()
    {
        Assert.Equal(204, (int)_lastResponse.StatusCode);

        var token = await AcquireAccessTokenAsync();
        using var client = AcceptanceHooks.Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        var statusResponse = await client.GetAsync(new Uri("/api/v1/me/mfa", UriKind.Relative));
        using var statusJson = JsonDocument.Parse(await statusResponse.Content.ReadAsStringAsync());
        Assert.False(statusJson.RootElement.GetProperty("enabled").GetBoolean());
    }

    [When(@"the user completes sign-in with a valid backup code")]
    public async Task WhenTheUserCompletesSignInWithAValidBackupCode()
    {
        var client = _loginClient ?? throw new InvalidOperationException("No pending login session — sign in with a password first.");
        var code = _backupCodes[0];
        _backupCodes.RemoveAt(0);
        _lastConsumedBackupCode = code;

        _lastResponse = await client.PostAsJsonAsync(new Uri("/api/v1/auth/login/mfa", UriKind.Relative), new { code });
        await CaptureJsonAsync();
    }

    [When(@"the user completes sign-in with the same backup code again")]
    public async Task WhenTheUserCompletesSignInWithTheSameBackupCodeAgain()
    {
        var client = _loginClient ?? throw new InvalidOperationException("No pending login session — sign in with a password first.");
        var code = _lastConsumedBackupCode ?? throw new InvalidOperationException("No backup code was consumed yet.");

        _lastResponse = await client.PostAsJsonAsync(new Uri("/api/v1/auth/login/mfa", UriKind.Relative), new { code });
        await CaptureJsonAsync();
    }

    [When(@"the user completes sign-in with the original backup code")]
    public async Task WhenTheUserCompletesSignInWithTheOriginalBackupCode()
    {
        var client = _loginClient ?? throw new InvalidOperationException("No pending login session — sign in with a password first.");
        var code = _originalBackupCodes[0];

        _lastResponse = await client.PostAsJsonAsync(new Uri("/api/v1/auth/login/mfa", UriKind.Relative), new { code });
        await CaptureJsonAsync();
    }

    [Then(@"the sign-in is rejected")]
    public void ThenTheSignInIsRejected() => Assert.Equal(401, (int)_lastResponse.StatusCode);

    [When(@"the user regenerates their backup codes")]
    public async Task WhenTheUserRegeneratesTheirBackupCodes()
    {
        _originalBackupCodes = [.. _backupCodes];

        var token = await AcquireAccessTokenAsync();
        using var client = AcceptanceHooks.Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        _lastResponse = await client.PostAsync(new Uri("/api/v1/me/mfa/backup-codes", UriKind.Relative), content: null);
        await CaptureJsonAsync();

        if (_lastResponse.IsSuccessStatusCode)
        {
            _backupCodes = [.. _lastJson!.RootElement.GetProperty("backupCodes").EnumerateArray().Select(e => e.GetString()!)];
        }
    }

    [Then(@"a fresh set of backup codes is issued")]
    public void ThenAFreshSetOfBackupCodesIsIssued()
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        Assert.Equal(BackupCodeGenerator.CodeCount, _backupCodes.Count);
        Assert.Empty(_backupCodes.Intersect(_originalBackupCodes));
    }

    [When(@"the user resets their password via account recovery")]
    public async Task WhenTheUserResetsTheirPasswordViaAccountRecovery()
    {
        // No email-capture infrastructure exists in this test host (T146's real SMTP
        // adapter is swapped back to LoggingEmailChannelAdapter here) — generating the
        // reset token directly via the same UserManager method the real
        // /auth/recovery endpoint calls internally exercises the identical
        // ResetPasswordAsync code path POST /auth/recovery/confirm runs, just
        // skipping the email-transport hop this harness can't observe.
        using var scope = AcceptanceHooks.Factory.Services.CreateScope();
        var userManager = scope.ServiceProvider.GetRequiredService<UserManager<ApplicationUser>>();
        var user = await userManager.FindByEmailAsync(_registeredEmail);
        var token = await userManager.GeneratePasswordResetTokenAsync(user!);
        var encodedToken = WebEncoders.Base64UrlEncode(Encoding.UTF8.GetBytes(token));

        _currentPassword = "a brand new recovery passphrase";
        using var client = AcceptanceHooks.Factory.CreateClient();
        _lastResponse = await client.PostAsJsonAsync(
            new Uri("/api/v1/auth/recovery/confirm", UriKind.Relative),
            new { email = _registeredEmail, token = encodedToken, newPassword = _currentPassword });
    }

    [When(@"the user signs in from two devices")]
    public async Task WhenTheUserSignsInFromTwoDevices()
    {
        // Each AcquireAccessTokenAsync() call drives its own full /connect/authorize +
        // /connect/token exchange against the same already-cookie-authenticated
        // session — a real, independent OpenIddict authorization (and therefore
        // SessionDevice row, per TokenEndpoints.HandleTokenAsync) per call, which is
        // what actually makes these "two devices" rather than two HTTP clients.
        _deviceTokens.Clear();
        _deviceRefreshTokens.Clear();
        foreach (var _ in new[] { 0, 1 })
        {
            var (accessToken, refreshToken) = await AcquireTokenPairAsync();
            _deviceTokens.Add(accessToken);
            _deviceRefreshTokens.Add(refreshToken);
        }
    }

    [Then(@"both sessions appear in the session list")]
    public async Task ThenBothSessionsAppearInTheSessionList()
    {
        using var client = AcceptanceHooks.Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _deviceTokens[0]);
        _lastResponse = await client.GetAsync(new Uri("/api/v1/me/sessions", UriKind.Relative));
        await CaptureJsonAsync();

        Assert.Equal(200, (int)_lastResponse.StatusCode);
        var sessions = _lastJson!.RootElement.GetProperty("sessions").EnumerateArray().ToList();
        Assert.Equal(2, sessions.Count);

        _sessionIds.Clear();
        _sessionIds.AddRange(sessions.Select(s => s.GetProperty("id").GetGuid()));
    }

    [When(@"the user revokes the first session")]
    public async Task WhenTheUserRevokesTheFirstSession()
    {
        using var client = AcceptanceHooks.Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _deviceTokens[0]);
        _lastResponse = await client.DeleteAsync(new Uri($"/api/v1/me/sessions/{_sessionIds[0]}", UriKind.Relative));
    }

    [Then(@"only the second session remains active")]
    public async Task ThenOnlyTheSecondSessionRemainsActive()
    {
        Assert.Equal(204, (int)_lastResponse.StatusCode);

        using var client = AcceptanceHooks.Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _deviceTokens[1]);
        var listResponse = await client.GetAsync(new Uri("/api/v1/me/sessions", UriKind.Relative));
        using var listJson = JsonDocument.Parse(await listResponse.Content.ReadAsStringAsync());
        var remaining = listJson.RootElement.GetProperty("sessions").EnumerateArray().ToList();

        Assert.Single(remaining);
        Assert.Equal(_sessionIds[1], remaining[0].GetProperty("id").GetGuid());
    }

    [Then(@"the first device's session can no longer be refreshed")]
    public async Task ThenTheFirstDevicesSessionCanNoLongerBeRefreshed()
    {
        // Honest revocation semantics (John's ruling, 2026-07-14, applied retroactively
        // to this already-merged T051 scenario for one consistent story with T052's):
        // DELETE /me/sessions/{id} revokes the underlying OpenIddict authorization,
        // which blocks this refresh_token grant — that's the real, immediate effect.
        // It does not retroactively invalidate the first device's already-issued access
        // token, which stays valid until its own short (10-minute) natural expiry.
        using var client = AcceptanceHooks.Factory.CreateClient();
        var response = await client.PostAsync(
            new Uri("/connect/token", UriKind.Relative),
            new FormUrlEncodedContent(new Dictionary<string, string>
            {
                ["grant_type"] = "refresh_token",
                ["refresh_token"] = _deviceRefreshTokens[0],
                ["client_id"] = "specpour-app",
            }));

        Assert.False(response.IsSuccessStatusCode, "A revoked session's refresh token must be rejected.");
    }

    [When(@"the user deactivates their account")]
    public async Task WhenTheUserDeactivatesTheirAccount()
    {
        (_deactivationToken, _deactivationRefreshToken) = await AcquireTokenPairAsync();
        using var client = AcceptanceHooks.Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _deactivationToken);
        _lastResponse = await client.PostAsync(new Uri("/api/v1/me/deactivate", UriKind.Relative), content: null);
    }

    [Then(@"the account is deactivated")]
    public async Task ThenTheAccountIsDeactivated()
    {
        Assert.Equal(204, (int)_lastResponse.StatusCode);

        using var scope = AcceptanceHooks.Factory.Services.CreateScope();
        var identityDb = scope.ServiceProvider.GetRequiredService<IdentityDbContext>();
        var user = await identityDb.Users.SingleAsync(u => u.Id == _registeredUserId);
        Assert.Equal(UserLifecycleState.Deactivated, user.LifecycleState);
        Assert.NotNull(user.DeactivatedAt);
    }

    [Then(@"the session can no longer be refreshed")]
    public async Task ThenTheSessionCanNoLongerBeRefreshed()
    {
        // Honest revocation semantics (John's ruling, 2026-07-14): POST /me/deactivate
        // revokes the underlying OpenIddict authorization, which OpenIddict enforces on
        // the refresh_token grant — proven here directly. It does NOT retroactively
        // invalidate an already-issued access token (self-contained/stateless, no
        // per-request DB check); that token remains valid until its own short
        // (10-minute, IdentityModule.cs SetAccessTokenLifetime) natural expiry. Asserting
        // an immediate 401 on the still-live access token would be testing behavior that
        // doesn't exist.
        using var client = AcceptanceHooks.Factory.CreateClient();
        var response = await client.PostAsync(
            new Uri("/connect/token", UriKind.Relative),
            new FormUrlEncodedContent(new Dictionary<string, string>
            {
                ["grant_type"] = "refresh_token",
                ["refresh_token"] = _deactivationRefreshToken!,
                ["client_id"] = "specpour-app",
            }));

        Assert.False(response.IsSuccessStatusCode, "A revoked authorization must reject a refresh_token grant.");
    }

    [When(@"the user reactivates their account")]
    public async Task WhenTheUserReactivatesTheirAccount()
    {
        // The cookie session from registration is untouched by deactivation (only the
        // bearer/OpenIddict authorization was revoked) — a fresh authorization-code
        // exchange against it stands in for "the user signs back in", same shorthand
        // WhenTheUserRequestsTheirDataExport already uses.
        var token = await AcquireAccessTokenAsync();
        using var client = AcceptanceHooks.Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        _lastResponse = await client.PostAsync(new Uri("/api/v1/me/reactivate", UriKind.Relative), content: null);
    }

    [Then(@"the account is active again")]
    public async Task ThenTheAccountIsActiveAgain()
    {
        Assert.Equal(204, (int)_lastResponse.StatusCode);

        using var scope = AcceptanceHooks.Factory.Services.CreateScope();
        var identityDb = scope.ServiceProvider.GetRequiredService<IdentityDbContext>();
        var user = await identityDb.Users.SingleAsync(u => u.Id == _registeredUserId);
        Assert.Equal(UserLifecycleState.Active, user.LifecycleState);
        Assert.Null(user.DeactivatedAt);
    }

    [When(@"time passes to the deactivation warning window")]
    public static void WhenTimePassesToTheDeactivationWarningWindow()
    {
        var lifecycleOptions = AcceptanceHooks.Factory.Services.GetRequiredService<IOptions<LifecycleOptions>>().Value;
        var advanceBy = TimeSpan.FromDays(lifecycleOptions.GracePeriodDays - lifecycleOptions.WarningDaysBeforeExpiry + 1);
        AcceptanceHooks.Factory.Clock.Advance(advanceBy);
    }

    [Then(@"the user receives a deactivation-expiry-warning notification")]
    public async Task ThenTheUserReceivesADeactivationExpiryWarningNotification() =>
        await PollUntilAsync(async () =>
        {
            var token = await AcquireAccessTokenAsync();
            using var client = AcceptanceHooks.Factory.CreateClient();
            client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
            var response = await client.GetAsync(new Uri("/api/v1/inbox", UriKind.Relative));
            using var json = JsonDocument.Parse(await response.Content.ReadAsStringAsync());

            return json.RootElement.GetProperty("items").EnumerateArray()
                .Any(item => item.GetProperty("type").GetString() == "account_deactivation_warning");
        });

    [When(@"time passes past the deactivation grace period")]
    public static void WhenTimePassesPastTheDeactivationGracePeriod()
    {
        var lifecycleOptions = AcceptanceHooks.Factory.Services.GetRequiredService<IOptions<LifecycleOptions>>().Value;
        var advanceBy = TimeSpan.FromDays(lifecycleOptions.WarningDaysBeforeExpiry + 1);
        AcceptanceHooks.Factory.Clock.Advance(advanceBy);
    }

    [Then(@"the account no longer exists")]
    public async Task ThenTheAccountNoLongerExists() =>
        await PollUntilAsync(async () =>
        {
            using var scope = AcceptanceHooks.Factory.Services.CreateScope();
            var identityDb = scope.ServiceProvider.GetRequiredService<IdentityDbContext>();
            return !await identityDb.Users.AnyAsync(u => u.Id == _registeredUserId);
        });

    /// <summary>
    /// Bounded poll for AccountLifecycleBackgroundService's fast test-only polling
    /// interval (SpecPourWebApplicationFactory), matching
    /// US01SearchReconciliationSteps' identical pattern for the outbox pipeline.
    /// </summary>
    private static async Task PollUntilAsync(Func<Task<bool>> conditionAsync)
    {
        var deadline = DateTimeOffset.UtcNow.AddSeconds(10);
        while (DateTimeOffset.UtcNow < deadline)
        {
            if (await conditionAsync())
            {
                return;
            }

            await Task.Delay(250);
        }

        Assert.True(await conditionAsync(), "Condition did not become true within the 10s poll window.");
    }

    [When(@"the user requests account recovery")]
    public async Task WhenTheUserRequestsAccountRecovery()
    {
        using var client = AcceptanceHooks.Factory.CreateClient();
        _lastResponse = await client.PostAsJsonAsync(new Uri("/api/v1/auth/recovery", UriKind.Relative), new { email = _registeredEmail });
    }

    [Then(@"the recovery request is accepted")]
    public void ThenTheRecoveryRequestIsAccepted() => Assert.Equal(202, (int)_lastResponse.StatusCode);

    [When(@"the user requests their data export")]
    public async Task WhenTheUserRequestsTheirDataExport()
    {
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
    private async Task<string> AcquireAccessTokenAsync() => (await AcquireTokenPairAsync()).AccessToken;

    /// <summary>
    /// Same PKCE exchange as <see cref="AcquireAccessTokenAsync"/>, but also returns the
    /// refresh token — needed by the T051/T052 revocation scenarios, which assert
    /// against the real, honest revocation semantics (future refresh blocked
    /// immediately) rather than an already-issued access token dying instantly (see
    /// SetAccessTokenLifetime's doc comment in IdentityModule.cs for why that isn't
    /// true of a self-contained/stateless access token).
    /// </summary>
    private async Task<(string AccessToken, string RefreshToken)> AcquireTokenPairAsync()
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
        return (
            tokenJson.RootElement.GetProperty("access_token").GetString()!,
            tokenJson.RootElement.GetProperty("refresh_token").GetString()!);
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
