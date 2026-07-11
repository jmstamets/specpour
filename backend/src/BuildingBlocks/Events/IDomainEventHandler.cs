namespace SpecPour.BuildingBlocks.Events;

// CA1711 wants types to not end in "EventHandler" (to avoid confusion with the BCL's
// System.EventHandler delegate). This is a domain-event subscriber, not a .NET event
// handler, and "handler" is the established term for this role (cf. MediatR's
// INotificationHandler) — suppressed intentionally rather than renamed.
#pragma warning disable CA1711

/// <summary>
/// Subscriber contract for a specific domain event type. A module registers
/// implementations in its own DI container registration (<see cref="Modules.IModule.RegisterServices"/>);
/// the outbox dispatcher (T011) resolves and invokes all matching handlers by event
/// type when it processes a pending outbox row.
/// </summary>
public interface IDomainEventHandler<in TEvent> where TEvent : IDomainEvent
{
    Task HandleAsync(TEvent domainEvent, CancellationToken cancellationToken);
}

#pragma warning restore CA1711
