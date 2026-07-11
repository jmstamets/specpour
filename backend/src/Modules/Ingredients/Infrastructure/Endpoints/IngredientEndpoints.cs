using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Http;
using SpecPour.BuildingBlocks.Library;
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

        return new IngredientPageResponse(
            [.. page.Select(i => new IngredientSummaryResponse(i.Id, i.Name, i.ParentId))],
            nextCursor);
    }

    private static async Task<Results<Ok<IngredientDetailResponse>, NotFound>> GetAsync(
        Guid id, IngredientsDbContext db, CancellationToken cancellationToken)
    {
        var ingredient = await db.Ingredients.FirstOrDefaultAsync(i => i.Id == id && i.Visibility == ContentVisibility.Public, cancellationToken);
        if (ingredient is null)
        {
            return TypedResults.NotFound();
        }

        var allergenKeys = await db.IngredientAllergens.Where(a => a.IngredientId == id)
            .Join(db.Allergens, a => a.AllergenId, al => al.Id, (a, al) => al.Key)
            .ToListAsync(cancellationToken);

        return TypedResults.Ok(new IngredientDetailResponse(
            ingredient.Id,
            ingredient.Name,
            ingredient.ParentId,
            ingredient.Sources,
            ingredient.Description,
            ingredient.AbvPercent,
            allergenKeys,
            ingredient.DefiningRecipeId,
            ingredient.YieldQuantity,
            ingredient.YieldUnit,
            ingredient.ShelfLife,
            ingredient.StorageInstructions));
    }
}

public sealed record IngredientPageResponse(IReadOnlyList<IngredientSummaryResponse> Items, string? NextCursor);

public sealed record IngredientSummaryResponse(Guid Id, string Name, Guid? ParentId);

public sealed record IngredientDetailResponse(
    Guid Id,
    string Name,
    Guid? ParentId,
    IReadOnlyList<string> Sources,
    string? Description,
    decimal? AbvPercent,
    IReadOnlyList<string> Allergens,
    Guid? DefiningRecipeId,
    decimal? YieldQuantity,
    string? YieldUnit,
    TimeSpan? ShelfLife,
    string? StorageInstructions);
