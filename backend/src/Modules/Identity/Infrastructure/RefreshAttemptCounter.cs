using System.Collections.Concurrent;

namespace SpecPour.Modules.Identity.Infrastructure;

/// <summary>
/// ADR-0005 (T177 #100) test-only telemetry: counts refresh_token grant
/// ATTEMPTS received per user, so the cross-tab-election mechanism test can
/// assert exactly ONE refresh crosses the wire when two tabs race.
///
/// Attempts, not successes, on purpose (John's rider): if the election is broken
/// but both requests land inside OpenIddict's 30-second reuse leeway, BOTH
/// succeed — a success counter would read a false-green "2 successes, fine",
/// while an attempt counter correctly reads "2 attempts → FAIL".
///
/// Increment and the read endpoint are both gated on <c>IHostEnvironment.
/// IsDevelopment()</c> — this is never an observable production surface (it would
/// leak grant telemetry). In production the increment path is skipped and the
/// dictionary stays empty, so there is no memory-growth footprint either.
/// </summary>
public sealed class RefreshAttemptCounter
{
    private readonly ConcurrentDictionary<Guid, int> _attemptsByUser = new();

    public void Increment(Guid userId) =>
        _attemptsByUser.AddOrUpdate(userId, 1, (_, current) => current + 1);

    public int Get(Guid userId) =>
        _attemptsByUser.TryGetValue(userId, out var count) ? count : 0;
}
