using SpecPour.Modules.Identity.Application.Mfa;

namespace SpecPour.Tests.Unit.Modules.Identity;

/// <summary>T050: unit coverage for the pure RFC 6238 TOTP wrapper.</summary>
public sealed class TotpCodeGeneratorTests
{
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
