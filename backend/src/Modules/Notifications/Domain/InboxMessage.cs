namespace SpecPour.Modules.Notifications.Domain;

/// <summary>data-model.md InboxMessage: the always-on notification channel (FR-040a).</summary>
public sealed class InboxMessage
{
    public required Guid Id { get; init; }

    public required Guid UserId { get; init; }

    /// <summary>Typed notification key (e.g. "prep_expiry", "account_deactivation_warning").</summary>
    public required string Type { get; init; }

    /// <summary>Type-specific structured payload, serialized as JSON.</summary>
    public required string PayloadJson { get; init; }

    public required DateTimeOffset CreatedAt { get; init; }

    public DateTimeOffset? ReadAt { get; set; }
}
