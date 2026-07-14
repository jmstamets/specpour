using SpecPour.BuildingBlocks.Events;

namespace SpecPour.Modules.Identity.Contracts.Events;

/// <summary>
/// Published when an account is deleted (T053, DELETE /me, or the T052 background
/// job's grace-period-expiry path) — after the identity-owned data itself is already
/// gone (DOB, MFA, sessions), this is the hook a future Community module (Phase 9,
/// not built yet) subscribes to for public-attribution anonymization and rating-event
/// de-identification (data-model.md's own wording for what deletion must do to public
/// content). NOT an INotificationEvent — there is no user left to notify.
/// </summary>
public sealed record AccountDeleted(Guid UserId) : DomainEvent;
