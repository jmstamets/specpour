using Microsoft.AspNetCore.Http;
using Serilog.Core;
using Serilog.Events;
using SpecPour.BuildingBlocks.Http;

namespace SpecPour.Api.Observability;

/// <summary>
/// Pushes the current request's correlation ID (set by <see cref="CorrelationIdMiddleware"/>)
/// onto every Serilog event, so logs, traces, and API responses all carry the same ID
/// (R16).
/// </summary>
public sealed class CorrelationIdLogEnricher(IHttpContextAccessor httpContextAccessor) : ILogEventEnricher
{
    public void Enrich(LogEvent logEvent, ILogEventPropertyFactory propertyFactory)
    {
        var correlationId = httpContextAccessor.HttpContext?.Items[CorrelationId.HttpContextItemKey] as string;
        if (correlationId is null)
        {
            return;
        }

        logEvent.AddPropertyIfAbsent(propertyFactory.CreateProperty("CorrelationId", correlationId));
    }
}
