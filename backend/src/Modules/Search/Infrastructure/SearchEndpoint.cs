using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using SpecPour.BuildingBlocks.Http;
using SpecPour.Modules.Search.Application;
using SpecPour.Modules.Search.Application.Ports;

namespace SpecPour.Modules.Search.Infrastructure;

/// <summary>
/// GET /api/v1/search (T038, FR-049). Facet filtering composition is completed by
/// T148 (makeable-from-inventory) and T149 (rating) — this endpoint passes through
/// whatever facets the caller supplies today (content facets land alongside T037's
/// per-entity read endpoints, not here; Search itself stays entity-agnostic per the
/// T141 ADR).
/// </summary>
public static class SearchEndpoint
{
    private const int DefaultLimit = 20;

    public static void Map(IEndpointRouteBuilder endpoints) =>
        endpoints.MapApiV1Group().MapGet("/search", HandleAsync);

    private static async Task<SearchResponse> HandleAsync(
        string? q,
        string? cursor,
        int? limit,
        string? uses,
        ISearchPort searchPort,
        Ingredients.Contracts.IIngredientLookupPort ingredientLookup,
        Catalog.Contracts.IRecipeLookupPort recipeLookup,
        CancellationToken cancellationToken)
    {
        var pageSize = Math.Clamp(limit ?? DefaultLimit, 1, 100);

        var page = await searchPort.SearchAsync(
            new SearchQuery(q, new Dictionary<string, IReadOnlyList<string>>(), cursor, pageSize),
            cancellationToken);

        var items = page.Items;

        // T155/FR-050: hierarchy-aware "uses:<ingredient>" facet, complementing text
        // search — narrows to recipe-type results referencing the ingredient (or any
        // descendant). Applied as a post-filter (same shape as RecipeEndpoints'
        // equipment/glassware facets) rather than a change to
        // PostgresFullTextSearchAdapter's generic union query, so Search stays
        // entity-agnostic (T141 ADR). Known limitation: it filters AFTER the
        // adapter's own pagination, so a page can come back with fewer than `limit`
        // items when this facet removes matches — full facet-aware pagination is
        // T148/T149's job (still-open tasks whose explicit purpose is completing
        // ISearchPort's facet composition), not this one.
        if (uses is not null && Guid.TryParse(uses, out var usesIngredientId))
        {
            var descendantIds = await ingredientLookup.GetDescendantIdsAsync(usesIngredientId, cancellationToken);
            var matchingRecipeIds = await recipeLookup.GetRecipeIdsUsingIngredientsAsync(descendantIds, cancellationToken);
            items = [.. items.Where(i => i.EntityType == "recipe" && matchingRecipeIds.Contains(i.EntityId))];
        }

        return new SearchResponse(
            [.. items.Select(i => new SearchResultResponse(i.EntityType, i.EntityId, i.Title, i.Snippet, i.Score))],
            page.NextCursor);
    }
}

public sealed record SearchResponse(IReadOnlyList<SearchResultResponse> Items, string? NextCursor);

public sealed record SearchResultResponse(string EntityType, Guid EntityId, string Title, string? Snippet, double Score);
