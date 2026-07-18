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
using SpecPour.BuildingBlocks.Time;
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

    /// <summary>ADR-0005 (T177): must match IdentityModule.cs's SetRefreshTokenLifetime —
    /// a session whose LastSeenAt is older than this has necessarily expired (OpenIddict's
    /// own sliding-refresh-token lifetime elapsed with no activity), so its refresh-token
    /// family is dead even though nothing explicitly revoked it.</summary>
    private static readonly TimeSpan RefreshTokenSlidingLifetime = TimeSpan.FromDays(14);

    private static async Task<Ok<SessionListResponse>> ListAsync(
        ClaimsPrincipal user,
        IdentityDbContext db,
        IOpenIddictTokenManager tokenManager,
        IClock clock,
        CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        // T188: which of these rows is the CALLER's own session. TokenEndpoints
        // stamps each SessionDevice with the OpenIddict authorization id at
        // issuance (GetAuthorizationId()); the caller's access token carries that
        // same id, so this is a reliable "this device" match. Powers both the
        // sign-out-current-session flow (the client revokes this id via the
        // existing DELETE path) and T189's "This device" list indicator.
        var currentAuthorizationId = user.GetAuthorizationId();
        // T167 root cause: LastSeenAt alone is not a unique sort key — two
        // sessions created close enough together (the same clock tick; in the
        // acceptance suite, TestClock doesn't advance between two rapid token
        // exchanges, so both get the IDENTICAL timestamp) leaves ties with no
        // deterministic order, and Postgres's own tie-break for equal ORDER BY
        // values is unspecified — it can vary run to run. Id is a second,
        // always-unique key that makes the ordering fully deterministic
        // regardless of timestamp collisions, in both the real system and tests.
        var candidates = await db.SessionDevices
            .Where(s => s.UserId == userId && s.RevokedAt == null)
            .OrderByDescending(s => s.LastSeenAt)
            .ThenByDescending(s => s.Id)
            .ToListAsync(cancellationToken);

        // ADR-0005 (T177) orphan hygiene: a session must not render "active" just
        // because OUR OWN RevokedAt column is still null — that column only reflects
        // revocations WE explicitly performed (SessionsEndpoints.RevokeAsync's own
        // call, or the absolute-cap check in TokenEndpoints.HandleTokenAsync). Two
        // checks, neither trusting RevokedAt alone: (a) LastSeenAt older than the
        // sliding lifetime means the refresh-token family has necessarily expired
        // regardless of any revocation; (b) whether a live (Statuses.Valid) refresh
        // token still exists for the authorization. (b) is checked at the TOKEN level,
        // not the authorization level — confirmed empirically (two temporary
        // diagnostics, 2026-07-16, T167-precedent style) that (i) OpenIddict's
        // rolling-refresh-token reuse detection revokes the individual TOKENS on a
        // detected reuse but leaves the AUTHORIZATION's own status at "valid" (it's
        // the overarching grant record, not a token-lifecycle field) — checking
        // authorizationManager.GetStatusAsync would have missed every reuse-detection
        // revocation; and (ii) a token's stored Type is the full RFC 8693 URI
        // (`urn:ietf:params:oauth:token-type:refresh_token`), NOT the bare RFC 7009
        // token_type_hint string (`TokenTypeHints.RefreshToken` = "refresh_token") —
        // comparing against the wrong constant silently matched zero tokens and
        // filtered every session out.
        var live = new List<SessionDevice>(candidates.Count);
        foreach (var session in candidates)
        {
            if (clock.UtcNow - session.LastSeenAt > RefreshTokenSlidingLifetime)
            {
                continue;
            }

            // Standing rule (John, 2026-07-16, after the TokenTypeIdentifiers-vs-
            // TokenTypeHints mistake below): any filter against a provider-internal
            // string constant like this one MUST be guarded by a positive-match
            // acceptance test (a known-live session actually appears), not only a
            // negative one (a dead session is excluded) — the wrong constant silently
            // matches zero tokens, which a negative-only assertion can't distinguish
            // from correct filtering. See US02_Identity.feature scenario 18's
            // "the session is no longer active" step for the positive-match test.
            var hasValidRefreshToken = false;
            await foreach (var token in tokenManager.FindByAuthorizationIdAsync(session.AuthorizationId, cancellationToken))
            {
                if (await tokenManager.GetTypeAsync(token, cancellationToken) == TokenTypeIdentifiers.RefreshToken
                    && await tokenManager.GetStatusAsync(token, cancellationToken) == Statuses.Valid)
                {
                    hasValidRefreshToken = true;
                    break;
                }
            }

            if (!hasValidRefreshToken)
            {
                continue;
            }

            live.Add(session);
        }

        return TypedResults.Ok(new SessionListResponse(
            [.. live.Select(s => new SessionResponse(
                s.Id,
                s.DeviceDescription,
                s.CreatedAt,
                s.LastSeenAt,
                IsCurrent: s.AuthorizationId == currentAuthorizationId))]));
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

public sealed record SessionResponse(Guid Id, string DeviceDescription, DateTimeOffset CreatedAt, DateTimeOffset LastSeenAt, bool IsCurrent);

public sealed record SessionListResponse(IReadOnlyList<SessionResponse> Sessions);
