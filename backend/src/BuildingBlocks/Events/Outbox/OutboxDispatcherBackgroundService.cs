using System.Reflection;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace SpecPour.BuildingBlocks.Events.Outbox;

/// <summary>
/// Polls the shared outbox table for unprocessed messages and invokes every registered
/// <see cref="IDomainEventHandler{TEvent}"/> for each event's CLR type (resolved via
/// <see cref="IEventTypeCatalog"/>). A message with zero registered handlers is still
/// marked processed — modules land handlers incrementally as later phases wire up
/// cross-module subscriptions.
/// </summary>
public sealed partial class OutboxDispatcherBackgroundService(
    IServiceScopeFactory scopeFactory,
    IEventTypeCatalog eventTypeCatalog,
    IOptions<OutboxDispatcherOptions> options,
    ILogger<OutboxDispatcherBackgroundService> logger) : BackgroundService
{
    private static readonly MethodInfo HandleAsyncMethod =
        typeof(OutboxDispatcherBackgroundService).GetMethod(nameof(InvokeHandlerAsync), BindingFlags.NonPublic | BindingFlags.Static)!;

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var interval = options.Value.PollingInterval;

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await DispatchPendingAsync(stoppingToken);
            }
            catch (Exception ex) when (ex is not OperationCanceledException)
            {
                Log.DispatchCycleFailed(logger, ex);
            }

            try
            {
                await Task.Delay(interval, stoppingToken);
            }
            catch (OperationCanceledException)
            {
                // Shutting down.
            }
        }
    }

    private async Task DispatchPendingAsync(CancellationToken cancellationToken)
    {
        using var scope = scopeFactory.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<OutboxDbContext>();

        var pending = await db.OutboxMessages
            .Where(m => m.ProcessedAt == null)
            .OrderBy(m => m.OccurredAt)
            .Take(options.Value.BatchSize)
            .ToListAsync(cancellationToken);

        foreach (var message in pending)
        {
            await DispatchOneAsync(scope.ServiceProvider, message, cancellationToken);
        }

        if (pending.Count > 0)
        {
            await db.SaveChangesAsync(cancellationToken);
        }
    }

    private async Task DispatchOneAsync(IServiceProvider scopedProvider, OutboxMessage message, CancellationToken cancellationToken)
    {
        var eventType = eventTypeCatalog.Resolve(message.EventType);
        if (eventType is null)
        {
            // Not yet known to this process (e.g. a module that hasn't registered its
            // event types). Leave pending; a later deploy that knows the type will pick it up.
            Log.UnknownEventType(logger, message.EventType, message.Id);
            return;
        }

        try
        {
            var domainEvent = JsonSerializer.Deserialize(message.PayloadJson, eventType)
                ?? throw new InvalidOperationException($"Outbox payload for {message.Id} deserialized to null");

            var handlerInterface = typeof(IDomainEventHandler<>).MakeGenericType(eventType);
            var handlers = scopedProvider.GetServices(handlerInterface);

            foreach (var handler in handlers)
            {
                var task = (Task)HandleAsyncMethod
                    .MakeGenericMethod(eventType)
                    .Invoke(null, [handler!, domainEvent, cancellationToken])!;
                await task;
            }

            message.ProcessedAt = DateTimeOffset.UtcNow;
        }
        catch (Exception ex)
        {
            message.Attempts++;
            message.LastError = ex.Message;
            Log.DispatchFailed(logger, message.Id, message.EventType, ex);
        }
    }

    private static Task InvokeHandlerAsync<TEvent>(object handler, object domainEvent, CancellationToken cancellationToken)
        where TEvent : IDomainEvent =>
        ((IDomainEventHandler<TEvent>)handler).HandleAsync((TEvent)domainEvent, cancellationToken);

    private static partial class Log
    {
        [LoggerMessage(Level = LogLevel.Error, Message = "Outbox dispatch cycle failed")]
        public static partial void DispatchCycleFailed(ILogger logger, Exception exception);

        [LoggerMessage(Level = LogLevel.Warning, Message = "Unknown outbox event type {EventType}; leaving message {MessageId} pending")]
        public static partial void UnknownEventType(ILogger logger, string eventType, Guid messageId);

        [LoggerMessage(Level = LogLevel.Error, Message = "Failed to dispatch outbox message {MessageId} ({EventType})")]
        public static partial void DispatchFailed(ILogger logger, Guid messageId, string eventType, Exception exception);
    }
}
