namespace SpecPour.Modules.Notifications.Domain;

/// <summary>
/// data-model.md ChannelPreference.channel. Email is V1's opt-in alert channel
/// (also carries identity transactional mail); push is modeled but delivery is
/// deferred to Phase 2 (FR-040a).
/// </summary>
public enum NotificationChannel
{
    Push,
    Email,
}
