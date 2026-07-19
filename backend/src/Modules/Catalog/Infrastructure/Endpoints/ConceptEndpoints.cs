using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Http;
using SpecPour.BuildingBlocks.Library;
using SpecPour.Modules.Catalog.Domain;

namespace SpecPour.Modules.Catalog.Infrastructure.Endpoints;

/// <summary>GET /api/v1/concepts, GET /api/v1/concepts/{id} (T037, FR-021).</summary>
public static class ConceptEndpoints
{
    private const int DefaultLimit = 20;

    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        group.MapGet("/concepts", ListAsync);
        group.MapGet("/concepts/{id:guid}", GetAsync);
    }

    private static async Task<ConceptPageResponse> ListAsync(
        string? cursor, int? limit, CatalogDbContext db, CancellationToken cancellationToken)
    {
        var pageSize = Math.Clamp(limit ?? DefaultLimit, 1, 100);
        var offset = CursorPagination.Decode(cursor);

        var concepts = await db.ConceptPages
            .OrderBy(c => c.Name)
            .Skip(offset)
            .Take(pageSize + 1)
            .ToListAsync(cancellationToken);

        var hasMore = concepts.Count > pageSize;
        var page = hasMore ? concepts[..pageSize] : concepts;
        var nextCursor = hasMore ? CursorPagination.Encode(offset + pageSize) : null;

        return new ConceptPageResponse(
            [.. page.Select(c => new ConceptSummaryResponse(c.Id, c.Name, c.Description))],
            nextCursor);
    }

    private static async Task<Results<Ok<ConceptDetailResponse>, NotFound>> GetAsync(
        Guid id, CatalogDbContext db, CancellationToken cancellationToken)
    {
        var concept = await db.ConceptPages.FirstOrDefaultAsync(c => c.Id == id, cancellationToken);
        if (concept is null)
        {
            return TypedResults.NotFound();
        }

        // Only Approved variants are shown publicly — Proposed/Rejected are
        // curator-moderation working state (FR-021), not guest-visible content.
        // RecipeName is resolved via a same-schema join (Recipe lives in this
        // same Catalog module, unlike RecipeIngredientLine's cross-module
        // IngredientId) so the client can render a link, not a raw GUID.
        //
        // T196 visibility-filter sweep: no "attach my recipe as a concept
        // variant" endpoint exists yet (FR-021's "users MAY attach their
        // published variant" is unbuilt), so nothing can create an
        // Approved ConceptVariantLink against a private recipe today — but
        // this join had no defensive Visibility check of its own, unlike
        // every other guest-facing surface. Added now so the day that
        // attach-variant endpoint lands, this concept page can't leak a
        // private recipe's name through an approved-but-unpublished link.
        var variants = await db.ConceptVariantLinks
            .Where(v => v.ConceptId == id && v.State == ConceptVariantState.Approved)
            .Join(
                db.Recipes.Where(r => r.Visibility == ContentVisibility.Public),
                v => v.RecipeId,
                r => r.Id,
                (v, r) => new ConceptVariantResponse(v.RecipeId, r.PrimaryName, v.DifferentiatorText))
            .ToListAsync(cancellationToken);

        return TypedResults.Ok(new ConceptDetailResponse(concept.Id, concept.Name, concept.Description, variants));
    }
}

public sealed record ConceptPageResponse(IReadOnlyList<ConceptSummaryResponse> Items, string? NextCursor);

public sealed record ConceptSummaryResponse(Guid Id, string Name, string Description);

public sealed record ConceptVariantResponse(Guid RecipeId, string RecipeName, string DifferentiatorText);

public sealed record ConceptDetailResponse(Guid Id, string Name, string Description, IReadOnlyList<ConceptVariantResponse> Variants);
