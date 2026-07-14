using System.Security.Cryptography;

namespace SpecPour.Modules.Identity.Application.Mfa;

/// <summary>
/// T163: pure generation logic for MFA recovery backup codes — no DB/DI dependency,
/// same "pure application logic" pattern as TotpCodeGenerator. Hashing/persistence
/// are the caller's concern (MfaEndpoints, via IPasswordHasher — see MfaBackupCode's
/// own doc comment for why hashing, not encryption).
/// </summary>
public static class BackupCodeGenerator
{
    public const int CodeCount = 10;

    // Crockford-ish alphabet minus visually ambiguous characters (0/O, 1/I/L) —
    // codes are meant to be hand-typed from a printed/written-down copy.
    private const string Alphabet = "ABCDEFGHJKMNPQRSTUVWXYZ23456789";
    private const int SegmentLength = 4;

    /// <summary>A fresh set of CodeCount single-use codes, formatted "XXXX-XXXX" for readability.</summary>
    public static IReadOnlyList<string> GenerateSet()
    {
        var codes = new List<string>(CodeCount);
        for (var i = 0; i < CodeCount; i++)
        {
            codes.Add($"{RandomSegment()}-{RandomSegment()}");
        }

        return codes;
    }

    private static string RandomSegment()
    {
        Span<char> segment = stackalloc char[SegmentLength];
        for (var i = 0; i < SegmentLength; i++)
        {
            segment[i] = Alphabet[RandomNumberGenerator.GetInt32(Alphabet.Length)];
        }

        return new string(segment);
    }
}
