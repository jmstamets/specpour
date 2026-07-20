using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Library;
using SpecPour.Modules.Catalog.Contracts;
using SpecPour.Modules.Venues.Contracts;

namespace SpecPour.Modules.Catalog.Infrastructure;

/// <summary>Contract-sweep addition: implements the cross-module recipe name lookup.</summary>
public sealed class RecipeLookupAdapter(CatalogDbContext db, IVenueOwnershipPort venueOwnership) : IRecipeLookupPort
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

    public async Task<IReadOnlyList<RecipeMakeabilityInfo>> GetRecipesForMakeabilityAsync(Guid callerUserId, CancellationToken cancellationToken)
    {
        var ownedVenueIds = await venueOwnership.GetOwnedVenueIdsAsync(callerUserId, cancellationToken);

        var recipes = await db.Recipes
            .Where(r =>
                r.Visibility == ContentVisibility.Public ||
                (r.OwnerType == OwnerType.User && r.OwnerId == callerUserId) ||
                (r.OwnerType == OwnerType.Venue && r.OwnerId != null && ownedVenueIds.Contains(r.OwnerId.Value)))
            .ToListAsync(cancellationToken);

        var recipeIds = recipes.Select(r => r.Id).ToList();
        var lines = await db.RecipeIngredientLines
            .Where(l => recipeIds.Contains(l.RecipeId))
            .ToListAsync(cancellationToken);

        var linesByRecipe = lines
            .GroupBy(l => l.RecipeId)
            .ToDictionary(g => g.Key, g => (IReadOnlyList<RecipeIngredientLineInfo>)g
                .Select(l => new RecipeIngredientLineInfo(l.IngredientId, l.Quantity, l.Unit))
                .ToList());

        return [.. recipes.Select(r => new RecipeMakeabilityInfo(
            r.Id,
            r.PrimaryName,
            linesByRecipe.TryGetValue(r.Id, out var recipeLines) ? recipeLines : []))];
    }
}
