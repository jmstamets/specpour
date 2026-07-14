namespace SpecPour.Modules.Identity.Domain;

/// <summary>
/// T163: one-time MFA recovery codes, generated as a set of 10 when TOTP enrollment
/// is confirmed (and again on explicit regeneration). One-way verification only —
/// CodeHash is a salted hash (ASP.NET Core Identity's own IPasswordHasher, same
/// mechanism the account password uses), never an encrypted/reversible value, per
/// the T162 security-checklist rule that recovery codes must be hashed, not
/// encrypted. Regenerating a set replaces every prior row for the user, used or not.
/// </summary>
public sealed class MfaBackupCode
{
    public required Guid Id { get; init; }

    public required Guid UserId { get; init; }

    public required string CodeHash { get; init; }

    public required DateTimeOffset CreatedAt { get; init; }

    public DateTimeOffset? UsedAt { get; set; }
}
