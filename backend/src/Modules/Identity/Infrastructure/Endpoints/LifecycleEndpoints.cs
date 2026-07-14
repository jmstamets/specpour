using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using OpenIddict.Abstractions;
using OpenIddict.Validation.AspNetCore;
using SpecPour.BuildingBlocks.Events;
using SpecPour.BuildingBlocks.Http;
using SpecPour.BuildingBlocks.Time;
using SpecPour.Modules.Authorization.Contracts.Audit;
using SpecPour.Modules.Identity.Contracts.Events;
using SpecPour.Modules.Identity.Domain;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Identity.Infrastructure.Endpoints;

/// <summary>
/// POST /api/v1/me/deactivate, POST /api/v1/me/reactivate (T052, FR-003). Bearer-only.
/// Deactivation does not block sign-in (LoginAsync only rejects Deleted/Suspended) —
/// the user regains access via a normal password sign-in, lands with LifecycleState
/// still Deactivated, and calls reactivate explicitly. That keeps "the user can
/// reactivate any time within the period" a deliberate action rather than an implicit
/// side effect of a successful password check, while still requiring no support
/// intervention (FR-003/scenario 10's spirit).
/// </summary>
public static class LifecycleEndpoints
{
    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        var bearerOnly = new AuthorizeAttribute
        {
            AuthenticationSchemes = OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme,
        };

        group.MapPost("/me/deactivate", DeactivateAsync).RequireAuthorization(bearerOnly);
        group.MapPost("/me/reactivate", ReactivateAsync).RequireAuthorization(bearerOnly);
    }

    private static async Task<Results<NoContent, ProblemHttpResult>> DeactivateAsync(
        ClaimsPrincipal user,
        UserManager<ApplicationUser> userManager,
        IdentityDbContext db,
        IOpenIddictAuthorizationManager authorizationManager,
        IDomainEventDispatcher dispatcher,
        IAuditWriter auditWriter,
        IClock clock,
        CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        var account = await userManager.FindByIdAsync(userId.ToString())
            ?? throw new InvalidOperationException("The bearer token's subject no longer maps to a user account.");

        if (account.LifecycleState == UserLifecycleState.Deactivated)
        {
            return TypedResults.Problem(title: "Account already deactivated", statusCode: StatusCodes.Status400BadRequest);
        }

        var now = clock.UtcNow;
        account.LifecycleState = UserLifecycleState.Deactivated;
        account.DeactivatedAt = now;
        account.DeactivationWarningSentAt = null;

        dispatcher.Raise(new AccountDeactivated(userId, now));

        // Every device signed out immediately — same mechanism as T051's individual
        // session revocation, applied to every active session at once.
        var sessions = await db.SessionDevices
            .Where(s => s.UserId == userId && s.RevokedAt == null)
            .ToListAsync(cancellationToken);
        foreach (var session in sessions)
        {
            var authorization = await authorizationManager.FindByIdAsync(session.AuthorizationId, cancellationToken);
            if (authorization is not null)
            {
                await authorizationManager.TryRevokeAsync(authorization, cancellationToken);
            }

            session.RevokedAt = now;
        }

        await userManager.UpdateAsync(account);

        await auditWriter.WriteAsync(
            new AuditEntry(userId, "identity.account_deactivated", "User", userId),
            cancellationToken);

        return TypedResults.NoContent();
    }

    private static async Task<Results<NoContent, ProblemHttpResult>> ReactivateAsync(
        ClaimsPrincipal user,
        UserManager<ApplicationUser> userManager,
        IAuditWriter auditWriter,
        CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        var account = await userManager.FindByIdAsync(userId.ToString())
            ?? throw new InvalidOperationException("The bearer token's subject no longer maps to a user account.");

        if (account.LifecycleState != UserLifecycleState.Deactivated)
        {
            return TypedResults.Problem(title: "Account is not deactivated", statusCode: StatusCodes.Status400BadRequest);
        }

        account.LifecycleState = UserLifecycleState.Active;
        account.DeactivatedAt = null;
        account.DeactivationWarningSentAt = null;
        await userManager.UpdateAsync(account);

        await auditWriter.WriteAsync(
            new AuditEntry(userId, "identity.account_reactivated", "User", userId),
            cancellationToken);

        return TypedResults.NoContent();
    }

    private static Guid CurrentUserId(ClaimsPrincipal user) => Guid.Parse(user.GetClaim(Claims.Subject)!);
}
