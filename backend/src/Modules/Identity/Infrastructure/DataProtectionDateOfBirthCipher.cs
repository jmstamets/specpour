using System.Globalization;
using Microsoft.AspNetCore.DataProtection;
using SpecPour.Modules.Identity.Application.Ports;

namespace SpecPour.Modules.Identity.Infrastructure;

/// <summary>
/// AES-256-GCM (via .NET Data Protection, see IdentityModule.RegisterServices for the
/// algorithm/key-ring configuration) implementation of <see cref="IDateOfBirthCipher"/>.
/// The purpose string is versioned so a future re-key/rotation strategy can introduce
/// "...v2" without breaking decryption of existing ciphertext.
/// </summary>
public sealed class DataProtectionDateOfBirthCipher : IDateOfBirthCipher
{
    private const string Purpose = "SpecPour.Identity.DateOfBirth.v1";
    private const string DateFormat = "yyyy-MM-dd";

    private readonly IDataProtector _protector;

    public DataProtectionDateOfBirthCipher(IDataProtectionProvider dataProtectionProvider) =>
        _protector = dataProtectionProvider.CreateProtector(Purpose);

    public string Encrypt(DateOnly dateOfBirth) =>
        _protector.Protect(dateOfBirth.ToString(DateFormat, CultureInfo.InvariantCulture));

    public DateOnly Decrypt(string ciphertext) =>
        DateOnly.ParseExact(_protector.Unprotect(ciphertext), DateFormat, CultureInfo.InvariantCulture);
}
