using Microsoft.EntityFrameworkCore;
using SpecPour.Modules.Measurements.Contracts;

namespace SpecPour.Modules.Measurements.Infrastructure;

/// <summary>
/// Implements the single measurements conversion service (Principle VII) against the
/// currently-effective <c>ConventionTable</c>. Oz/Cl are fixed physical constants;
/// Dash/Barspoon, method dilution, and standard-drink grams are read from versioned
/// reference data (R14) so curators can adjust them without a release.
/// </summary>
public sealed class MeasurementConversionService(MeasurementsDbContext db) : IMeasurementConversionService
{
    // Fixed physical conversions — not curator data, unlike dash/barspoon.
    private const decimal MillilitersPerOunce = 29.5735m;
    private const decimal MillilitersPerCentiliter = 10m;

    public async Task<decimal> ToMillilitersAsync(decimal quantity, UnitOfMeasure unit, CancellationToken cancellationToken) => unit switch
    {
        UnitOfMeasure.Milliliters => quantity,
        UnitOfMeasure.Ounces => quantity * MillilitersPerOunce,
        UnitOfMeasure.Centiliters => quantity * MillilitersPerCentiliter,
        UnitOfMeasure.Dash => quantity * await GetUnitEquivalenceAsync("dash", cancellationToken),
        UnitOfMeasure.Barspoon => quantity * await GetUnitEquivalenceAsync("barspoon", cancellationToken),
        _ => throw new ArgumentOutOfRangeException(nameof(unit), unit, "Unknown unit of measure."),
    };

    public async Task<decimal> FromMillilitersAsync(decimal milliliters, UnitOfMeasure targetUnit, CancellationToken cancellationToken) => targetUnit switch
    {
        UnitOfMeasure.Milliliters => milliliters,
        UnitOfMeasure.Ounces => milliliters / MillilitersPerOunce,
        UnitOfMeasure.Centiliters => milliliters / MillilitersPerCentiliter,
        UnitOfMeasure.Dash => milliliters / await GetUnitEquivalenceAsync("dash", cancellationToken),
        UnitOfMeasure.Barspoon => milliliters / await GetUnitEquivalenceAsync("barspoon", cancellationToken),
        _ => throw new ArgumentOutOfRangeException(nameof(targetUnit), targetUnit, "Unknown unit of measure."),
    };

    public async Task<decimal> GetMethodDilutionPercentageAsync(MixMethod method, CancellationToken cancellationToken)
    {
        var version = await GetEffectiveVersionAsync(cancellationToken);
        var methodKey = method.ToString().ToLowerInvariant();

        var dilution = await db.MethodDilutions.FindAsync([version, methodKey], cancellationToken)
            ?? throw new InvalidOperationException($"No MethodDilution row for '{methodKey}' in convention table version {version}.");

        return dilution.DilutionPercentage;
    }

    public async Task<decimal> GetStandardDrinkGramsAsync(string jurisdictionCode, CancellationToken cancellationToken)
    {
        var version = await GetEffectiveVersionAsync(cancellationToken);

        var value = await db.StandardDrinkGramValues.FindAsync([version, jurisdictionCode], cancellationToken)
            ?? await db.StandardDrinkGramValues.FindAsync([version, Domain.StandardDrinkGramValue.DefaultJurisdictionCode], cancellationToken)
            ?? throw new InvalidOperationException($"No default StandardDrinkGramValue row in convention table version {version}.");

        return value.GramsPerStandardDrink;
    }

    private async Task<decimal> GetUnitEquivalenceAsync(string unitKey, CancellationToken cancellationToken)
    {
        var version = await GetEffectiveVersionAsync(cancellationToken);

        var equivalence = await db.UnitEquivalences.FindAsync([version, unitKey], cancellationToken)
            ?? throw new InvalidOperationException($"No UnitEquivalence row for '{unitKey}' in convention table version {version}.");

        return equivalence.MilliliterValue;
    }

    private async Task<int> GetEffectiveVersionAsync(CancellationToken cancellationToken)
    {
        var version = await db.ConventionTables
            .Where(c => c.Effective)
            .Select(c => (int?)c.Version)
            .SingleOrDefaultAsync(cancellationToken);

        return version ?? throw new InvalidOperationException("No effective ConventionTable is configured.");
    }
}
