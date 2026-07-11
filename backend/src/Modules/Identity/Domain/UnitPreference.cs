namespace SpecPour.Modules.Identity.Domain;

/// <summary>User's preferred measurement unit (data-model.md User.unit_preference); the
/// single measurements conversion service (R14, Principle VII) is the sole reader.</summary>
public enum UnitPreference
{
    Milliliters,
    Ounces,
    Centiliters,
}
