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
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Notifications.Infrastructure;

/// <summary>POST /api/v1/inbox/{id}/read (T151, contracts/openapi/paths/notifications.yaml).</summary>
public static class InboxReadEndpoint
{
    public static void Map(IEndpointRouteBuilder endpoints)
    {
        endpoints.MapApiV1Group().MapPost("/inbox/{id:guid}/read", HandleAsync)
            .RequireAuthorization(new AuthorizeAttribute
            {
                AuthenticationSchemes = OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme,
            });
    }

    private static async Task<Results<NoContent, ProblemHttpResult>> HandleAsync(
        Guid id,
        ClaimsPrincipal user,
        NotificationsDbContext db,
        IClock clock,
        CancellationToken cancellationToken)
    {
        var userId = Guid.Parse(user.GetClaim(Claims.Subject)!);
        var message = await db.InboxMessages
            .SingleOrDefaultAsync(m => m.Id == id && m.UserId == userId, cancellationToken);
        if (message is null)
        {
            // Unowned messages are indistinguishable from nonexistent ones (the
            // OpenAPI doc's own wording) — no enumeration signal either way.
            return TypedResults.Problem(title: "Message not found", statusCode: StatusCodes.Status404NotFound);
        }

        // Idempotent per the contract: marking an already-read message again must
        // not change the original readAt.
        message.ReadAt ??= clock.UtcNow;
        await db.SaveChangesAsync(cancellationToken);

        return TypedResults.NoContent();
    }
}
