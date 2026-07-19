using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Library;
using SpecPour.Modules.Catalog.Contracts;
using SpecPour.Modules.Inventory.Application.Makeability;
using SpecPour.Modules.Inventory.Contracts;

namespace SpecPour.Modules.Inventory.Infrastructure;

/// <summary>
/// T148's implementation of the cross-module makeability port — the exact same
/// inventory-fetch + <see cref="MakeabilityCalculator"/> invocation
/// <c>MakeabilityEndpoints.GetAsync</c> (T067) used inline before this extraction;
/// both `GET /inventory/makeable` and the `/recipes`/`/search` makeable facet now
/// share this one computation rather than each re-deriving match state.
/// </summary>
public sealed class MakeabilityAdapter(InventoryDbContext db, IRecipeLookupPort recipeLookup, MakeabilityCalculator calculator) : IMakeabilityPort
{
    public async Task<MakeabilityInfo> ComputeAsync(Guid userId, CancellationToken cancellationToken)
    {
        var inventoryItems = await db.InventoryItems
            .Where(i => i.OwnerType == OwnerType.User && i.OwnerId == userId)
            .Select(i => new { i.Id, i.IngredientId })
            .ToListAsync(cancellationToken);
        var inventoryPairs = inventoryItems.Select(i => (i.Id, i.IngredientId)).ToList();

        var recipes = await recipeLookup.GetRecipesForMakeabilityAsync(userId, cancellationToken);
        var result = await calculator.ComputeAsync(inventoryPairs, recipes, cancellationToken);

        return new MakeabilityInfo(
            [.. result.Makeable.Select(ToInfo)],
            [.. result.NearMiss.Select(ToInfo)]);
    }

    private static MakeableRecipeInfo ToInfo(MakeableRecipe recipe) =>
        new(recipe.RecipeId, recipe.RecipeName, recipe.MatchQuality, [.. recipe.Lines.Select(ToInfo)]);

    private static NearMissRecipeInfo ToInfo(NearMissRecipe recipe) =>
        new(recipe.RecipeId, recipe.RecipeName, [.. recipe.Lines.Select(ToInfo)]);

    private static MakeabilityLineInfo ToInfo(RecipeLineMatch line) =>
        new(line.RequirementIngredientId, line.RequirementQuantity, line.RequirementUnit, line.MatchQuality, line.SatisfiedByInventoryItemId, line.SatisfiedByIngredientId);
}
