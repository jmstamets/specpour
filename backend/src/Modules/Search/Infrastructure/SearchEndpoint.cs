using System.Security.Claims;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Routing;
using OpenIddict.Abstractions;
using SpecPour.BuildingBlocks.Http;
using SpecPour.Modules.Search.Application;
using SpecPour.Modules.Search.Application.Ports;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Search.Infrastructure;

/// <summary>
/// GET /api/v1/search (T038, FR-049). Facet filtering composition is completed by
/// T148 (makeable-from-inventory) and T149 (rating) — content facets land alongside
/// T037's per-entity read endpoints, not here; Search itself stays entity-agnostic
/// per the T141 ADR. Both the "uses" (T155) and "makeable" (T148) facets resolve
/// their matching recipe IDs here (in this module's own endpoint, reaching into
/// other modules' Contracts ports, same shape as before) and pass them to
/// <see cref="ISearchPort"/> via <see cref="SearchQuery.EntityIdFilter"/> — applied
/// INSIDE the adapter's SQL, before pagination, fixing the previous post-filter-
/// after-pagination limitation for both facets at once (T148's explicit job).
/// </summary>
public static class SearchEndpoint
{
    private const int DefaultLimit = 20;

    public static void Map(IEndpointRouteBuilder endpoints) =>
        endpoints.MapApiV1Group().MapGet("/search", HandleAsync);

    private static async Task<Results<Ok<SearchResponse>, ProblemHttpResult>> HandleAsync(
        string? q,
        string? cursor,
        int? limit,
        string? uses,
        string? makeable,
        ClaimsPrincipal user,
        ISearchPort searchPort,
        Ingredients.Contracts.IIngredientLookupPort ingredientLookup,
        Catalog.Contracts.IRecipeLookupPort recipeLookup,
        Inventory.Contracts.IMakeabilityPort makeabilityPort,
        CancellationToken cancellationToken)
    {
        var pageSize = Math.Clamp(limit ?? DefaultLimit, 1, 100);
        var entityIdFilter = new Dictionary<string, IReadOnlyList<Guid>>();

        // T155/FR-050: hierarchy-aware "uses:<ingredient>" facet, complementing text
        // search — narrows to recipe-type results referencing the ingredient (or any
        // descendant).
        if (uses is not null && Guid.TryParse(uses, out var usesIngredientId))
        {
            var descendantIds = await ingredientLookup.GetDescendantIdsAsync(usesIngredientId, cancellationToken);
            var matchingRecipeIds = await recipeLookup.GetRecipeIdsUsingIngredientsAsync(descendantIds, cancellationToken);
            entityIdFilter["recipe"] = MergeRecipeFilter(entityIdFilter, matchingRecipeIds);
        }

        // T148/FR-050: makeable-from-inventory facet — bearer-only (needs the
        // caller's own inventory). Includes near-misses alongside fully-makeable
        // recipes, same as the /recipes facet; combined with "uses" above via
        // intersection (both facets narrow to "recipe", so applying both means both
        // must match — the merge helper intersects rather than unions).
        if (string.Equals(makeable, "true", StringComparison.OrdinalIgnoreCase))
        {
            if (user.Identity?.IsAuthenticated != true)
            {
                return TypedResults.Problem(title: "Sign-in required", statusCode: StatusCodes.Status401Unauthorized);
            }

            var userId = Guid.Parse(user.GetClaim(Claims.Subject)!);
            var makeability = await makeabilityPort.ComputeAsync(userId, cancellationToken);
            var matchedIds = makeability.Makeable.Select(m => m.RecipeId).Concat(makeability.NearMiss.Select(n => n.RecipeId)).ToList();
            entityIdFilter["recipe"] = MergeRecipeFilter(entityIdFilter, matchedIds);
        }

        var page = await searchPort.SearchAsync(
            new SearchQuery(q, new Dictionary<string, IReadOnlyList<string>>(), cursor, pageSize, entityIdFilter.Count > 0 ? entityIdFilter : null),
            cancellationToken);

        return TypedResults.Ok(new SearchResponse(
            [.. page.Items.Select(i => new SearchResultResponse(i.EntityType, i.EntityId, i.Title, i.Snippet, i.Score))],
            page.NextCursor));
    }

    /// <summary>Intersects with any already-computed "recipe" filter (from a prior facet this same request applied) rather than overwriting it, so combining "uses" and "makeable" means both must match.</summary>
    private static IReadOnlyList<Guid> MergeRecipeFilter(Dictionary<string, IReadOnlyList<Guid>> existing, IReadOnlyList<Guid> newIds) =>
        existing.TryGetValue("recipe", out var current) ? [.. current.Intersect(newIds)] : newIds;
}

public sealed record SearchResponse(IReadOnlyList<SearchResultResponse> Items, string? NextCursor);

public sealed record SearchResultResponse(string EntityType, Guid EntityId, string Title, string? Snippet, double Score);
