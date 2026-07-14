namespace SpecPour.Modules.Identity.Application.Ports;

/// <summary>
/// Application-layer encryption port for the sole raw-DOB storage in the platform
/// (R6a, FR-002b): the identity module never persists a plaintext date of birth.
/// Infrastructure's implementation uses .NET Data Protection configured for AES-256-GCM
/// with a dedicated, rotated key ring (see IdentityModule.RegisterServices). Callers of
/// <see cref="Decrypt"/> are exclusively the owner's data-export flow (T053) and the
/// derived-predicate service (T048); every call site must write an audit entry.
///
/// The owning user's id is a required input on BOTH operations (T164 security audit,
/// mirroring T162's identical MFA-secret-cipher fix): it is cryptographically bound
/// into the ciphertext as GCM associated data, so a ciphertext copied onto another
/// user's row fails to decrypt rather than silently yielding a birth date that isn't
/// theirs.
/// </summary>
public interface IDateOfBirthCipher
{
    string Encrypt(Guid userId, DateOnly dateOfBirth);

    DateOnly Decrypt(Guid userId, string ciphertext);
}
