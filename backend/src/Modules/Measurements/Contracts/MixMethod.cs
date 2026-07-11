namespace SpecPour.Modules.Measurements.Contracts;

/// <summary>Preparation method — drives the dilution percentage used by ABV/standard-drinks/batch math (R14).</summary>
public enum MixMethod
{
    Stirred,
    Shaken,
    Built,
}
