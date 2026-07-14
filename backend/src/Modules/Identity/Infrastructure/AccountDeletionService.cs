using Microsoft.AspNetCore.Identity;
using SpecPour.BuildingBlocks.Events;
using SpecPour.Modules.Authorization.Contracts.Audit;
using SpecPour.Modules.Identity.Contracts.Events;

namespace SpecPour.Modules.Identity.Infrastructure;

/// <summary>
/// T053: the actual deletion mechanism, shared by DELETE /me (immediate, user-
/// initiated) and T052's background job (grace-period expiry) — one place that
/// "delete an account" means, so both paths behave identically. Hard-deletes the
/// ApplicationUser row via UserManager (cascades to MfaEnrollment/MfaBackupCode/
/// SessionDevice/AspNetUserLogins/Claims/Tokens via the real FKs added alongside
/// this task — OpenIddict's own Authorization/Token rows are NOT synchronously
/// purged here, matching OpenIddict's own designed lifecycle: they reference the
/// user by a plain, unFK'd subject string and are pruned by TTL, the same as any
/// OpenIddict deployment; HandleTokenAsync already refuses to refresh a token for a
/// since-deleted user (FindByIdAsync returns null → Forbid), so nothing usable
/// survives the account regardless). Publishes AccountDeleted for the future
/// Community module's public-attribution anonymization / rating-event
/// de-identification (data-model.md — that module doesn't exist yet in this
/// codebase, so there is genuinely no subscriber to wire up today; this is the
/// producer side landing first, same shape as T155's IngredientRenamed).
/// </summary>
public sealed class AccountDeletionService(
    UserManager<ApplicationUser> userManager,
    IDomainEventDispatcher dispatcher,
    IAuditWriter auditWriter)
{
    public async Task<bool> DeleteAsync(Guid userId, CancellationToken cancellationToken)
    {
        var user = await userManager.FindByIdAsync(userId.ToString());
        if (user is null)
        {
            return false;
        }

        dispatcher.Raise(new AccountDeleted(userId));

        var result = await userManager.DeleteAsync(user);
        if (!result.Succeeded)
        {
            throw new InvalidOperationException(
                $"Failed to delete account {userId}: {string.Join("; ", result.Errors.Select(e => e.Description))}");
        }

        // Self-service action, not a staff intervention, but still a significant
        // account-security state change worth an audit trail (same rationale as
        // T162's mfa_enabled/mfa_disabled entries) — no FK from AuditLogEntry to the
        // identity schema (Principle III, cross-schema), so this row correctly
        // outlives the now-deleted user.
        await auditWriter.WriteAsync(
            new AuditEntry(userId, "identity.account_deleted", "User", userId),
            cancellationToken);

        return true;
    }
}
