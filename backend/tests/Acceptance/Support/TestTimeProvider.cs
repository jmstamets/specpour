namespace SpecPour.Tests.Acceptance.Support;

/// <summary>
/// ADR-0005 (T177): a thin <see cref="TimeProvider"/> that delegates to the SAME
/// <see cref="TestClock"/> instance the app's own <c>IClock</c> uses, so a single
/// <see cref="TestClock.Advance"/> call moves both this app's time-dependent logic
/// and OpenIddict's internal token-expiry / refresh-token-reuse-leeway timing
/// (OpenIddict reads <see cref="OpenIddict.Server.OpenIddictServerOptions.TimeProvider"/>,
/// not <c>IClock</c> — a separate clock authority that would otherwise silently stay on
/// the real wall clock while scenarios "advanced time" for everything else).
/// </summary>
public sealed class TestTimeProvider(TestClock clock) : TimeProvider
{
    public override DateTimeOffset GetUtcNow() => clock.UtcNow;
}
