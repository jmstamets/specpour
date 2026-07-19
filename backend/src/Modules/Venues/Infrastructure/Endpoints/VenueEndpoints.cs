using System.Security.Claims;
using NetTopologySuite.Geometries;
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
using SpecPour.BuildingBlocks.Time;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Venues.Infrastructure.Endpoints;

/// <summary>
/// CRUD /api/v1/venues (T061, contracts/api-v1-surface.md). Bearer-only, like every
/// other authoring surface — V1 has no separate "professional" gate on venue
/// CREATION itself (api-v1-surface.md's "user (pro)" note describes who venues are
/// FOR, not an enforced tier check this task was scoped to add; not invented here).
/// A venue is single-user-owned in V1 (FR-058) — every mutation is scoped to the
/// caller's own venues, never another user's.
/// </summary>
public static class VenueEndpoints
{
    private const int DefaultLimit = 20;

    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        var bearerOnly = new AuthorizeAttribute
        {
            AuthenticationSchemes = OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme,
        };

        group.MapGet("/venues", ListAsync).RequireAuthorization(bearerOnly);
        group.MapGet("/venues/{id:guid}", GetAsync).RequireAuthorization(bearerOnly);
        group.MapPost("/venues", CreateAsync).RequireAuthorization(bearerOnly);
        group.MapPut("/venues/{id:guid}", UpdateAsync).RequireAuthorization(bearerOnly);
        group.MapDelete("/venues/{id:guid}", DeleteAsync).RequireAuthorization(bearerOnly);
    }

    private static async Task<Ok<VenuePageResponse>> ListAsync(
        ClaimsPrincipal user, string? cursor, int? limit, VenuesDbContext db, CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        var pageSize = Math.Clamp(limit ?? DefaultLimit, 1, 100);
        var offset = CursorPagination.Decode(cursor);

        var items = await db.Venues
            .Where(v => v.OwnerUserId == userId)
            .OrderBy(v => v.Name)
            .Skip(offset)
            .Take(pageSize + 1)
            .ToListAsync(cancellationToken);

        var hasMore = items.Count > pageSize;
        var page = hasMore ? items[..pageSize] : items;
        var nextCursor = hasMore ? CursorPagination.Encode(offset + pageSize) : null;

        return TypedResults.Ok(new VenuePageResponse([.. page.Select(ToResponse)], nextCursor));
    }

    private static async Task<Results<Ok<VenueResponse>, NotFound>> GetAsync(
        Guid id, ClaimsPrincipal user, VenuesDbContext db, CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        var venue = await db.Venues.SingleOrDefaultAsync(v => v.Id == id && v.OwnerUserId == userId, cancellationToken);
        return venue is null ? TypedResults.NotFound() : TypedResults.Ok(ToResponse(venue));
    }

    private static async Task<Created<VenueResponse>> CreateAsync(
        CreateVenueRequest request,
        ClaimsPrincipal user,
        VenuesDbContext db,
        IUuidGenerator uuidGenerator,
        IClock clock,
        CancellationToken cancellationToken)
    {
        var venue = new Domain.Venue
        {
            Id = uuidGenerator.NewId(),
            OwnerUserId = CurrentUserId(user),
            Name = request.Name,
            Address = request.Address,
            Location = request.Latitude is { } lat && request.Longitude is { } lon
                ? new Point(lon, lat) { SRID = 4326 }
                : null,
            ExternalReferences = request.ExternalReferences ?? [],
            CreatedAt = clock.UtcNow,
        };

        db.Venues.Add(venue);
        await db.SaveChangesAsync(cancellationToken);

        return TypedResults.Created($"/api/v1/venues/{venue.Id}", ToResponse(venue));
    }

    private static async Task<Results<Ok<VenueResponse>, NotFound>> UpdateAsync(
        Guid id, UpdateVenueRequest request, ClaimsPrincipal user, VenuesDbContext db, CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        var venue = await db.Venues.SingleOrDefaultAsync(v => v.Id == id && v.OwnerUserId == userId, cancellationToken);
        if (venue is null)
        {
            return TypedResults.NotFound();
        }

        venue.Name = request.Name;
        venue.Address = request.Address;
        venue.Location = request.Latitude is { } lat && request.Longitude is { } lon
            ? new Point(lon, lat) { SRID = 4326 }
            : null;
        venue.ExternalReferences = request.ExternalReferences ?? [];

        await db.SaveChangesAsync(cancellationToken);
        return TypedResults.Ok(ToResponse(venue));
    }

    private static async Task<Results<NoContent, NotFound>> DeleteAsync(
        Guid id, ClaimsPrincipal user, VenuesDbContext db, CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        var venue = await db.Venues.SingleOrDefaultAsync(v => v.Id == id && v.OwnerUserId == userId, cancellationToken);
        if (venue is null)
        {
            return TypedResults.NotFound();
        }

        db.Venues.Remove(venue);
        await db.SaveChangesAsync(cancellationToken);
        return TypedResults.NoContent();
    }

    private static VenueResponse ToResponse(Domain.Venue venue) => new(
        venue.Id,
        venue.Name,
        venue.Address,
        venue.Location?.Y,
        venue.Location?.X,
        venue.ExternalReferences,
        venue.CreatedAt);

    private static Guid CurrentUserId(ClaimsPrincipal user) => Guid.Parse(user.GetClaim(Claims.Subject)!);
}

public sealed record CreateVenueRequest(string Name, string? Address, double? Latitude, double? Longitude, IReadOnlyList<string>? ExternalReferences);

public sealed record UpdateVenueRequest(string Name, string? Address, double? Latitude, double? Longitude, IReadOnlyList<string>? ExternalReferences);

public sealed record VenueResponse(
    Guid Id,
    string Name,
    string? Address,
    double? Latitude,
    double? Longitude,
    IReadOnlyList<string> ExternalReferences,
    DateTimeOffset CreatedAt);

public sealed record VenuePageResponse(IReadOnlyList<VenueResponse> Items, string? NextCursor);
