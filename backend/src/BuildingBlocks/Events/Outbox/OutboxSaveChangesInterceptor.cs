using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;

namespace SpecPour.BuildingBlocks.Events.Outbox;

/// <summary>
/// Drains the current scope's <see cref="EventBuffer"/> into <see cref="OutboxMessage"/>
/// rows immediately before SaveChanges commits, so raising an event and persisting the
/// business-data change it describes are always atomic (R2 — no two-phase commit needed).
/// Register per module DbContext: <c>options.AddInterceptors(sp.GetRequiredService&lt;OutboxSaveChangesInterceptor&gt;())</c>.
/// </summary>
public sealed class OutboxSaveChangesInterceptor(EventBuffer eventBuffer, string sourceModule) : SaveChangesInterceptor
{
    private readonly EventBuffer _eventBuffer = eventBuffer;
    private readonly string _sourceModule = sourceModule;

    public override InterceptionResult<int> SavingChanges(DbContextEventData eventData, InterceptionResult<int> result)
    {
        EnqueueOutboxMessages(eventData.Context);
        return base.SavingChanges(eventData, result);
    }

    public override ValueTask<InterceptionResult<int>> SavingChangesAsync(
        DbContextEventData eventData,
        InterceptionResult<int> result,
        CancellationToken cancellationToken = default)
    {
        EnqueueOutboxMessages(eventData.Context);
        return base.SavingChangesAsync(eventData, result, cancellationToken);
    }

    private void EnqueueOutboxMessages(DbContext? context)
    {
        if (context is null)
        {
            return;
        }

        var pending = _eventBuffer.DrainPending();
        if (pending.Count == 0)
        {
            return;
        }

        foreach (var domainEvent in pending)
        {
            var eventType = domainEvent.GetType();
            context.Set<OutboxMessage>().Add(new OutboxMessage
            {
                Id = domainEvent.EventId,
                EventType = EventTypeName.For(eventType),
                PayloadJson = JsonSerializer.Serialize(domainEvent, eventType),
                OccurredAt = domainEvent.OccurredAt,
                SourceModule = _sourceModule,
            });
        }
    }
}
