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
using SpecPour.Modules.Identity.Domain;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Identity.Infrastructure.Endpoints;

/// <summary>
/// GET/DELETE /api/v1/me/sessions (T051, contracts/api-v1-surface.md). Bearer-only,
/// like every other /me/* endpoint. A "session" is data-model.md's SessionDevice —
/// one per OpenIddict authorization (see TokenEndpoints.HandleTokenAsync, which
/// creates/refreshes these rows on every token/refresh grant). Revoking one revokes
/// the underlying OpenIddict authorization directly (IOpenIddictAuthorizationManager),
/// which is what actually invalidates the whole refresh-token family — this entity
/// only carries the human-facing metadata OpenIddict's own tables don't.
/// </summary>
public static class SessionsEndpoints
{
    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        var bearerOnly = new AuthorizeAttribute
        {
            AuthenticationSchemes = OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme,
        };

        group.MapGet("/me/sessions", ListAsync).RequireAuthorization(bearerOnly);
        group.MapDelete("/me/sessions/{id:guid}", RevokeAsync).RequireAuthorization(bearerOnly);
    }

    private static async Task<Ok<SessionListResponse>> ListAsync(
        ClaimsPrincipal user, IdentityDbContext db, CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        // T167 root cause: LastSeenAt alone is not a unique sort key — two
        // sessions created close enough together (the same clock tick; in the
        // acceptance suite, TestClock doesn't advance between two rapid token
        // exchanges, so both get the IDENTICAL timestamp) leaves ties with no
        // deterministic order, and Postgres's own tie-break for equal ORDER BY
        // values is unspecified — it can vary run to run. Id is a second,
        // always-unique key that makes the ordering fully deterministic
        // regardless of timestamp collisions, in both the real system and tests.
        var sessions = await db.SessionDevices
            .Where(s => s.UserId == userId && s.RevokedAt == null)
            .OrderByDescending(s => s.LastSeenAt)
            .ThenByDescending(s => s.Id)
            .ToListAsync(cancellationToken);

        return TypedResults.Ok(new SessionListResponse(
            [.. sessions.Select(s => new SessionResponse(s.Id, s.DeviceDescription, s.CreatedAt, s.LastSeenAt))]));
    }

    private static async Task<Results<NoContent, ProblemHttpResult>> RevokeAsync(
        Guid id,
        ClaimsPrincipal user,
        IdentityDbContext db,
        IOpenIddictAuthorizationManager authorizationManager,
        CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        var session = await db.SessionDevices
            .SingleOrDefaultAsync(s => s.Id == id && s.UserId == userId && s.RevokedAt == null, cancellationToken);
        if (session is null)
        {
            return TypedResults.Problem(title: "Session not found", statusCode: StatusCodes.Status404NotFound);
        }

        var authorization = await authorizationManager.FindByIdAsync(session.AuthorizationId, cancellationToken);
        if (authorization is not null)
        {
            await authorizationManager.TryRevokeAsync(authorization, cancellationToken);
        }

        session.RevokedAt = DateTimeOffset.UtcNow;
        await db.SaveChangesAsync(cancellationToken);

        return TypedResults.NoContent();
    }

    private static Guid CurrentUserId(ClaimsPrincipal user) => Guid.Parse(user.GetClaim(Claims.Subject)!);
}

public sealed record SessionResponse(Guid Id, string DeviceDescription, DateTimeOffset CreatedAt, DateTimeOffset LastSeenAt);

public sealed record SessionListResponse(IReadOnlyList<SessionResponse> Sessions);
