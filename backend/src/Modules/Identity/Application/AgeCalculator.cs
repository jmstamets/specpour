namespace SpecPour.Modules.Identity.Application;

/// <summary>
/// Pure age-in-years calculation shared by registration's underage check (T047) and
/// the age-predicate port's decrypt path (T048), so both compute age identically.
/// </summary>
public static class AgeCalculator
{
    public static int CalculateAge(DateOnly dateOfBirth, DateOnly asOf)
    {
        var age = asOf.Year - dateOfBirth.Year;
        if (dateOfBirth > asOf.AddYears(-age))
        {
            age--;
        }

        return age;
    }
}
