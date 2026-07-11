namespace SpecPour.BuildingBlocks.Sync;

/// <summary>
/// One row in the offline-sync change log (data-model.md "Sync change log", R9).
/// Populated from <c>ContentChanged</c> domain events (T131); consumed by the pull-based
/// device sync protocol (T130), filtered by the device's offline profile tier and the
/// account's pinned collections. The table lives in its own schema (like outbox) because
/// it is BuildingBlocks-owned cross-cutting infrastructure, not any single module's data.
/// </summary>
public sealed class SyncChange
{
    /// <summary>Monotonic, gap-tolerant cursor — the sync protocol's pull-page bookmark.</summary>
    public long Cursor { get; init; }

    public required string EntityType { get; init; }

    public required Guid EntityId { get; init; }

    public required SyncChangeKind ChangeKind { get; init; }

    public required DateTimeOffset OccurredAt { get; init; }

    /// <summary>Sync protocol version this change was recorded under (handshake compatibility, R9).</summary>
    public required int SyncProtocolVersion { get; init; }
}

public enum SyncChangeKind
{
    Created,
    Updated,
    Deleted,
}
