namespace SpecPour.Modules.Notifications.Domain;

/// <summary>data-model.md ChannelPreference — per-user, per-channel opt-in.</summary>
public sealed class ChannelPreference
{
    public required Guid UserId { get; init; }

    public required NotificationChannel Channel { get; init; }

    public required bool OptedIn { get; set; }

    public required DateTimeOffset UpdatedAt { get; set; }
}
