using SpecPour.Modules.Catalog.Domain;
using SpecPour.Modules.Ingredients.Contracts;
using SpecPour.Modules.Measurements.Contracts;

namespace SpecPour.Modules.Catalog.Application.DerivedData;

/// <summary>
/// T036/FR-022: ABV and standard drinks, accounting for the recipe's preparation
/// method dilution (R14), plus FR-055's conservative allergen roll-up. Assumes
/// every <see cref="Recipe"/> as modeled describes exactly one serving (V1's
/// recipes are single-serving; batch/scaling math is a separate downstream
/// concern, US5) — there is no explicit "servings" field to multiply by.
/// </summary>
public sealed class RecipeDerivedDataCalculator(
    IMeasurementConversionService conversionService,
    IIngredientLookupPort ingredientLookup) : IRecipeDerivedDataCalculator
{
    /// <summary>Grams of pure ethanol per milliliter — a fixed physical constant, same category as MeasurementConversionService's oz/cl constants.</summary>
    private const decimal EthanolDensityGramsPerMilliliter = 0.789m;

    public async Task<RecipeDerivedData> CalculateAsync(Recipe recipe, IReadOnlyList<RecipeIngredientLine> ingredientLines, CancellationToken cancellationToken)
    {
        var ingredientIds = ingredientLines.Select(l => l.IngredientId).Distinct().ToList();
        var summaries = await ingredientLookup.GetSummariesAsync(ingredientIds, cancellationToken);

        var totalVolumeMl = 0m;
        var totalAlcoholMl = 0m;
        var allergens = new SortedSet<string>(StringComparer.Ordinal);

        foreach (var line in ingredientLines)
        {
            if (!summaries.TryGetValue(line.IngredientId, out var summary))
            {
                continue;
            }

            foreach (var allergenKey in summary.AllergenKeys)
            {
                allergens.Add(allergenKey);
            }

            // Non-liquid units (a whole egg, a lime wedge, a mint sprig) don't
            // participate in the volume/dilution math — they contribute no
            // meaningful liquid volume and (being garnish/non-spirit) no alcohol.
            if (TryParseUnit(line.Unit) is not { } unit)
            {
                continue;
            }

            var lineVolumeMl = await conversionService.ToMillilitersAsync(line.Quantity, unit, cancellationToken);
            totalVolumeMl += lineVolumeMl;
            totalAlcoholMl += lineVolumeMl * ((summary.AbvPercent ?? 0m) / 100m);
        }

        var dilutionPercentage = await conversionService.GetMethodDilutionPercentageAsync(recipe.Method, cancellationToken);
        var finalVolumeMl = totalVolumeMl * (1 + dilutionPercentage);

        var abvPercent = finalVolumeMl > 0 ? totalAlcoholMl / finalVolumeMl * 100m : 0m;

        var alcoholGrams = totalAlcoholMl * EthanolDensityGramsPerMilliliter;
        // No per-request jurisdiction context exists at this layer (that's
        // Compliance's concern, not Catalog's) — "default" is Measurements'
        // strictest-rule-style fallback code (StandardDrinkGramValue.DefaultJurisdictionCode,
        // not reachable from here since Catalog only depends on Measurements.Contracts),
        // and GetStandardDrinkGramsAsync already falls back to it for any
        // unresolved code, so passing it directly is equivalent and explicit.
        var gramsPerStandardDrink = await conversionService.GetStandardDrinkGramsAsync("default", cancellationToken);
        var standardDrinks = gramsPerStandardDrink > 0 ? alcoholGrams / gramsPerStandardDrink : 0m;

        return new RecipeDerivedData(Math.Round(abvPercent, 2), Math.Round(standardDrinks, 2), allergens.ToList());
    }

    /// <summary>
    /// Maps a recipe's free-form display unit string (FR-020 needs "whole",
    /// "leaf", "dash" as written, not just the liquid-volume set) onto
    /// Measurements' <see cref="UnitOfMeasure"/> where one applies. Anything
    /// unrecognized is treated as a non-liquid unit, not an error.
    /// </summary>
    private static UnitOfMeasure? TryParseUnit(string unit) => unit.Trim().ToLowerInvariant() switch
    {
        "oz" or "ounce" or "ounces" => UnitOfMeasure.Ounces,
        "ml" or "milliliter" or "milliliters" or "millilitre" or "millilitres" => UnitOfMeasure.Milliliters,
        "cl" or "centiliter" or "centiliters" or "centilitre" or "centilitres" => UnitOfMeasure.Centiliters,
        "dash" or "dashes" => UnitOfMeasure.Dash,
        "barspoon" or "bsp" or "bar spoon" => UnitOfMeasure.Barspoon,
        _ => null,
    };
}
