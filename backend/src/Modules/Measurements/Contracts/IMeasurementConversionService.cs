namespace SpecPour.Modules.Measurements.Contracts;

/// <summary>
/// The single measurements conversion service (constitution Principle VII: exactly
/// one service owns unit preference and conversion — no module hand-rolls its own
/// ml/oz math). Backs the ABV/standard-drinks calculator (T036, Catalog module),
/// scaling (T073), batching (T074), and costing (T075) — all cross-module consumers
/// depend on this Contracts interface, never on Measurements' Domain/Infrastructure.
/// All values are read from the latest-effective <c>ConventionTable</c> (versioned
/// reference data, R14) except the fixed physical oz/cl conversions.
/// </summary>
public interface IMeasurementConversionService
{
    Task<decimal> ToMillilitersAsync(decimal quantity, UnitOfMeasure unit, CancellationToken cancellationToken);

    Task<decimal> FromMillilitersAsync(decimal milliliters, UnitOfMeasure targetUnit, CancellationToken cancellationToken);

    /// <summary>The canonical dilution percentage (e.g. 0.225 for 22.5%) for a mix method, from the active convention table.</summary>
    Task<decimal> GetMethodDilutionPercentageAsync(MixMethod method, CancellationToken cancellationToken);

    /// <summary>Grams of pure alcohol per standard drink for a jurisdiction (falls back to "default" when unresolved, mirroring compliance's strictest-rule pattern).</summary>
    Task<decimal> GetStandardDrinkGramsAsync(string jurisdictionCode, CancellationToken cancellationToken);
}
