using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing;

namespace SpecPour.BuildingBlocks.Http;

/// <summary>
/// The versioned business-API prefix (contracts/openapi/openapi.yaml's `servers.url`).
/// Modules use this for their OpenAPI-documented endpoints; infrastructure endpoints
/// that are conventionally unprefixed (health checks, OAuth's /connect/* per RFC
/// convention) map directly onto the host builder instead.
/// </summary>
public static class ApiV1RouteGroupExtensions
{
    public const string Prefix = "/api/v1";

    public static RouteGroupBuilder MapApiV1Group(this IEndpointRouteBuilder endpoints) => endpoints.MapGroup(Prefix);
}
