using SpecPour.Modules.Identity.Application;

namespace SpecPour.Tests.Unit.Modules.Identity;

/// <summary>T047/T048: unit coverage for the pure age-in-years calculation shared by registration's underage check and the age-predicate port.</summary>
public sealed class AgeCalculatorTests
{
    [Fact]
    public void BirthdayAlreadyPassedThisYear_countsTheLaterYear()
    {
        var age = AgeCalculator.CalculateAge(new DateOnly(2000, 1, 1), new DateOnly(2026, 6, 1));
        Assert.Equal(26, age);
    }

    [Fact]
    public void BirthdayNotYetReachedThisYear_countsOneLess()
    {
        var age = AgeCalculator.CalculateAge(new DateOnly(2000, 12, 31), new DateOnly(2026, 6, 1));
        Assert.Equal(25, age);
    }

    [Fact]
    public void BirthdayIsToday_countsTheNewAge()
    {
        var age = AgeCalculator.CalculateAge(new DateOnly(2000, 6, 1), new DateOnly(2026, 6, 1));
        Assert.Equal(26, age);
    }

    [Fact]
    public void LeapDayBirthday_doesNotThrowOnNonLeapYear()
    {
        var age = AgeCalculator.CalculateAge(new DateOnly(2000, 2, 29), new DateOnly(2025, 3, 1));
        Assert.Equal(25, age);
    }
}
