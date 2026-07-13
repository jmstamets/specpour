using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Http;
using SpecPour.BuildingBlocks.Library;
using SpecPour.Modules.Ingredients.Contracts;
using SpecPour.Modules.Ingredients.Domain;

namespace SpecPour.Modules.Ingredients.Infrastructure.Endpoints;

/// <summary>
/// GET /api/v1/ingredients, GET /api/v1/ingredients/{id} (T037, FR-014). Guest-accessible
/// (FR-004b) — only <see cref="ContentVisibility.Public"/> ingredients are returned.
/// </summary>
public static class IngredientEndpoints
{
    private const int DefaultLimit = 20;

    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        group.MapGet("/ingredients", ListAsync);
        group.MapGet("/ingredients/{id:guid}", GetAsync);
        group.MapGet("/ingredients/{id:guid}/recipes", GetRecipesUsingIngredientAsync);
    }

    private static async Task<IngredientPageResponse> ListAsync(
        string? category, string? cursor, int? limit, IngredientsDbContext db, CancellationToken cancellationToken)
    {
        var pageSize = Math.Clamp(limit ?? DefaultLimit, 1, 100);
        var offset = CursorPagination.Decode(cursor);

        var query = db.Ingredients.Where(i => i.Visibility == ContentVisibility.Public);
        if (category is not null)
        {
            query = query.Where(i => db.IngredientCategories.Any(c => c.Id == i.CategoryId && c.NameKey == category));
        }

        var ingredients = await query.OrderBy(i => i.Name).Skip(offset).Take(pageSize + 1).ToListAsync(cancellationToken);
        var hasMore = ingredients.Count > pageSize;
        var page = hasMore ? ingredients[..pageSize] : ingredients;
        var nextCursor = hasMore ? CursorPagination.Encode(offset + pageSize) : null;

        // Resolve parent-ingredient names (contract sweep) so a hierarchy-aware
        // browse (FR-014) can render "child of X", not a raw GUID. Same-module
        // (parents are ingredients too), batched in one query.
        var parentIds = page.Where(i => i.ParentId.HasValue).Select(i => i.ParentId!.Value).Distinct().ToList();
        var parentNames = await db.Ingredients
            .Where(i => parentIds.Contains(i.Id))
            .ToDictionaryAsync(i => i.Id, i => i.Name, cancellationToken);

        return new IngredientPageResponse(
            [.. page.Select(i => new IngredientSummaryResponse(
                i.Id,
                i.Name,
                i.ParentId,
                i.ParentId is { } pid ? parentNames.GetValueOrDefault(pid) : null))],
            nextCursor);
    }

    private static async Task<Results<Ok<IngredientDetailResponse>, NotFound>> GetAsync(
        Guid id,
        IngredientsDbContext db,
        Catalog.Contracts.IRecipeLookupPort recipeLookup,
        CancellationToken cancellationToken)
    {
        var ingredient = await db.Ingredients.FirstOrDefaultAsync(i => i.Id == id && i.Visibility == ContentVisibility.Public, cancellationToken);
        if (ingredient is null)
        {
            return TypedResults.NotFound();
        }

        var allergenKeys = await db.IngredientAllergens.Where(a => a.IngredientId == id)
            .Join(db.Allergens, a => a.AllergenId, al => al.Id, (a, al) => al.Key)
            .ToListAsync(cancellationToken);

        // Resolve the parent-ingredient name (same-module) and the defining-recipe
        // name (cross-module into catalog, for house-made ingredients) — contract
        // sweep, so the detail screen can render these references by name (FR-014/FR-017).
        var parentName = ingredient.ParentId is { } parentId
            ? await db.Ingredients.Where(i => i.Id == parentId).Select(i => i.Name).FirstOrDefaultAsync(cancellationToken)
            : null;

        string? definingRecipeName = null;
        if (ingredient.DefiningRecipeId is { } definingRecipeId)
        {
            var names = await recipeLookup.GetNamesAsync([definingRecipeId], cancellationToken);
            definingRecipeName = names.GetValueOrDefault(definingRecipeId);
        }

        return TypedResults.Ok(new IngredientDetailResponse(
            ingredient.Id,
            ingredient.Name,
            ingredient.ParentId,
            parentName,
            ingredient.Sources,
            ingredient.Description,
            ingredient.AbvPercent,
            allergenKeys,
            ingredient.DefiningRecipeId,
            definingRecipeName,
            ingredient.YieldQuantity,
            ingredient.YieldUnit,
            ingredient.ShelfLife,
            ingredient.StorageInstructions));
    }

    /// <summary>
    /// GET /api/v1/ingredients/{id}/recipes (T155, FR-014a): every ingredient entry
    /// surfaces the recipes that use it, hierarchy-aware — a class-level ingredient
    /// (e.g. "Rum") lists recipes using it or any descendant ("Aged Rum", "White
    /// Rum", ...), mirroring FR-024's equipment-&gt;recipes linking. Unpaginated: a
    /// single ingredient's usage list is small at V1 scale (add pagination if that
    /// changes).
    /// </summary>
    private static async Task<Results<Ok<IngredientRecipesResponse>, NotFound>> GetRecipesUsingIngredientAsync(
        Guid id,
        IngredientsDbContext db,
        IIngredientLookupPort ingredientLookup,
        Catalog.Contracts.IRecipeLookupPort recipeLookup,
        CancellationToken cancellationToken)
    {
        var exists = await db.Ingredients.AnyAsync(i => i.Id == id && i.Visibility == ContentVisibility.Public, cancellationToken);
        if (!exists)
        {
            return TypedResults.NotFound();
        }

        var descendantIds = await ingredientLookup.GetDescendantIdsAsync(id, cancellationToken);
        var recipeIds = await recipeLookup.GetRecipeIdsUsingIngredientsAsync(descendantIds, cancellationToken);
        var recipeNames = await recipeLookup.GetNamesAsync(recipeIds, cancellationToken);

        var items = recipeIds
            .Where(recipeNames.ContainsKey)
            .Select(recipeId => new IngredientRecipeRefResponse(recipeId, recipeNames[recipeId]))
            .OrderBy(r => r.Name, StringComparer.Ordinal)
            .ToList();

        return TypedResults.Ok(new IngredientRecipesResponse(items));
    }
}

public sealed record IngredientPageResponse(IReadOnlyList<IngredientSummaryResponse> Items, string? NextCursor);

/// <summary>FR-014a's bidirectional ingredient-&gt;recipes surface (T155).</summary>
public sealed record IngredientRecipesResponse(IReadOnlyList<IngredientRecipeRefResponse> Items);

public sealed record IngredientRecipeRefResponse(Guid Id, string Name);

public sealed record IngredientSummaryResponse(Guid Id, string Name, Guid? ParentId, string? ParentName);

public sealed record IngredientDetailResponse(
    Guid Id,
    string Name,
    Guid? ParentId,
    string? ParentName,
    IReadOnlyList<string> Sources,
    string? Description,
    decimal? AbvPercent,
    IReadOnlyList<string> Allergens,
    Guid? DefiningRecipeId,
    string? DefiningRecipeName,
    decimal? YieldQuantity,
    string? YieldUnit,
    TimeSpan? ShelfLife,
    string? StorageInstructions);
