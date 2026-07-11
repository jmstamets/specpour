namespace SpecPour.Modules.Measurements.Contracts;

/// <summary>
/// Units the conversion service accepts (R14). Oz/Ml/Cl are fixed physical
/// conversions; Dash/Barspoon are informal bar-tool units with a curator-adjustable
/// ml equivalence stored in ConventionTable, not a physical constant.
/// </summary>
public enum UnitOfMeasure
{
    Milliliters,
    Ounces,
    Centiliters,
    Dash,
    Barspoon,
}
