using SpecPour.BuildingBlocks.Events;
using SpecPour.Modules.Notifications.Contracts;

namespace SpecPour.Modules.Identity.Contracts.Events;

/// <summary>
/// Published by the T052 background job when a deactivated account's grace period is
/// about to expire (default: LifecycleOptions.WarningDaysBeforeExpiry days before
/// deletion) — the "warned before expiry" half of FR-003. One-shot per deactivation
/// (AccountLifecycleBackgroundService records DeactivationWarningSentAt so this never
/// fires twice for the same deactivation window).
/// </summary>
public sealed record DeactivationExpiryApproaching(Guid UserId, DateTimeOffset ScheduledDeletionAt) : DomainEvent, INotificationEvent
{
    public Guid RecipientUserId => UserId;

    public string NotificationType => "account_deactivation_warning";

    public object Payload => new { ScheduledDeletionAt };
}
