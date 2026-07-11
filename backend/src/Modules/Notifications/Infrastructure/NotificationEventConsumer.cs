using System.Text.Json;
using SpecPour.BuildingBlocks.Events;
using SpecPour.Modules.Notifications.Contracts;
using SpecPour.Modules.Notifications.Domain;

namespace SpecPour.Modules.Notifications.Infrastructure;

/// <summary>
/// Turns any <see cref="INotificationEvent"/> into an <see cref="InboxMessage"/>.
/// Registered as an open-generic <see cref="IDomainEventHandler{TEvent}"/>
/// (<c>NotificationsModule.RegisterServices</c>) so it automatically applies to every
/// future event type that implements the marker — Identity's
/// AccountDeactivated/DeactivationExpiryApproaching (T052), Prep's
/// PrepExpired/PrepExpiring (T109) — with no change needed here when they land.
/// </summary>
public sealed class NotificationEventConsumer<TEvent>(NotificationsDbContext db) : IDomainEventHandler<TEvent>
    where TEvent : INotificationEvent
{
    public async Task HandleAsync(TEvent domainEvent, CancellationToken cancellationToken)
    {
        db.InboxMessages.Add(new InboxMessage
        {
            Id = domainEvent.EventId,
            UserId = domainEvent.RecipientUserId,
            Type = domainEvent.NotificationType,
            PayloadJson = JsonSerializer.Serialize(domainEvent.Payload, domainEvent.Payload.GetType()),
            CreatedAt = domainEvent.OccurredAt,
        });

        await db.SaveChangesAsync(cancellationToken);
    }
}
