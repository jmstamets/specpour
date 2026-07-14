using OtpNet;

namespace SpecPour.Modules.Identity.Application.Mfa;

/// <summary>
/// Pure RFC 6238 TOTP logic (T050), wrapping Otp.NET (R6: proven library over
/// hand-rolled crypto). No DB/DI dependency — same "pure application logic" pattern as
/// AgeCalculator. Secret generation/encryption and persistence are the caller's concern
/// (MfaEndpoints + MfaSecretCipher).
/// </summary>
public static class TotpCodeGenerator
{
    private const string Issuer = "SpecPour";
    private const int SecretByteLength = 20;

    /// <summary>Generates a new random base32-encoded secret, suitable for otpauth:// and manual entry.</summary>
    public static string GenerateSecret() => Base32Encoding.ToString(KeyGeneration.GenerateRandomKey(SecretByteLength));

    /// <summary>otpauth:// URI for QR-code display/manual entry in an authenticator app.</summary>
    public static string BuildOtpAuthUri(string base32Secret, string accountEmail) =>
        $"otpauth://totp/{Uri.EscapeDataString(Issuer)}:{Uri.EscapeDataString(accountEmail)}" +
        $"?secret={base32Secret}&issuer={Uri.EscapeDataString(Issuer)}&algorithm=SHA1&digits=6&period=30";

    /// <summary>Verifies a 6-digit code against the secret, allowing one step of clock drift either way.</summary>
    public static bool VerifyCode(string base32Secret, string code)
    {
        var totp = new Totp(Base32Encoding.ToBytes(base32Secret));
        return totp.VerifyTotp(code, out _, new VerificationWindow(previous: 1, future: 1));
    }

    /// <summary>
    /// The current 6-digit code for the secret — what a real authenticator app would
    /// display right now. Test-only in practice (acceptance steps standing in for a
    /// user's phone), but kept here alongside VerifyCode since both are the same
    /// otp.net Totp wrapper.
    /// </summary>
    public static string ComputeCurrentCode(string base32Secret) => new Totp(Base32Encoding.ToBytes(base32Secret)).ComputeTotp();
}
