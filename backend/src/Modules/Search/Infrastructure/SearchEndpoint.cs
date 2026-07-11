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
        string? q, string? cursor, int? limit, ISearchPort searchPort, CancellationToken cancellationToken)
    {
        var pageSize = Math.Clamp(limit ?? DefaultLimit, 1, 100);

        var page = await searchPort.SearchAsync(
            new SearchQuery(q, new Dictionary<string, IReadOnlyList<string>>(), cursor, pageSize),
            cancellationToken);

        return new SearchResponse(
            [.. page.Items.Select(i => new SearchResultResponse(i.EntityType, i.EntityId, i.Title, i.Snippet, i.Score))],
            page.NextCursor);
    }
}

public sealed record SearchResponse(IReadOnlyList<SearchResultResponse> Items, string? NextCursor);

public sealed record SearchResultResponse(string EntityType, Guid EntityId, string Title, string? Snippet, double Score);
