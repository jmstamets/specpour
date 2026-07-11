using SpecPour.BuildingBlocks.Time;

namespace SpecPour.Tests.Acceptance.Support;

/// <summary>
/// T026's settable clock: scenarios that need "days later" behavior (deactivation
/// grace periods T052, prep expiry T109) call <see cref="Advance"/> instead of
/// sleeping for real. Starts at the real current time so unrelated scenarios behave
/// normally; each scenario should reset it in a Before hook if it depends on a known
/// starting point.
/// </summary>
public sealed class TestClock : IClock
{
    private DateTimeOffset _utcNow = DateTimeOffset.UtcNow;

    public DateTimeOffset UtcNow => _utcNow;

    public void Advance(TimeSpan by) => _utcNow += by;

    public void Set(DateTimeOffset value) => _utcNow = value;
}
