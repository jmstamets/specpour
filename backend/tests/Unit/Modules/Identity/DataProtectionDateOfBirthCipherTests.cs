using Microsoft.AspNetCore.DataProtection;
using SpecPour.Modules.Identity.Infrastructure;

namespace SpecPour.Tests.Unit.Modules.Identity;

/// <summary>
/// Sanity coverage for R6a's sole raw-DOB storage mechanism: encrypt/decrypt must
/// round-trip, and the stored ciphertext must never contain the plaintext date.
/// Full registration/export flows are covered by their own story's acceptance tests
/// (T045/T053); this is unit-level coverage for the cipher itself.
/// </summary>
public sealed class DataProtectionDateOfBirthCipherTests
{
    private static DataProtectionDateOfBirthCipher CreateCipher() =>
        new(DataProtectionProvider.Create("SpecPour.Tests"));

    [Fact]
    public void Encrypt_then_decrypt_round_trips_the_original_date()
    {
        var cipher = CreateCipher();
        var dateOfBirth = new DateOnly(1990, 6, 15);

        var ciphertext = cipher.Encrypt(dateOfBirth);
        var decrypted = cipher.Decrypt(ciphertext);

        Assert.Equal(dateOfBirth, decrypted);
    }

    [Fact]
    public void Ciphertext_never_contains_the_plaintext_date_representation()
    {
        var cipher = CreateCipher();
        var dateOfBirth = new DateOnly(1990, 6, 15);

        var ciphertext = cipher.Encrypt(dateOfBirth);

        Assert.DoesNotContain("1990-06-15", ciphertext, StringComparison.Ordinal);
    }

    [Fact]
    public void Two_encryptions_of_the_same_date_produce_different_ciphertext()
    {
        var cipher = CreateCipher();
        var dateOfBirth = new DateOnly(1990, 6, 15);

        var first = cipher.Encrypt(dateOfBirth);
        var second = cipher.Encrypt(dateOfBirth);

        // AES-GCM uses a fresh nonce per call, so identical plaintexts must not
        // produce identical ciphertext (defends against pattern-matching attacks).
        Assert.NotEqual(first, second);
    }
}
