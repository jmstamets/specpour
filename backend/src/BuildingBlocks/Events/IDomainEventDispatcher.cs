namespace SpecPour.BuildingBlocks.Events;

/// <summary>
/// Application-layer port for raising domain events. Buffers events on the current
/// unit of work; <see cref="Outbox.OutboxSaveChangesInterceptor"/> drains the buffer
/// into outbox rows in the same SaveChanges transaction as the business-data write, so
/// "raise the event" and "persist the change" always commit or roll back together.
/// </summary>
public interface IDomainEventDispatcher
{
    /// <summary>Buffers an event to be persisted to the outbox on the next SaveChanges.</summary>
    void Raise(IDomainEvent domainEvent);
}
