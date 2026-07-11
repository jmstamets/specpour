namespace SpecPour.Modules.Identity.Application.Ports;

/// <summary>
/// Application-layer encryption port for the sole raw-DOB storage in the platform
/// (R6a, FR-002b): the identity module never persists a plaintext date of birth.
/// Infrastructure's implementation uses .NET Data Protection configured for AES-256-GCM
/// with a dedicated, rotated key ring (see IdentityModule.RegisterServices). Callers of
/// <see cref="Decrypt"/> are exclusively the owner's data-export flow (T053) and the
/// derived-predicate service (T048); every call site must write an audit entry.
/// </summary>
public interface IDateOfBirthCipher
{
    string Encrypt(DateOnly dateOfBirth);

    DateOnly Decrypt(string ciphertext);
}
