using System.Diagnostics;
using Microsoft.AspNetCore.Http;
using SpecPour.BuildingBlocks.Identifiers;

namespace SpecPour.BuildingBlocks.Http;

/// <summary>
/// First middleware in the pipeline (T014): honors an inbound X-Correlation-Id header
/// or mints a new UUIDv7, stores it on <see cref="HttpContext.Items"/> for
/// ProblemDetails/logging to read, echoes it on the response, and tags the current
/// OTel activity so traces/logs/responses all carry the same ID.
/// </summary>
public sealed class CorrelationIdMiddleware(RequestDelegate next)
{
    private readonly RequestDelegate _next = next;
    private static readonly UuidV7Generator IdGenerator = new();

    public async Task InvokeAsync(HttpContext context)
    {
        var correlationId = context.Request.Headers.TryGetValue(CorrelationId.HeaderName, out var incoming)
            && !string.IsNullOrWhiteSpace(incoming)
            ? incoming.ToString()
            : IdGenerator.NewId().ToString();

        context.Items[CorrelationId.HttpContextItemKey] = correlationId;
        context.Response.Headers[CorrelationId.HeaderName] = correlationId;
        Activity.Current?.SetTag("correlation_id", correlationId);

        await _next(context);
    }
}
