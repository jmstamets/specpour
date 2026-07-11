namespace SpecPour.Modules.Measurements.Domain;

/// <summary>
/// Curator-adjustable ml equivalence for an informal bar-tool unit (R14: dash = 0.92
/// ml, barspoon = 5 ml). Physical units (oz/cl) are NOT stored here — they're fixed
/// constants in the conversion service.
/// </summary>
public sealed class UnitEquivalence
{
    public required int ConventionTableVersion { get; init; }

    /// <summary>"dash" or "barspoon" — matches Contracts.UnitOfMeasure by name.</summary>
    public required string UnitKey { get; init; }

    public required decimal MilliliterValue { get; set; }
}
