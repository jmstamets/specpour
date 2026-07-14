namespace SpecPour.Modules.Identity.Application.Ports;

/// <summary>
/// Application-layer encryption port for TOTP secrets (T050, data-model.md
/// MfaEnrollment.secret reference) — same rationale as IDateOfBirthCipher: no raw
/// secret is ever persisted. Infrastructure's implementation reuses the module's
/// existing Data Protection key ring (AES-256-GCM, see IdentityModule.RegisterServices).
/// The owning user's id is a required input on BOTH operations (T162 security audit):
/// it is cryptographically bound into the ciphertext as GCM associated data, so a
/// ciphertext copied onto another user's MfaEnrollment row fails to decrypt rather
/// than silently verifying codes against a secret the row's owner never enrolled.
/// </summary>
public interface IMfaSecretCipher
{
    string Encrypt(Guid userId, string base32Secret);

    string Decrypt(Guid userId, string ciphertext);
}
