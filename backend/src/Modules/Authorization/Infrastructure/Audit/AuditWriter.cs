using SpecPour.Modules.Authorization.Contracts.Audit;
using SpecPour.Modules.Authorization.Domain.Audit;

namespace SpecPour.Modules.Authorization.Infrastructure.Audit;

public sealed class AuditWriter(AuthorizationDbContext db) : IAuditWriter
{
    public async Task WriteAsync(AuditEntry entry, CancellationToken cancellationToken)
    {
        db.AuditLogEntries.Add(new AuditLogEntry
        {
            Id = Guid.CreateVersion7(),
            ActorUserId = entry.ActorUserId,
            ActionKey = entry.ActionKey,
            TargetEntityType = entry.TargetEntityType,
            TargetEntityId = entry.TargetEntityId,
            OccurredAt = DateTimeOffset.UtcNow,
            BeforeStateJson = entry.BeforeStateJson,
            AfterStateJson = entry.AfterStateJson,
        });

        await db.SaveChangesAsync(cancellationToken);
    }
}
