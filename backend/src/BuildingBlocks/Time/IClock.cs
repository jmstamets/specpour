namespace SpecPour.BuildingBlocks.Time;

/// <summary>
/// Abstraction over "now" (T026's "clock test hook"). Production code that needs
/// testable time-based logic (deactivation grace periods T052, prep expiry T109,
/// deactivation-warning scheduling) injects this instead of calling
/// <see cref="DateTimeOffset.UtcNow"/> directly, so acceptance tests can advance time
/// deterministically without real waits. Not retrofitted onto every existing
/// UtcNow call site — only adopted where a story's own acceptance scenario actually
/// needs clock control (same "build the seam when a consumer needs it" posture as
/// ISearchableEntityRegistry/INotificationEvent).
/// </summary>
public interface IClock
{
    DateTimeOffset UtcNow { get; }
}

public sealed class SystemClock : IClock
{
    public DateTimeOffset UtcNow => DateTimeOffset.UtcNow;
}
