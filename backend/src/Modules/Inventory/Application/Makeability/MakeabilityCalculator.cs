using SpecPour.Modules.Catalog.Contracts;
using SpecPour.Modules.Ingredients.Contracts;

namespace SpecPour.Modules.Inventory.Application.Makeability;

/// <summary>
/// T067: hierarchy + curated substitution resolution, near-miss detection (FR-031).
/// Takes the caller's inventory and visible recipes as input (domain data already
/// fetched by the Infrastructure endpoint layer) rather than querying any DbContext
/// itself — same shape as <c>RecipeDerivedDataCalculator</c>.
///
/// Match-quality ladder (docs/specification-statement.md §2): exact-product &gt;
/// class-satisfied &gt; substitution &gt; missing. Each recipe line is resolved in that
/// priority order:
///   1. Exact product: an inventory item with the same ingredient id as the line.
///   2. Class-satisfied: an inventory item that is a DESCENDANT of the line's
///      ingredient (the line specifies a class, the held item is more specific) —
///      per statement §2, this is a TRUE MATCH, never a substitution.
///   3. Substitution (upward): an inventory item that is an ANCESTOR of the line's
///      ingredient (the line specifies a product, the held item is a broader class
///      standing in for it) — upward substitution per the ladder's direction rule.
///   4. Substitution (curated): an inventory item matching a curated
///      <c>SubstitutionRule</c> for the line's ingredient (sideways substitution).
///   5. Missing: no path found.
///
/// Near-miss computation runs AFTER this resolution (per the T067 directive
/// amendment) — a line covered by any of the four match paths above is not missing;
/// only a genuinely unmatched line counts toward the near-miss threshold. A recipe
/// with more missing lines than the threshold is absent entirely, not near-missed
/// (T064's empty-inventory edge case: near-miss thresholds don't list everything).
/// </summary>
public sealed class MakeabilityCalculator(IIngredientLookupPort ingredientLookup)
{
    /// <summary>A recipe missing more than this many lines is absent from both lists entirely, not near-missed.</summary>
    private const int NearMissMaxMissingLines = 1;

    public async Task<MakeabilityResult> ComputeAsync(
        IReadOnlyList<(Guid InventoryItemId, Guid IngredientId)> inventoryItems,
        IReadOnlyList<RecipeMakeabilityInfo> recipes,
        CancellationToken cancellationToken)
    {
        var makeable = new List<MakeableRecipe>();
        var nearMiss = new List<NearMissRecipe>();

        foreach (var recipe in recipes)
        {
            if (recipe.Lines.Count == 0)
            {
                // Zero-ingredient recipes are trivially makeable (T064 edge case).
                makeable.Add(new MakeableRecipe(recipe.RecipeId, recipe.RecipeName, "exact-product", []));
                continue;
            }

            var lineMatches = new List<RecipeLineMatch>();
            foreach (var line in recipe.Lines)
            {
                lineMatches.Add(await ResolveLineAsync(line, inventoryItems, cancellationToken));
            }

            var missingCount = lineMatches.Count(l => l.MatchQuality == "missing");
            if (missingCount == 0)
            {
                makeable.Add(new MakeableRecipe(recipe.RecipeId, recipe.RecipeName, AggregateQuality(lineMatches), lineMatches));
            }
            else if (missingCount <= NearMissMaxMissingLines)
            {
                nearMiss.Add(new NearMissRecipe(recipe.RecipeId, recipe.RecipeName, lineMatches));
            }
            // Else: too far off to surface at all — the empty-inventory edge case.
        }

        return new MakeabilityResult(makeable, nearMiss);
    }

    private async Task<RecipeLineMatch> ResolveLineAsync(
        RecipeIngredientLineInfo line,
        IReadOnlyList<(Guid InventoryItemId, Guid IngredientId)> inventoryItems,
        CancellationToken cancellationToken)
    {
        // 1. Exact product.
        var exact = inventoryItems.FirstOrDefault(i => i.IngredientId == line.IngredientId);
        if (exact != default)
        {
            return Satisfied(line, "exact-product", exact);
        }

        // 2. Class-satisfied: a held item descending from the line's (class-level) ingredient.
        var descendantsOfRequirement = await ingredientLookup.GetDescendantIdsAsync(line.IngredientId, cancellationToken);
        var classMatch = inventoryItems.FirstOrDefault(i => descendantsOfRequirement.Contains(i.IngredientId));
        if (classMatch != default)
        {
            return Satisfied(line, "class-satisfied", classMatch);
        }

        // 3. Substitution (upward): a held item that is an ancestor of the line's (product-level) ingredient.
        foreach (var item in inventoryItems)
        {
            var descendantsOfHeldItem = await ingredientLookup.GetDescendantIdsAsync(item.IngredientId, cancellationToken);
            if (descendantsOfHeldItem.Contains(line.IngredientId))
            {
                return Satisfied(line, "substitution", item);
            }
        }

        // 4. Substitution (curated sibling/cross rule).
        var substitutes = await ingredientLookup.GetSubstitutesForAsync(line.IngredientId, cancellationToken);
        var substituteIds = substitutes.Select(s => s.IngredientId).ToHashSet();
        var curatedMatch = inventoryItems.FirstOrDefault(i => substituteIds.Contains(i.IngredientId));
        if (curatedMatch != default)
        {
            return Satisfied(line, "substitution", curatedMatch);
        }

        return new RecipeLineMatch(line.IngredientId, line.Quantity, line.Unit, "missing", null, null);
    }

    private static RecipeLineMatch Satisfied(RecipeIngredientLineInfo line, string matchQuality, (Guid InventoryItemId, Guid IngredientId) item) =>
        new(line.IngredientId, line.Quantity, line.Unit, matchQuality, item.InventoryItemId, item.IngredientId);

    /// <summary>The recipe-level quality is a derived summary — the loosest quality among its (all-satisfied) lines — never independent truth.</summary>
    private static string AggregateQuality(IReadOnlyList<RecipeLineMatch> lines)
    {
        if (lines.Any(l => l.MatchQuality == "substitution"))
        {
            return "substitution";
        }

        return lines.Any(l => l.MatchQuality == "class-satisfied") ? "class-satisfied" : "exact-product";
    }
}
