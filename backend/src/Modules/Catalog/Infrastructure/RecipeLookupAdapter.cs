using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Library;
using SpecPour.Modules.Catalog.Contracts;

namespace SpecPour.Modules.Catalog.Infrastructure;

/// <summary>Contract-sweep addition: implements the cross-module recipe name lookup.</summary>
public sealed class RecipeLookupAdapter(CatalogDbContext db) : IRecipeLookupPort
{
    public async Task<IReadOnlyDictionary<Guid, string>> GetNamesAsync(
        IReadOnlyCollection<Guid> recipeIds, CancellationToken cancellationToken)
    {
        if (recipeIds.Count == 0)
        {
            return new Dictionary<Guid, string>();
        }

        return await db.Recipes
            .Where(r => recipeIds.Contains(r.Id))
            .ToDictionaryAsync(r => r.Id, r => r.PrimaryName, cancellationToken);
    }

    public async Task<IReadOnlyList<Guid>> GetRecipeIdsUsingIngredientsAsync(
        IReadOnlyCollection<Guid> ingredientIds, CancellationToken cancellationToken)
    {
        if (ingredientIds.Count == 0)
        {
            return [];
        }

        // Guest-accessible callers (FR-014a/FR-050's facet) must never see private
        // recipes through this port — same Visibility filter every other
        // guest-facing read applies (RecipeEndpoints.ListAsync/GetAsync).
        return await db.RecipeIngredientLines
            .Where(l => ingredientIds.Contains(l.IngredientId))
            .Join(db.Recipes.Where(r => r.Visibility == ContentVisibility.Public), l => l.RecipeId, r => r.Id, (l, r) => r.Id)
            .Distinct()
            .ToListAsync(cancellationToken);
    }

    public async Task<IReadOnlyList<Guid>> GetIngredientIdsUsedByAsync(Guid recipeId, CancellationToken cancellationToken) =>
        await db.RecipeIngredientLines
            .Where(l => l.RecipeId == recipeId)
            .Select(l => l.IngredientId)
            .Distinct()
            .ToListAsync(cancellationToken);
}
