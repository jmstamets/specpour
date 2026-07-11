namespace SpecPour.Modules.Measurements.Domain;

/// <summary>
/// Method-standard dilution assumptions (R14: stirred ~20-25%, shaken ~25-30%, built
/// ~0%). <see cref="DilutionPercentage"/> is the single canonical value the
/// calculators use (SC-005 requires exact-convention conformance, which needs one
/// precise number, not a range); <see cref="MinPercentage"/>/<see cref="MaxPercentage"/>
/// document the source range for display/curator context.
/// </summary>
public sealed class MethodDilution
{
    public required int ConventionTableVersion { get; init; }

    /// <summary>"stirred", "shaken", or "built" — matches Contracts.MixMethod by name.</summary>
    public required string MethodKey { get; init; }

    public required decimal DilutionPercentage { get; set; }

    public decimal? MinPercentage { get; set; }

    public decimal? MaxPercentage { get; set; }
}
