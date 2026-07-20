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
using SpecPour.BuildingBlocks.Time;
using SpecPour.Modules.Ingredients.Contracts;
using SpecPour.Modules.Inventory.Domain;
using SpecPour.Modules.Venues.Contracts;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Inventory.Infrastructure.Endpoints;

/// <summary>
/// CRUD /api/v1/inventory/items (T066, FR-029/FR-030). Bearer-only — inventory has no
/// public/curator variant at all, ever (Phase 6 entry guidance: owner-only from birth,
/// the most private data surface in the platform). Every read/write is scoped to the
/// caller's own items — their personal inventory, or a venue's inventory the caller
/// owns (verified via <see cref="IVenueOwnershipPort"/>, same pattern as Catalog's
/// bar-scoped recipe authoring) — strictly 404, never 403, on any other caller's item
/// (no existence disclosure, same reasoning as RecipeEndpoints' private-recipe 404).
/// </summary>
public static class InventoryItemEndpoints
{
    private const int DefaultLimit = 20;

    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        var bearerOnly = new AuthorizeAttribute
        {
            AuthenticationSchemes = OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme,
        };

        group.MapGet("/inventory/items", ListAsync).RequireAuthorization(bearerOnly);
        group.MapGet("/inventory/items/{id:guid}", GetAsync).RequireAuthorization(bearerOnly);
        group.MapPost("/inventory/items", CreateAsync).RequireAuthorization(bearerOnly);
        group.MapPut("/inventory/items/{id:guid}", UpdateAsync).RequireAuthorization(bearerOnly);
        group.MapDelete("/inventory/items/{id:guid}", DeleteAsync).RequireAuthorization(bearerOnly);
    }

    private static async Task<Results<Ok<InventoryItemPageResponse>, ProblemHttpResult>> ListAsync(
        ClaimsPrincipal user,
        Guid? venueId,
        string? cursor,
        int? limit,
        InventoryDbContext db,
        IIngredientLookupPort ingredientLookup,
        IVenueOwnershipPort venueOwnership,
        CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        IQueryable<InventoryItem> query;
        if (venueId is { } id)
        {
            if (!await venueOwnership.IsOwnedByAsync(id, userId, cancellationToken))
            {
                return TypedResults.Problem(title: "Not your venue", statusCode: StatusCodes.Status403Forbidden);
            }

            query = db.InventoryItems.Where(i => i.OwnerType == OwnerType.Venue && i.OwnerId == id);
        }
        else
        {
            query = db.InventoryItems.Where(i => i.OwnerType == OwnerType.User && i.OwnerId == userId);
        }

        var pageSize = Math.Clamp(limit ?? DefaultLimit, 1, 100);
        var offset = CursorPagination.Decode(cursor);

        var items = await query.OrderBy(i => i.AddedAt).Skip(offset).Take(pageSize + 1).ToListAsync(cancellationToken);
        var hasMore = items.Count > pageSize;
        var page = hasMore ? items[..pageSize] : items;
        var nextCursor = hasMore ? CursorPagination.Encode(offset + pageSize) : null;

        var response = await ToResponsesAsync(page, ingredientLookup, cancellationToken);
        return TypedResults.Ok(new InventoryItemPageResponse(response, nextCursor));
    }

    private static async Task<Results<Ok<InventoryItemResponse>, NotFound>> GetAsync(
        Guid id, ClaimsPrincipal user, InventoryDbContext db, IIngredientLookupPort ingredientLookup, IVenueOwnershipPort venueOwnership, CancellationToken cancellationToken)
    {
        var item = await FindOwnedItemAsync(id, user, db, venueOwnership, cancellationToken);
        if (item is null)
        {
            return TypedResults.NotFound();
        }

        var response = (await ToResponsesAsync([item], ingredientLookup, cancellationToken))[0];
        return TypedResults.Ok(response);
    }

    private static async Task<Results<Created<InventoryItemResponse>, ProblemHttpResult>> CreateAsync(
        CreateInventoryItemRequest request,
        ClaimsPrincipal user,
        InventoryDbContext db,
        IUuidGenerator uuidGenerator,
        IClock clock,
        IIngredientLookupPort ingredientLookup,
        IVenueOwnershipPort venueOwnership,
        CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);

        if (!TryParseSource(request.Source, out var source))
        {
            return TypedResults.Problem(title: "Invalid source", detail: "source must be one of: photo-recognition, barcode, manual, prep.", statusCode: StatusCodes.Status400BadRequest);
        }

        var summaries = await ingredientLookup.GetSummariesAsync([request.IngredientId], cancellationToken);
        if (!summaries.ContainsKey(request.IngredientId))
        {
            return TypedResults.Problem(title: "Unknown ingredient", detail: $"No such ingredient: {request.IngredientId}.", statusCode: StatusCodes.Status400BadRequest);
        }

        OwnerType ownerType;
        Guid ownerId;
        if (request.VenueId is { } venueId)
        {
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

        var item = new InventoryItem
        {
            Id = uuidGenerator.NewId(),
            OwnerType = ownerType,
            OwnerId = ownerId,
            IngredientId = request.IngredientId,
            Quantity = request.Quantity,
            BottleSize = request.BottleSize,
            Source = source,
            AddedAt = clock.UtcNow,
        };

        db.InventoryItems.Add(item);
        await db.SaveChangesAsync(cancellationToken);

        var response = (await ToResponsesAsync([item], ingredientLookup, cancellationToken))[0];
        return TypedResults.Created($"/api/v1/inventory/items/{item.Id}", response);
    }

    private static async Task<Results<Ok<InventoryItemResponse>, NotFound>> UpdateAsync(
        Guid id, UpdateInventoryItemRequest request, ClaimsPrincipal user, InventoryDbContext db, IIngredientLookupPort ingredientLookup, IVenueOwnershipPort venueOwnership, CancellationToken cancellationToken)
    {
        var item = await FindOwnedItemAsync(id, user, db, venueOwnership, cancellationToken);
        if (item is null)
        {
            return TypedResults.NotFound();
        }

        item.Quantity = request.Quantity;
        item.BottleSize = request.BottleSize;

        await db.SaveChangesAsync(cancellationToken);
        var response = (await ToResponsesAsync([item], ingredientLookup, cancellationToken))[0];
        return TypedResults.Ok(response);
    }

    private static async Task<Results<NoContent, NotFound>> DeleteAsync(
        Guid id, ClaimsPrincipal user, InventoryDbContext db, IVenueOwnershipPort venueOwnership, CancellationToken cancellationToken)
    {
        var item = await FindOwnedItemAsync(id, user, db, venueOwnership, cancellationToken);
        if (item is null)
        {
            return TypedResults.NotFound();
        }

        db.InventoryItems.Remove(item);
        await db.SaveChangesAsync(cancellationToken);
        return TypedResults.NoContent();
    }

    /// <summary>Ownership spans two shapes (personal or one of the caller's venues) — strictly 404 for anyone else's item, never 403 (no existence disclosure).</summary>
    private static async Task<InventoryItem?> FindOwnedItemAsync(
        Guid id, ClaimsPrincipal user, InventoryDbContext db, IVenueOwnershipPort venueOwnership, CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        var ownedVenueIds = await venueOwnership.GetOwnedVenueIdsAsync(userId, cancellationToken);

        return await db.InventoryItems.SingleOrDefaultAsync(
            i => i.Id == id &&
                ((i.OwnerType == OwnerType.User && i.OwnerId == userId) ||
                 (i.OwnerType == OwnerType.Venue && ownedVenueIds.Contains(i.OwnerId))),
            cancellationToken);
    }

    private static async Task<IReadOnlyList<InventoryItemResponse>> ToResponsesAsync(
        IReadOnlyList<InventoryItem> items, IIngredientLookupPort ingredientLookup, CancellationToken cancellationToken)
    {
        var summaries = await ingredientLookup.GetSummariesAsync([.. items.Select(i => i.IngredientId).Distinct()], cancellationToken);
        return [.. items.Select(i => new InventoryItemResponse(
            i.Id,
            i.IngredientId,
            summaries.TryGetValue(i.IngredientId, out var summary) ? summary.Name : null,
            i.Quantity,
            i.BottleSize,
            ToWireString(i.Source),
            i.AddedAt))];
    }

    private static bool TryParseSource(string value, out InventorySource source)
    {
        switch (value)
        {
            case "photo-recognition": source = InventorySource.PhotoRecognition; return true;
            case "barcode": source = InventorySource.Barcode; return true;
            case "manual": source = InventorySource.Manual; return true;
            case "prep": source = InventorySource.Prep; return true;
            default: source = default; return false;
        }
    }

    private static string ToWireString(InventorySource source) => source switch
    {
        InventorySource.PhotoRecognition => "photo-recognition",
        InventorySource.Barcode => "barcode",
        InventorySource.Manual => "manual",
        InventorySource.Prep => "prep",
        _ => throw new ArgumentOutOfRangeException(nameof(source)),
    };

    private static Guid CurrentUserId(ClaimsPrincipal user) => Guid.Parse(user.GetClaim(Claims.Subject)!);
}

public sealed record CreateInventoryItemRequest(Guid IngredientId, Guid? VenueId, decimal? Quantity, string? BottleSize, string Source);

public sealed record UpdateInventoryItemRequest(decimal? Quantity, string? BottleSize);

public sealed record InventoryItemResponse(
    Guid Id, Guid IngredientId, string? IngredientName, decimal? Quantity, string? BottleSize, string Source, DateTimeOffset AddedAt);

public sealed record InventoryItemPageResponse(IReadOnlyList<InventoryItemResponse> Items, string? NextCursor);
