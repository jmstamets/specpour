using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Identifiers;
using SpecPour.BuildingBlocks.Time;
using SpecPour.Modules.Identity.Application.Mfa;
using SpecPour.Modules.Identity.Domain;

namespace SpecPour.Modules.Identity.Infrastructure.Endpoints;

/// <summary>
/// T163: shared generate/consume logic for MFA backup codes, used by MfaEndpoints
/// (issue at enrollment confirm + explicit regenerate) and AuthEndpoints
/// (LoginMfaAsync's backup-code fallback when the TOTP code doesn't verify) — same
/// cross-file-internal-helper shape as AuthEndpoints.SignInOrChallengeMfaAsync.
/// Hashing goes through ASP.NET Core Identity's own IPasswordHasher (the same
/// mechanism the account password uses) rather than a bespoke hash — one-way
/// verification only, per the T162 security-checklist rule that recovery codes must
/// be hashed, not encrypted.
/// </summary>
internal static class BackupCodeStore
{
    /// <summary>Replaces every existing row for the user (used or not) with a fresh set. Caller must SaveChanges.</summary>
    public static IReadOnlyList<string> Regenerate(
        ApplicationUser user,
        IdentityDbContext db,
        IEnumerable<MfaBackupCode> existingCodes,
        IPasswordHasher<ApplicationUser> hasher,
        IUuidGenerator uuidGenerator,
        IClock clock)
    {
        db.MfaBackupCodes.RemoveRange(existingCodes);

        var codes = BackupCodeGenerator.GenerateSet();
        foreach (var code in codes)
        {
            db.MfaBackupCodes.Add(new MfaBackupCode
            {
                Id = uuidGenerator.NewId(),
                UserId = user.Id,
                CodeHash = hasher.HashPassword(user, code),
                CreatedAt = clock.UtcNow,
            });
        }

        return codes;
    }

    /// <summary>
    /// Verifies code against the user's unused backup codes, marking the matching one
    /// used on success. Codes are salted-hashed (no lookup index possible), so this
    /// iterates the small unused set (at most BackupCodeGenerator.CodeCount rows).
    /// Caller must SaveChanges on success.
    /// </summary>
    public static async Task<bool> TryConsumeAsync(
        ApplicationUser user,
        string code,
        IdentityDbContext db,
        IPasswordHasher<ApplicationUser> hasher,
        IClock clock,
        CancellationToken cancellationToken)
    {
        var unused = await db.MfaBackupCodes
            .Where(c => c.UserId == user.Id && c.UsedAt == null)
            .ToListAsync(cancellationToken);

        foreach (var candidate in unused)
        {
            var result = hasher.VerifyHashedPassword(user, candidate.CodeHash, code);
            if (result is PasswordVerificationResult.Success or PasswordVerificationResult.SuccessRehashNeeded)
            {
                candidate.UsedAt = clock.UtcNow;
                return true;
            }
        }

        return false;
    }
}
