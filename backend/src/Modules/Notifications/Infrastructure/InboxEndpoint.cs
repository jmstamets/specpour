using System.Security.Claims;
using System.Text.Json;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using OpenIddict.Abstractions;
using OpenIddict.Validation.AspNetCore;
using SpecPour.BuildingBlocks.Http;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Notifications.Infrastructure;

/// <summary>GET /api/v1/inbox (contracts/openapi/paths/notifications.yaml, T023).</summary>
public static class InboxEndpoint
{
    private const int DefaultLimit = 20;

    public static void Map(IEndpointRouteBuilder endpoints)
    {
        // The default auth scheme is cookie (Identity module — backs the interactive
        // /connect/authorize step); bearer-token API endpoints must explicitly
        // require the OpenIddict validation scheme instead, or RequireAuthorization()
        // would silently check for a cookie no API caller ever sends.
        endpoints.MapApiV1Group().MapGet("/inbox", HandleAsync)
            .RequireAuthorization(new AuthorizeAttribute
            {
                AuthenticationSchemes = OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme,
            });
    }

    private static async Task<InboxPageResponse> HandleAsync(
        ClaimsPrincipal user,
        string? cursor,
        int? limit,
        NotificationsDbContext db,
        CancellationToken cancellationToken)
    {
        var userId = Guid.Parse(user.GetClaim(Claims.Subject)!);
        var pageSize = Math.Clamp(limit ?? DefaultLimit, 1, 100);
        var offset = DecodeCursor(cursor);

        var messages = await db.InboxMessages
            .Where(m => m.UserId == userId)
            .OrderByDescending(m => m.CreatedAt)
            .Skip(offset)
            .Take(pageSize + 1)
            .ToListAsync(cancellationToken);

        var hasMore = messages.Count > pageSize;
        var page = hasMore ? messages[..pageSize] : messages;
        var nextCursor = hasMore ? EncodeCursor(offset + pageSize) : null;

        return new InboxPageResponse(
            [.. page.Select(m => new InboxMessageResponse(
                m.Id,
                m.Type,
                JsonSerializer.Deserialize<JsonElement>(m.PayloadJson),
                m.CreatedAt,
                m.ReadAt))],
            nextCursor);
    }

    private static int DecodeCursor(string? cursor) =>
        string.IsNullOrEmpty(cursor) ? 0 : int.Parse(System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(cursor)), System.Globalization.CultureInfo.InvariantCulture);

    private static string EncodeCursor(int offset) =>
        Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(offset.ToString(System.Globalization.CultureInfo.InvariantCulture)));
}

public sealed record InboxPageResponse(IReadOnlyList<InboxMessageResponse> Items, string? NextCursor);

public sealed record InboxMessageResponse(Guid Id, string Type, JsonElement Payload, DateTimeOffset CreatedAt, DateTimeOffset? ReadAt);
