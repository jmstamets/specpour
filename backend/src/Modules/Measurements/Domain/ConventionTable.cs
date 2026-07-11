namespace SpecPour.Modules.Measurements.Domain;

/// <summary>
/// data-model.md ConventionTable: versioned reference data (R14) — unit
/// equivalences, method dilution percentages, standard-drink gram values. Curators
/// adjust by adding a new version, never editing history in place (forward-only, same
/// posture as schema migrations); <see cref="Effective"/> marks the currently-active
/// version. Child rows (<see cref="UnitEquivalence"/>, <see cref="MethodDilution"/>,
/// <see cref="StandardDrinkGramValue"/>) key off <see cref="Version"/>.
/// </summary>
public sealed class ConventionTable
{
    public required int Version { get; init; }

    public required DateTimeOffset EffectiveAt { get; init; }

    public required bool Effective { get; set; }

    public string? Notes { get; set; }
}
