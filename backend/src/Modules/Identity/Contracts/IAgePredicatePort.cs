namespace SpecPour.Modules.Identity.Contracts;

/// <summary>
/// Cross-module read port (constitution Principle III, FR-002b/acceptance scenario
/// 8, T048): the ONLY way another module, staff view, log, trace, or analytics event
/// may learn anything about a user's age. Never exposes the raw date of birth —
/// every implementation call decrypts the stored value internally and MUST
/// audit-log that access (the same requirement IDateOfBirthCipher's doc comment states).
/// </summary>
public interface IAgePredicatePort
{
    /// <summary>
    /// True when the user's age (as of today) is at least <paramref name="jurisdictionCode"/>'s
    /// configured legal drinking age. False for a user that doesn't exist.
    /// </summary>
    Task<bool> IsOfLegalDrinkingAgeAsync(Guid userId, string jurisdictionCode, CancellationToken cancellationToken);

    /// <summary>
    /// A coarse age band (e.g. "18-24", "65+") for analytics — never an exact age or
    /// birth date (FR-002b: "where analytics need age at all, age bands only").
    /// </summary>
    Task<string?> GetAgeBandAsync(Guid userId, CancellationToken cancellationToken);
}
