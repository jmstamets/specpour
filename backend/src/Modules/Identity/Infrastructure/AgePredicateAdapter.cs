using Microsoft.AspNetCore.Identity;
using SpecPour.BuildingBlocks.Time;
using SpecPour.Modules.Authorization.Contracts.Audit;
using SpecPour.Modules.Compliance.Contracts;
using SpecPour.Modules.Identity.Application;
using SpecPour.Modules.Identity.Application.Ports;
using SpecPour.Modules.Identity.Contracts;

namespace SpecPour.Modules.Identity.Infrastructure;

/// <summary>
/// T048's implementation of the cross-module age-predicate port. Every decrypt is
/// audit-logged (FR-002b/acceptance scenario 8) — the actor and target are both the
/// subject user, since this is a self-referential PII access rather than a staff
/// action; ActorUserId still identifies who the access was FOR, satisfying "each
/// access to the stored value is audit-logged."
/// </summary>
public sealed class AgePredicateAdapter(
    UserManager<ApplicationUser> userManager,
    IDateOfBirthCipher cipher,
    ILegalDrinkingAgePort legalDrinkingAge,
    IAuditWriter auditWriter,
    IClock clock) : IAgePredicatePort
{
    public async Task<bool> IsOfLegalDrinkingAgeAsync(Guid userId, string jurisdictionCode, CancellationToken cancellationToken)
    {
        var age = await DecryptAndAuditAgeAsync(userId, "identity.age_predicate_checked", cancellationToken);
        if (age is null)
        {
            return false;
        }

        var legalAge = await legalDrinkingAge.GetLegalDrinkingAgeAsync(jurisdictionCode, cancellationToken);
        return age.Value >= legalAge;
    }

    public async Task<string?> GetAgeBandAsync(Guid userId, CancellationToken cancellationToken)
    {
        var age = await DecryptAndAuditAgeAsync(userId, "identity.age_band_derived", cancellationToken);
        return age is null ? null : ToAgeBand(age.Value);
    }

    private async Task<int?> DecryptAndAuditAgeAsync(Guid userId, string actionKey, CancellationToken cancellationToken)
    {
        var user = await userManager.FindByIdAsync(userId.ToString());
        if (user is null)
        {
            return null;
        }

        var dateOfBirth = cipher.Decrypt(user.EncryptedDateOfBirth);

        await auditWriter.WriteAsync(
            new AuditEntry(userId, actionKey, "User", userId),
            cancellationToken);

        return AgeCalculator.CalculateAge(dateOfBirth, DateOnly.FromDateTime(clock.UtcNow.UtcDateTime));
    }

    // Standard demographic bands — never an exact age or birth date (FR-002b).
    private static string ToAgeBand(int age) => age switch
    {
        < 18 => "under18",
        <= 24 => "18-24",
        <= 34 => "25-34",
        <= 44 => "35-44",
        <= 54 => "45-54",
        <= 64 => "55-64",
        _ => "65+",
    };
}
