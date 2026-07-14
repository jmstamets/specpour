using Microsoft.AspNetCore.DataProtection;
using SpecPour.Modules.Identity.Application.Ports;

namespace SpecPour.Modules.Identity.Infrastructure;

/// <summary>
/// AES-256-GCM (via .NET Data Protection, same key ring as DataProtectionDateOfBirthCipher)
/// implementation of <see cref="IMfaSecretCipher"/>. Distinct purpose string from the DOB
/// cipher so the two ciphertexts can never be cross-decrypted.
///
/// The user id is appended to the purpose chain per operation (T162 security audit):
/// Data Protection passes the full purpose chain to the AEAD encryptor as GCM
/// associated data (KeyRingBasedDataProtector builds
/// `magicHeader || keyId || purposeCount || purposes*` as the AAD), so binding the
/// user here means a ciphertext moved onto a different user's row fails authentication
/// at decrypt instead of yielding a usable secret.
/// </summary>
public sealed class DataProtectionMfaSecretCipher : IMfaSecretCipher
{
    private const string Purpose = "SpecPour.Identity.MfaSecret.v1";

    private readonly IDataProtectionProvider _dataProtectionProvider;

    public DataProtectionMfaSecretCipher(IDataProtectionProvider dataProtectionProvider) =>
        _dataProtectionProvider = dataProtectionProvider;

    public string Encrypt(Guid userId, string base32Secret) =>
        ProtectorFor(userId).Protect(base32Secret);

    public string Decrypt(Guid userId, string ciphertext) =>
        ProtectorFor(userId).Unprotect(ciphertext);

    private IDataProtector ProtectorFor(Guid userId) =>
        _dataProtectionProvider.CreateProtector(Purpose, userId.ToString());
}
