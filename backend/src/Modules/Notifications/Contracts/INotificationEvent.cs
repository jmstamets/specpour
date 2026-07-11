using SpecPour.BuildingBlocks.Events;

namespace SpecPour.Modules.Notifications.Contracts;

/// <summary>
/// Marker other modules' domain events implement to automatically land in the
/// recipient's inbox (T023's "typed notification events consumer"). No producer
/// exists yet — Identity's AccountDeactivated/DeactivationExpiryApproaching (T052)
/// and Prep's PrepExpired/PrepExpiring (T109) are the first — but the consumer
/// mechanism (<c>NotificationEventConsumer&lt;TEvent&gt;</c>, registered as an open
/// generic <see cref="IDomainEventHandler{TEvent}"/>) works for any event
/// implementing this today, with zero changes needed in the notifications module
/// when a producer lands.
/// </summary>
public interface INotificationEvent : IDomainEvent
{
    Guid RecipientUserId { get; }

    /// <summary>Stable notification type key (matches InboxMessage.Type).</summary>
    string NotificationType { get; }

    /// <summary>Type-specific payload; serialized as-is into InboxMessage.PayloadJson.</summary>
    object Payload { get; }
}
