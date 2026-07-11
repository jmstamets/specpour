namespace SpecPour.BuildingBlocks.Events;

/// <summary>
/// Marker for a cross-module domain event dispatched via the outbox (R2). Concrete
/// events (e.g. RecipePublished, T089) are declared in the owning module's Contracts
/// project so subscribing modules can depend on the event shape without depending on
/// the publisher's internals.
/// </summary>
public interface IDomainEvent
{
    /// <summary>Stable, non-reusable identifier for this occurrence (UUIDv7).</summary>
    Guid EventId { get; }

    /// <summary>UTC instant the event occurred (business time, not dispatch time).</summary>
    DateTimeOffset OccurredAt { get; }
}

/// <summary>Base record for domain events; derive a positional record per event type.</summary>
public abstract record DomainEvent : IDomainEvent
{
    public Guid EventId { get; init; } = Guid.CreateVersion7();
    public DateTimeOffset OccurredAt { get; init; } = DateTimeOffset.UtcNow;
}
