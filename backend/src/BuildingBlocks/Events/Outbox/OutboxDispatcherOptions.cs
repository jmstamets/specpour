namespace SpecPour.BuildingBlocks.Events.Outbox;

/// <summary>Tuning for <see cref="OutboxDispatcherBackgroundService"/>.</summary>
public sealed class OutboxDispatcherOptions
{
    public TimeSpan PollingInterval { get; set; } = TimeSpan.FromSeconds(5);
    public int BatchSize { get; set; } = 50;
}
