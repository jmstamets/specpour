using System.Globalization;
using Microsoft.AspNetCore.DataProtection;
using SpecPour.Modules.Identity.Application.Ports;

namespace SpecPour.Modules.Identity.Infrastructure;

/// <summary>
/// AES-256-GCM (via .NET Data Protection, see IdentityModule.RegisterServices for the
/// algorithm/key-ring configuration) implementation of <see cref="IDateOfBirthCipher"/>.
/// The purpose string is versioned so a future re-key/rotation strategy can introduce
/// "...v2" without breaking decryption of existing ciphertext.
///
/// The user id is appended to the purpose chain per operation (T164, mirroring T162's
/// identical MfaSecretCipher fix): Data Protection passes the full purpose chain to
/// the AEAD encryptor as GCM associated data (KeyRingBasedDataProtector builds
/// `magicHeader || keyId || purposeCount || purposes*` as the AAD), so binding the
/// user here means a ciphertext moved onto a different user's row fails authentication
/// at decrypt instead of yielding a usable birth date.
/// </summary>
public sealed class DataProtectionDateOfBirthCipher : IDateOfBirthCipher
{
    private const string Purpose = "SpecPour.Identity.DateOfBirth.v1";
    private const string DateFormat = "yyyy-MM-dd";

    private readonly IDataProtectionProvider _dataProtectionProvider;

    public DataProtectionDateOfBirthCipher(IDataProtectionProvider dataProtectionProvider) =>
        _dataProtectionProvider = dataProtectionProvider;

    public string Encrypt(Guid userId, DateOnly dateOfBirth) =>
        ProtectorFor(userId).Protect(dateOfBirth.ToString(DateFormat, CultureInfo.InvariantCulture));

    public DateOnly Decrypt(Guid userId, string ciphertext) =>
        DateOnly.ParseExact(ProtectorFor(userId).Unprotect(ciphertext), DateFormat, CultureInfo.InvariantCulture);

    private IDataProtector ProtectorFor(Guid userId) =>
        _dataProtectionProvider.CreateProtector(Purpose, userId.ToString());
}
