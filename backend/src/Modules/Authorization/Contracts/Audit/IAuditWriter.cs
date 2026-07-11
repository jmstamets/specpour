namespace SpecPour.Modules.Authorization.Contracts.Audit;

/// <summary>
/// The single audit port every module writes administrative actions through (R18a,
/// FR-065/SC-016). Cross-module reference by design: other modules depend on this
/// Contracts interface, never on Authorization's Domain/Infrastructure directly
/// (constitution Principle III). Entries are append-only — there is no update/delete
/// method on this port, and the underlying table rejects UPDATE/DELETE at the database
/// level regardless.
/// </summary>
public interface IAuditWriter
{
    Task WriteAsync(AuditEntry entry, CancellationToken cancellationToken);
}

/// <summary>
/// One audit action to record. <paramref name="BeforeStateJson"/>/<paramref name="AfterStateJson"/>
/// are optional pre-serialized JSON snapshots — callers own their own serialization so
/// this port stays free of per-module type dependencies.
/// </summary>
public sealed record AuditEntry(
    Guid ActorUserId,
    string ActionKey,
    string TargetEntityType,
    Guid TargetEntityId,
    string? BeforeStateJson = null,
    string? AfterStateJson = null);
