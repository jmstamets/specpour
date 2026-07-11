namespace SpecPour.BuildingBlocks.Http;

/// <summary>Shared constants for correlation-ID propagation (client → API → module boundaries, R16).</summary>
public static class CorrelationId
{
    public const string HeaderName = "X-Correlation-Id";
    public const string HttpContextItemKey = "CorrelationId";
}
