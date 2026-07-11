namespace SpecPour.BuildingBlocks.Events.Outbox;

/// <summary>
/// A durable, transactionally-written record of a raised domain event (R2's outbox
/// table pattern). Written by <see cref="OutboxSaveChangesInterceptor"/> in the same
/// SaveChanges call as the business-data change that raised it; read and marked
/// processed by <see cref="OutboxDispatcherBackgroundService"/>.
/// </summary>
public sealed class OutboxMessage
{
    public required Guid Id { get; init; }

    /// <summary>Stable event-type name (see <see cref="EventTypeName"/>) used to resolve the CLR type at dispatch.</summary>
    public required string EventType { get; init; }

    /// <summary>The event, serialized as JSON via <see cref="System.Text.Json.JsonSerializer"/>.</summary>
    public required string PayloadJson { get; init; }

    /// <summary>Business time the event occurred (copied from <see cref="IDomainEvent.OccurredAt"/>).</summary>
    public required DateTimeOffset OccurredAt { get; init; }

    /// <summary>Module that raised the event, for observability (e.g. "Catalog").</summary>
    public required string SourceModule { get; init; }

    /// <summary>Set once all registered handlers have run successfully; null while pending.</summary>
    public DateTimeOffset? ProcessedAt { get; set; }

    /// <summary>Dispatch attempts made so far, for backoff/alerting.</summary>
    public int Attempts { get; set; }

    /// <summary>Most recent dispatch failure, if any.</summary>
    public string? LastError { get; set; }
}
