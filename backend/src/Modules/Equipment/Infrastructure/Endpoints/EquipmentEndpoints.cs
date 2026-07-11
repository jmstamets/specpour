using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Http;
using SpecPour.BuildingBlocks.Library;

namespace SpecPour.Modules.Equipment.Infrastructure.Endpoints;

/// <summary>GET /api/v1/equipment, GET /api/v1/equipment/{id} (T037, FR-024). Guest-accessible (FR-004b).</summary>
public static class EquipmentEndpoints
{
    private const int DefaultLimit = 20;

    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        group.MapGet("/equipment", ListAsync);
        group.MapGet("/equipment/{id:guid}", GetAsync);
    }

    private static async Task<EquipmentPageResponse> ListAsync(
        string? cursor, int? limit, EquipmentDbContext db, CancellationToken cancellationToken)
    {
        var pageSize = Math.Clamp(limit ?? DefaultLimit, 1, 100);
        var offset = CursorPagination.Decode(cursor);

        var items = await db.Equipment
            .Where(e => e.Visibility == ContentVisibility.Public)
            .OrderBy(e => e.Name)
            .Skip(offset)
            .Take(pageSize + 1)
            .ToListAsync(cancellationToken);

        var hasMore = items.Count > pageSize;
        var page = hasMore ? items[..pageSize] : items;
        var nextCursor = hasMore ? CursorPagination.Encode(offset + pageSize) : null;

        return new EquipmentPageResponse(
            [.. page.Select(e => new EquipmentSummaryResponse(e.Id, e.Name, e.Category))],
            nextCursor);
    }

    private static async Task<Results<Ok<EquipmentDetailResponse>, NotFound>> GetAsync(
        Guid id, EquipmentDbContext db, CancellationToken cancellationToken)
    {
        var equipment = await db.Equipment.FirstOrDefaultAsync(e => e.Id == id && e.Visibility == ContentVisibility.Public, cancellationToken);
        if (equipment is null)
        {
            return TypedResults.NotFound();
        }

        return TypedResults.Ok(new EquipmentDetailResponse(
            equipment.Id,
            equipment.Name,
            equipment.Category,
            equipment.Cost,
            equipment.Description,
            equipment.UsageGuidance,
            equipment.TypicalApplications));
    }
}

public sealed record EquipmentPageResponse(IReadOnlyList<EquipmentSummaryResponse> Items, string? NextCursor);

public sealed record EquipmentSummaryResponse(Guid Id, string Name, string Category);

public sealed record EquipmentDetailResponse(
    Guid Id,
    string Name,
    string Category,
    decimal? Cost,
    string? Description,
    string? UsageGuidance,
    IReadOnlyList<string> TypicalApplications);
