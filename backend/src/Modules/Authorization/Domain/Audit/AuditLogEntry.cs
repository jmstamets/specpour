namespace SpecPour.Modules.Authorization.Domain.Audit;

/// <summary>
/// data-model.md AuditLogEntry: append-only (FR-065, SC-016). Written through
/// <see cref="Contracts.Audit.IAuditWriter"/> by every module's administrative
/// operations (curation, moderation, role grants, tier configuration, account
/// interventions, sensitive-PII decrypts per R6a) — never written to directly.
/// True immutability is enforced in the database itself (BEFORE UPDATE/DELETE
/// triggers in the InitialAuditLog migration), not just by convention.
/// </summary>
public sealed class AuditLogEntry
{
    public required Guid Id { get; init; }

    public required Guid ActorUserId { get; init; }

    /// <summary>Stable action key (e.g. "role_grant.create", "identity.dob.decrypt").</summary>
    public required string ActionKey { get; init; }

    public required string TargetEntityType { get; init; }

    public required Guid TargetEntityId { get; init; }

    public required DateTimeOffset OccurredAt { get; init; }

    /// <summary>Before-state snapshot (JSON), where applicable — null for create/read-style actions.</summary>
    public string? BeforeStateJson { get; init; }

    /// <summary>After-state snapshot (JSON), where applicable — null for delete/read-style actions.</summary>
    public string? AfterStateJson { get; init; }
}
