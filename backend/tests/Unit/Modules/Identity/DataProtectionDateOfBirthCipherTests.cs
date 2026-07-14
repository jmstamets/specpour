using System.Security.Cryptography;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption;
using Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel;
using SpecPour.Modules.Identity.Infrastructure;

namespace SpecPour.Tests.Unit.Modules.Identity;

/// <summary>
/// Sanity coverage for R6a's sole raw-DOB storage mechanism (T164, mirroring T162's
/// identical audit of the MFA-secret cipher): encrypt/decrypt must round-trip, the
/// stored ciphertext must never contain the plaintext date, and the user id bound in
/// as GCM associated data must make tampered or cross-user-swapped ciphertext fail
/// decryption. Full registration/export flows are covered by their own story's
/// acceptance tests (T045/T053); this is unit-level coverage for the cipher itself.
/// The provider is configured with the SAME AES-256-GCM algorithm IdentityModule
/// registers in production (not the Create(appName) default of CBC+HMAC), so the
/// tamper test exercises the real AesGcm tag rejection path.
/// </summary>
public sealed class DataProtectionDateOfBirthCipherTests : IDisposable
{
    private static readonly Guid UserA = Guid.Parse("11111111-1111-1111-1111-111111111111");
    private static readonly Guid UserB = Guid.Parse("22222222-2222-2222-2222-222222222222");

    private readonly DirectoryInfo _keyDirectory =
        Directory.CreateTempSubdirectory("specpour-dob-cipher-tests-");

    public void Dispose() => _keyDirectory.Delete(recursive: true);

    private DataProtectionDateOfBirthCipher CreateCipher() =>
        new(DataProtectionProvider.Create(
            _keyDirectory,
            builder => builder
                .SetApplicationName("SpecPour.Tests")
                .UseCryptographicAlgorithms(new AuthenticatedEncryptorConfiguration
                {
                    EncryptionAlgorithm = EncryptionAlgorithm.AES_256_GCM,
                    ValidationAlgorithm = ValidationAlgorithm.HMACSHA256,
                })));

    [Fact]
    public void Encrypt_then_decrypt_round_trips_the_original_date()
    {
        var cipher = CreateCipher();
        var dateOfBirth = new DateOnly(1990, 6, 15);

        var ciphertext = cipher.Encrypt(UserA, dateOfBirth);
        var decrypted = cipher.Decrypt(UserA, ciphertext);

        Assert.Equal(dateOfBirth, decrypted);
    }

    [Fact]
    public void Ciphertext_never_contains_the_plaintext_date_representation()
    {
        var cipher = CreateCipher();
        var dateOfBirth = new DateOnly(1990, 6, 15);

        var ciphertext = cipher.Encrypt(UserA, dateOfBirth);

        Assert.DoesNotContain("1990-06-15", ciphertext, StringComparison.Ordinal);
    }

    [Fact]
    public void Two_encryptions_of_the_same_date_produce_different_ciphertext()
    {
        var cipher = CreateCipher();
        var dateOfBirth = new DateOnly(1990, 6, 15);

        var first = cipher.Encrypt(UserA, dateOfBirth);
        var second = cipher.Encrypt(UserA, dateOfBirth);

        // AES-GCM uses a fresh nonce per call, so identical plaintexts must not
        // produce identical ciphertext (defends against pattern-matching attacks).
        Assert.NotEqual(first, second);
    }

    [Fact]
    public void Tampered_ciphertext_fails_decryption()
    {
        var cipher = CreateCipher();
        var ciphertext = cipher.Encrypt(UserA, new DateOnly(1990, 6, 15));

        var raw = Base64UrlDecode(ciphertext);
        raw[raw.Length / 2] ^= 0x01;
        var tampered = Base64UrlEncode(raw);

        // ThrowsAny: the actual type is AuthenticationTagMismatchException (a
        // CryptographicException subclass) straight from AesGcm's own tag check.
        Assert.ThrowsAny<CryptographicException>(() => cipher.Decrypt(UserA, tampered));
    }

    [Fact]
    public void Ciphertext_encrypted_for_one_user_fails_decryption_for_another()
    {
        // T164 (mirrors T162 item 4): simulates the EncryptedDateOfBirth column value
        // being copied from user A's row onto user B's — decryption is always
        // attempted with the row-owner's id in the purpose chain (GCM associated
        // data), so the authentication check must fail rather than yield A's birth
        // date for B.
        var cipher = CreateCipher();
        var ciphertextForA = cipher.Encrypt(UserA, new DateOnly(1990, 6, 15));

        Assert.ThrowsAny<CryptographicException>(() => cipher.Decrypt(UserB, ciphertextForA));
    }

    private static byte[] Base64UrlDecode(string input)
    {
        var s = input.Replace('-', '+').Replace('_', '/');
        return Convert.FromBase64String(s.PadRight(s.Length + ((4 - (s.Length % 4)) % 4), '='));
    }

    private static string Base64UrlEncode(byte[] input) =>
        Convert.ToBase64String(input).TrimEnd('=').Replace('+', '-').Replace('/', '_');
}
