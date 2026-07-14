namespace SpecPour.Modules.Identity.Domain;

/// <summary>
/// data-model.md MfaEnrollment: id, user_id, method (totp), secret reference, enabled_at.
/// One row per user (a fresh POST /me/mfa replaces any prior unconfirmed row — see
/// MfaEndpoints). EnabledAt is null while a secret has been issued but not yet confirmed
/// with a valid code; only an enrollment with EnabledAt set gates sign-in (T050).
/// </summary>
public sealed class MfaEnrollment
{
    public required Guid Id { get; init; }

    public required Guid UserId { get; init; }

    /// <summary>Only "totp" exists in V1; the column exists for future methods (data-model.md).</summary>
    public required string Method { get; init; }

    /// <summary>
    /// AES-256-GCM ciphertext of the base32 TOTP secret, produced by IMfaSecretCipher —
    /// same Data Protection pattern as IDateOfBirthCipher (R6a), with UserId bound in
    /// as GCM associated data (T162): this ciphertext only decrypts for the row's own
    /// user, so copying it onto another enrollment row fails authentication instead of
    /// silently working. Never returned to the client after the initial enrollment
    /// response.
    /// </summary>
    public required string EncryptedSecret { get; init; }

    public DateTimeOffset? EnabledAt { get; set; }
}
