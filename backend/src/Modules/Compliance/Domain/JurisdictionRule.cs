namespace SpecPour.Modules.Compliance.Domain;

/// <summary>
/// data-model.md JurisdictionRule: legal-counsel-supplied per-jurisdiction legal
/// drinking age. The <see cref="DefaultCode"/> row is the strictest-rule fallback
/// applied when a caller's jurisdiction can't be resolved or has no specific rule
/// (R13) — seeded from day one since the system must have *some* answer before any
/// real per-jurisdiction legal data is entered.
/// </summary>
public sealed class JurisdictionRule
{
    public const string DefaultCode = "default";

    public required string JurisdictionCode { get; init; }

    public required int LegalDrinkingAge { get; set; }

    public required string Source { get; set; }

    public required DateTimeOffset EffectiveAt { get; set; }
}
