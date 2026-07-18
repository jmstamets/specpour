using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using OpenIddict.Abstractions;
using OpenIddict.Validation.AspNetCore;
using SpecPour.BuildingBlocks.Http;
using SpecPour.BuildingBlocks.Identifiers;
using SpecPour.BuildingBlocks.Library;
using SpecPour.Modules.Venues.Contracts;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Equipment.Infrastructure.Endpoints;

/// <summary>
/// GET /api/v1/equipment, GET /api/v1/equipment/{id} (T037, FR-024). Guest-accessible
/// (FR-004b) — only <see cref="ContentVisibility.Public"/> equipment is returned to a
/// guest/non-owner.
///
/// POST/PUT/DELETE /api/v1/equipment (T060): bearer-only author CRUD, same
/// personal|bar library scoping and privacy model as recipes/ingredients (T058/T059).
/// </summary>
public static class EquipmentEndpoints
{
    private const int DefaultLimit = 20;

    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        var bearerOnly = new AuthorizeAttribute
        {
            AuthenticationSchemes = OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme,
        };

        group.MapGet("/equipment", ListAsync);
        group.MapGet("/equipment/{id:guid}", GetAsync);
        group.MapPost("/equipment", CreateAsync).RequireAuthorization(bearerOnly);
        group.MapPut("/equipment/{id:guid}", UpdateAsync).RequireAuthorization(bearerOnly);
        group.MapDelete("/equipment/{id:guid}", DeleteAsync).RequireAuthorization(bearerOnly);
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
        Guid id, ClaimsPrincipal user, EquipmentDbContext db, IVenueOwnershipPort venueOwnership, CancellationToken cancellationToken)
    {
        var equipment = await db.Equipment.FirstOrDefaultAsync(e => e.Id == id, cancellationToken);
        if (equipment is null)
        {
            return TypedResults.NotFound();
        }

        if (equipment.Visibility != ContentVisibility.Public && !await IsOwnerAsync(equipment, user, venueOwnership, cancellationToken))
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

    private static async Task<Results<Created<EquipmentAuthorResponse>, ProblemHttpResult>> CreateAsync(
        CreateEquipmentRequest request,
        ClaimsPrincipal user,
        EquipmentDbContext db,
        IUuidGenerator uuidGenerator,
        IVenueOwnershipPort venueOwnership,
        CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);

        if (!TryParseAuthorLibraryScope(request.LibraryScope, out var libraryScope))
        {
            return TypedResults.Problem(title: "Invalid libraryScope", detail: "libraryScope must be 'personal' or 'bar'.", statusCode: StatusCodes.Status400BadRequest);
        }

        OwnerType ownerType;
        Guid ownerId;
        if (libraryScope == LibraryScope.Bar)
        {
            if (request.VenueId is not { } venueId)
            {
                return TypedResults.Problem(title: "venueId required", detail: "A bar-scoped equipment item must reference a venueId.", statusCode: StatusCodes.Status400BadRequest);
            }

            if (!await venueOwnership.IsOwnedByAsync(venueId, userId, cancellationToken))
            {
                return TypedResults.Problem(title: "Not your venue", statusCode: StatusCodes.Status403Forbidden);
            }

            ownerType = OwnerType.Venue;
            ownerId = venueId;
        }
        else
        {
            ownerType = OwnerType.User;
            ownerId = userId;
        }

        var equipment = new Domain.Equipment
        {
            Id = uuidGenerator.NewId(),
            OwnerType = ownerType,
            OwnerId = ownerId,
            LibraryScope = libraryScope,
            Name = request.Name,
            Category = request.Category,
            Cost = request.Cost,
            Description = request.Description,
            UsageGuidance = request.UsageGuidance,
            TypicalApplications = request.TypicalApplications ?? [],

            // T060: authored content always starts private (FR-008b) — same
            // publish-is-a-distinct-flow reasoning as Recipe/Ingredient authoring.
            Visibility = ContentVisibility.Private,
        };

        db.Equipment.Add(equipment);
        await db.SaveChangesAsync(cancellationToken);

        return TypedResults.Created($"/api/v1/equipment/{equipment.Id}", ToAuthorResponse(equipment));
    }

    private static async Task<Results<Ok<EquipmentAuthorResponse>, NotFound>> UpdateAsync(
        Guid id, UpdateEquipmentRequest request, ClaimsPrincipal user, EquipmentDbContext db, IVenueOwnershipPort venueOwnership, CancellationToken cancellationToken)
    {
        var equipment = await db.Equipment.FirstOrDefaultAsync(e => e.Id == id, cancellationToken);
        if (equipment is null || !await IsOwnerAsync(equipment, user, venueOwnership, cancellationToken))
        {
            return TypedResults.NotFound();
        }

        equipment.Name = request.Name;
        equipment.Category = request.Category;
        equipment.Cost = request.Cost;
        equipment.Description = request.Description;
        equipment.UsageGuidance = request.UsageGuidance;
        equipment.TypicalApplications = request.TypicalApplications ?? [];

        await db.SaveChangesAsync(cancellationToken);
        return TypedResults.Ok(ToAuthorResponse(equipment));
    }

    private static async Task<Results<NoContent, NotFound>> DeleteAsync(
        Guid id, ClaimsPrincipal user, EquipmentDbContext db, IVenueOwnershipPort venueOwnership, CancellationToken cancellationToken)
    {
        var equipment = await db.Equipment.FirstOrDefaultAsync(e => e.Id == id, cancellationToken);
        if (equipment is null || !await IsOwnerAsync(equipment, user, venueOwnership, cancellationToken))
        {
            return TypedResults.NotFound();
        }

        db.Equipment.Remove(equipment);
        await db.SaveChangesAsync(cancellationToken);
        return TypedResults.NoContent();
    }

    private static async Task<bool> IsOwnerAsync(Domain.Equipment equipment, ClaimsPrincipal user, IVenueOwnershipPort venueOwnership, CancellationToken cancellationToken)
    {
        if (user.Identity?.IsAuthenticated != true)
        {
            return false;
        }

        var userId = CurrentUserId(user);
        return equipment.OwnerType switch
        {
            OwnerType.User => equipment.OwnerId == userId,
            OwnerType.Venue => equipment.OwnerId is { } venueId && await venueOwnership.IsOwnedByAsync(venueId, userId, cancellationToken),
            _ => false,
        };
    }

    private static bool TryParseAuthorLibraryScope(string value, out LibraryScope libraryScope)
    {
        if (string.Equals(value, "personal", StringComparison.OrdinalIgnoreCase))
        {
            libraryScope = LibraryScope.Personal;
            return true;
        }

        if (string.Equals(value, "bar", StringComparison.OrdinalIgnoreCase))
        {
            libraryScope = LibraryScope.Bar;
            return true;
        }

        libraryScope = default;
        return false;
    }

    private static EquipmentAuthorResponse ToAuthorResponse(Domain.Equipment equipment) => new(
        equipment.Id,
        equipment.Name,
        equipment.Category,
        equipment.LibraryScope.ToString().ToLowerInvariant(),
        equipment.OwnerType == OwnerType.Venue ? equipment.OwnerId : null,
        equipment.Cost,
        equipment.Description,
        equipment.UsageGuidance,
        equipment.TypicalApplications,
        equipment.Visibility.ToString().ToLowerInvariant());

    private static Guid CurrentUserId(ClaimsPrincipal user) => Guid.Parse(user.GetClaim(Claims.Subject)!);
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

public sealed record CreateEquipmentRequest(
    string Name,
    string Category,
    string LibraryScope,
    Guid? VenueId,
    decimal? Cost,
    string? Description,
    string? UsageGuidance,
    IReadOnlyList<string>? TypicalApplications);

public sealed record UpdateEquipmentRequest(
    string Name,
    string Category,
    decimal? Cost,
    string? Description,
    string? UsageGuidance,
    IReadOnlyList<string>? TypicalApplications);

public sealed record EquipmentAuthorResponse(
    Guid Id,
    string Name,
    string Category,
    string LibraryScope,
    Guid? VenueId,
    decimal? Cost,
    string? Description,
    string? UsageGuidance,
    IReadOnlyList<string> TypicalApplications,
    string Visibility);
