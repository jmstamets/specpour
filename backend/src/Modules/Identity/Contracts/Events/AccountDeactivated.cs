using SpecPour.BuildingBlocks.Events;
using SpecPour.Modules.Notifications.Contracts;

namespace SpecPour.Modules.Identity.Contracts.Events;

/// <summary>
/// Published when a user deactivates their own account (T052, POST /me/deactivate).
/// The first real producer for Notifications.Contracts.INotificationEvent — its own
/// doc comment names this event by name, anticipating exactly this — so
/// NotificationEventConsumer&lt;TEvent&gt; picks it up automatically with no
/// notifications-module change needed.
/// </summary>
public sealed record AccountDeactivated(Guid UserId, DateTimeOffset DeactivatedAt) : DomainEvent, INotificationEvent
{
    public Guid RecipientUserId => UserId;

    public string NotificationType => "account_deactivated";

    public object Payload => new { DeactivatedAt };
}
