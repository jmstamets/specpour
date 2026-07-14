using SpecPour.Modules.Identity.Application.Mfa;

namespace SpecPour.Tests.Unit.Modules.Identity;

/// <summary>T163: unit coverage for the pure backup-code generation logic.</summary>
public sealed class BackupCodeGeneratorTests
{
    [Fact]
    public void GenerateSet_produces_the_expected_count()
    {
        var codes = BackupCodeGenerator.GenerateSet();

        Assert.Equal(BackupCodeGenerator.CodeCount, codes.Count);
    }

    [Fact]
    public void GenerateSet_produces_codes_with_no_duplicates()
    {
        var codes = BackupCodeGenerator.GenerateSet();

        Assert.Equal(codes.Count, codes.Distinct().Count());
    }

    [Fact]
    public void GenerateSet_produces_hand_typeable_grouped_codes()
    {
        var codes = BackupCodeGenerator.GenerateSet();

        Assert.All(codes, code =>
        {
            Assert.Matches("^[A-Z2-9]{4}-[A-Z2-9]{4}$", code);
            // Visually ambiguous characters (0/O, 1/I/L) are excluded — codes are
            // meant to be hand-typed from a printed/written-down copy.
            Assert.DoesNotContain('0', code);
            Assert.DoesNotContain('O', code);
            Assert.DoesNotContain('1', code);
            Assert.DoesNotContain('I', code);
            Assert.DoesNotContain('L', code);
        });
    }

    [Fact]
    public void Two_generated_sets_do_not_overlap()
    {
        var first = BackupCodeGenerator.GenerateSet();
        var second = BackupCodeGenerator.GenerateSet();

        Assert.Empty(first.Intersect(second));
    }
}
