using System.Security.Cryptography;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption;
using Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel;
using SpecPour.Modules.Identity.Infrastructure;

namespace SpecPour.Tests.Unit.Modules.Identity;

/// <summary>
/// T050/T162: coverage for the TOTP secret cipher — round-trip/containment (same
/// shape as DataProtectionDateOfBirthCipherTests) plus the T162 security audit's
/// negative paths: tampered ciphertext must fail authentication, and a ciphertext
/// moved between users must fail decryption (the user id is bound in as GCM
/// associated data via the Data Protection purpose chain). The provider here is
/// configured with the SAME AES-256-GCM algorithm IdentityModule registers in
/// production (not the Create(appName) default of CBC+HMAC), so the tamper test
/// exercises the real AesGcm tag rejection path.
/// </summary>
public sealed class DataProtectionMfaSecretCipherTests : IDisposable
{
    private const string Secret = "JBSWY3DPEHPK3PXP";
    private static readonly Guid UserA = Guid.Parse("11111111-1111-1111-1111-111111111111");
    private static readonly Guid UserB = Guid.Parse("22222222-2222-2222-2222-222222222222");

    private readonly DirectoryInfo _keyDirectory =
        Directory.CreateTempSubdirectory("specpour-mfa-cipher-tests-");

    public void Dispose() => _keyDirectory.Delete(recursive: true);

    private DataProtectionMfaSecretCipher CreateCipher() =>
        new DataProtectionMfaSecretCipher(DataProtectionProvider.Create(
            _keyDirectory,
            builder => builder
                .SetApplicationName("SpecPour.Tests")
                .UseCryptographicAlgorithms(new AuthenticatedEncryptorConfiguration
                {
                    EncryptionAlgorithm = EncryptionAlgorithm.AES_256_GCM,
                    ValidationAlgorithm = ValidationAlgorithm.HMACSHA256,
                })));

    [Fact]
    public void Encrypt_then_decrypt_round_trips_the_original_secret()
    {
        var cipher = CreateCipher();

        var ciphertext = cipher.Encrypt(UserA, Secret);
        var decrypted = cipher.Decrypt(UserA, ciphertext);

        Assert.Equal(Secret, decrypted);
    }

    [Fact]
    public void Ciphertext_never_contains_the_plaintext_secret()
    {
        var cipher = CreateCipher();

        var ciphertext = cipher.Encrypt(UserA, Secret);

        Assert.DoesNotContain(Secret, ciphertext, StringComparison.Ordinal);
    }

    [Fact]
    public void Two_encryptions_of_the_same_secret_produce_different_ciphertext()
    {
        // Observable evidence of the framework's per-operation randomness (a fresh
        // random 96-bit nonce plus a random 128-bit key modifier per Protect call —
        // AesGcmAuthenticatedEncryptor): identical plaintexts must never produce
        // identical ciphertext, which is also what rules out nonce/key reuse.
        var cipher = CreateCipher();

        var first = cipher.Encrypt(UserA, Secret);
        var second = cipher.Encrypt(UserA, Secret);

        Assert.NotEqual(first, second);
    }

    [Fact]
    public void Tampered_ciphertext_fails_decryption()
    {
        var cipher = CreateCipher();
        var ciphertext = cipher.Encrypt(UserA, Secret);

        // Flip one bit in the middle of the payload (well past the magic-header/key-id
        // prefix, inside nonce/ciphertext/tag territory) — GCM must reject it.
        var raw = Base64UrlDecode(ciphertext);
        raw[raw.Length / 2] ^= 0x01;
        var tampered = Base64UrlEncode(raw);

        // ThrowsAny: the actual type is AuthenticationTagMismatchException (a
        // CryptographicException subclass) straight from System.Security.
        // Cryptography.AesGcm's tag check — itself evidence that the platform GCM
        // primitive is what rejects the tampering.
        Assert.ThrowsAny<CryptographicException>(() => cipher.Decrypt(UserA, tampered));
    }

    [Fact]
    public void Ciphertext_encrypted_for_one_user_fails_decryption_for_another()
    {
        // T162 item 4: simulates the EncryptedSecret column value being copied from
        // user A's MfaEnrollment row onto user B's — decryption is always attempted
        // with the row-owner's id in the purpose chain (GCM associated data), so the
        // authentication check must fail rather than yield A's secret for B's logins.
        var cipher = CreateCipher();
        var ciphertextForA = cipher.Encrypt(UserA, Secret);

        // ThrowsAny: actual type is AesGcm's AuthenticationTagMismatchException —
        // the purpose chain really is bound as GCM associated data, not a soft check.
        Assert.ThrowsAny<CryptographicException>(() => cipher.Decrypt(UserB, ciphertextForA));
    }

    // Data Protection emits base64url; hand-rolled here to keep the test free of a
    // WebUtilities dependency.
    private static byte[] Base64UrlDecode(string input)
    {
        var s = input.Replace('-', '+').Replace('_', '/');
        return Convert.FromBase64String(s.PadRight(s.Length + ((4 - (s.Length % 4)) % 4), '='));
    }

    private static string Base64UrlEncode(byte[] input) =>
        Convert.ToBase64String(input).TrimEnd('=').Replace('+', '-').Replace('/', '_');
}
