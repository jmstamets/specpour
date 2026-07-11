namespace SpecPour.Modules.Measurements.Domain;

/// <summary>
/// Jurisdiction-aware grams-of-pure-alcohol-per-standard-drink (data-model.md
/// ConventionTable). Used by standard-drinks display (Principle XIII) and batch
/// per-serving-strength math (FR-034/FR-068). "default" is the strictest-rule-style
/// fallback for an unresolved jurisdiction, mirroring compliance's JurisdictionRule
/// pattern — real per-jurisdiction values are legal-counsel-supplied, not fabricated
/// here.
/// </summary>
public sealed class StandardDrinkGramValue
{
    public const string DefaultJurisdictionCode = "default";

    public required int ConventionTableVersion { get; init; }

    public required string JurisdictionCode { get; init; }

    public required decimal GramsPerStandardDrink { get; set; }
}
