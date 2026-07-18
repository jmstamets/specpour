using OtpNet;
using SpecPour.Modules.Identity.Application.Mfa;

namespace SpecPour.Tests.Unit.Modules.Identity;

/// <summary>T050: unit coverage for the pure RFC 6238 TOTP wrapper.</summary>
public sealed class TotpCodeGeneratorTests
{
    /// <summary>
    /// T187 (a): the enrollment QR encodes algorithm=SHA1, digits=6, period=30 (see
    /// <see cref="TotpCodeGenerator.BuildOtpAuthUri"/>). A real authenticator app reads
    /// those parameters off the otpauth:// URI and computes codes with EXACTLY them —
    /// so the risk is a silent mismatch between what the URI advertises and what the
    /// server's <see cref="TotpCodeGenerator.VerifyCode"/> actually accepts (Otp.NET's
    /// implicit defaults). If those ever diverged, every scanned code would fail
    /// mysteriously and no other test would catch it: the existing round-trip test
    /// computes AND verifies with the same implicit defaults, so it can't detect a
    /// default that disagrees with the advertised URI. This test closes that gap by
    /// computing the code with the URI's declared parameters spelled out explicitly and
    /// asserting the server verifies it — the empirical confirmation T187 requires.
    /// </summary>
    [Fact]
    public void VerifyCode_accepts_a_code_computed_with_the_uris_advertised_sha1_6digit_30s_parameters()
    {
        var secret = TotpCodeGenerator.GenerateSecret();

        // Independently reconstruct what an authenticator app does from the otpauth URI:
        // SHA1, 6 digits, 30-second step — spelled out, not relying on Otp.NET defaults.
        var authenticatorApp = new Totp(
            Base32Encoding.ToBytes(secret),
            step: 30,
            mode: OtpHashMode.Sha1,
            totpSize: 6);
        var codeFromScannedUri = authenticatorApp.ComputeTotp();

        Assert.True(TotpCodeGenerator.VerifyCode(secret, codeFromScannedUri));
    }

    [Fact]
    public void GenerateSecret_produces_a_secret_the_current_code_verifies_against()
    {
        var secret = TotpCodeGenerator.GenerateSecret();
        var code = TotpCodeGenerator.ComputeCurrentCode(secret);

        Assert.True(TotpCodeGenerator.VerifyCode(secret, code));
    }

    [Fact]
    public void VerifyCode_rejects_a_code_from_a_different_secret()
    {
        var secret = TotpCodeGenerator.GenerateSecret();
        var otherSecret = TotpCodeGenerator.GenerateSecret();
        var codeForOtherSecret = TotpCodeGenerator.ComputeCurrentCode(otherSecret);

        Assert.False(TotpCodeGenerator.VerifyCode(secret, codeForOtherSecret));
    }

    [Fact]
    public void VerifyCode_rejects_a_malformed_code()
    {
        var secret = TotpCodeGenerator.GenerateSecret();

        Assert.False(TotpCodeGenerator.VerifyCode(secret, "not-a-code"));
    }

    [Fact]
    public void BuildOtpAuthUri_carries_the_secret_and_issuer_for_QR_display()
    {
        var secret = TotpCodeGenerator.GenerateSecret();
        var uri = TotpCodeGenerator.BuildOtpAuthUri(secret, "user@example.test");

        Assert.StartsWith("otpauth://totp/SpecPour:user%40example.test", uri, StringComparison.Ordinal);
        Assert.Contains($"secret={secret}", uri, StringComparison.Ordinal);
    }
}
