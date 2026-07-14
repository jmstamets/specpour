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
using SpecPour.Modules.Notifications.Domain;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Notifications.Infrastructure;

/// <summary>
/// GET/PUT /api/v1/me/channels (T151, contracts/openapi/paths/notifications.yaml).
/// FR-040a: email is the V1 opt-in alert channel, push is modeled but has no
/// delivery until Phase 2 — both default to opted-out until the caller says
/// otherwise. GET lazily materializes a real (opted-out) row for any channel the
/// caller has never touched, so `updatedAt` is always a genuine persisted
/// timestamp rather than a fabricated one recomputed on every read.
/// </summary>
public static class ChannelPreferencesEndpoint
{
    private static readonly NotificationChannel[] AllChannels = Enum.GetValues<NotificationChannel>();

    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        var bearerOnly = new AuthorizeAttribute
        {
            AuthenticationSchemes = OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme,
        };

        group.MapGet("/me/channels", GetAsync).RequireAuthorization(bearerOnly);
        group.MapPut("/me/channels", UpdateAsync).RequireAuthorization(bearerOnly);
    }

    private static async Task<Ok<ChannelPreferencesResponse>> GetAsync(
        ClaimsPrincipal user, NotificationsDbContext db, IClock clock, CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        var preferences = await EnsureDefaultsAsync(userId, db, clock, cancellationToken);
        return TypedResults.Ok(ToResponse(preferences));
    }

    private static async Task<Results<Ok<ChannelPreferencesResponse>, ProblemHttpResult>> UpdateAsync(
        ChannelPreferencesUpdateRequest request,
        ClaimsPrincipal user,
        NotificationsDbContext db,
        IClock clock,
        CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        var preferences = await EnsureDefaultsAsync(userId, db, clock, cancellationToken);
        var byChannel = preferences.ToDictionary(p => p.Channel);

        foreach (var update in request.Channels)
        {
            if (!Enum.TryParse<NotificationChannel>(update.Channel, ignoreCase: true, out var channel)
                || !byChannel.TryGetValue(channel, out var preference))
            {
                return TypedResults.Problem(
                    title: "Unknown channel",
                    detail: $"'{update.Channel}' is not a recognized notification channel.",
                    statusCode: StatusCodes.Status400BadRequest);
            }

            preference.OptedIn = update.OptedIn;
            preference.UpdatedAt = clock.UtcNow;
        }

        await db.SaveChangesAsync(cancellationToken);
        return TypedResults.Ok(ToResponse(preferences));
    }

    private static async Task<List<ChannelPreference>> EnsureDefaultsAsync(
        Guid userId, NotificationsDbContext db, IClock clock, CancellationToken cancellationToken)
    {
        var existing = await db.ChannelPreferences
            .Where(p => p.UserId == userId)
            .ToListAsync(cancellationToken);

        var missing = AllChannels.Except(existing.Select(p => p.Channel));
        var created = false;
        foreach (var channel in missing)
        {
            var preference = new ChannelPreference
            {
                UserId = userId,
                Channel = channel,
                OptedIn = false,
                UpdatedAt = clock.UtcNow,
            };
            db.ChannelPreferences.Add(preference);
            existing.Add(preference);
            created = true;
        }

        if (created)
        {
            await db.SaveChangesAsync(cancellationToken);
        }

        return existing;
    }

    private static ChannelPreferencesResponse ToResponse(IReadOnlyList<ChannelPreference> preferences) =>
        new([.. preferences
            .OrderBy(p => p.Channel)
            .Select(p => new ChannelPreferenceResponse(p.Channel.ToString().ToLowerInvariant(), p.OptedIn, p.UpdatedAt))]);

    private static Guid CurrentUserId(ClaimsPrincipal user) => Guid.Parse(user.GetClaim(Claims.Subject)!);
}

public sealed record ChannelPreferencesResponse(IReadOnlyList<ChannelPreferenceResponse> Channels);

public sealed record ChannelPreferenceResponse(string Channel, bool OptedIn, DateTimeOffset UpdatedAt);

public sealed record ChannelPreferencesUpdateRequest(IReadOnlyList<ChannelPreferenceUpdate> Channels);

public sealed record ChannelPreferenceUpdate(string Channel, bool OptedIn);
