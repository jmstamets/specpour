using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using SpecPour.BuildingBlocks.Http;
using SpecPour.Modules.Authorization.Application.Ports;

namespace SpecPour.Modules.Authorization.Infrastructure;

/// <summary>GET /api/v1/me/entitlements (contracts/openapi/paths/authorization.yaml).</summary>
public static class EntitlementsEndpoint
{
    public static void Map(IEndpointRouteBuilder endpoints)
    {
        endpoints.MapApiV1Group().MapGet("/me/entitlements", HandleAsync);
    }

    private static async Task<EntitlementManifestResponse> HandleAsync(
        HttpContext httpContext,
        ICapabilityPolicy capabilityPolicy,
        CancellationToken cancellationToken)
    {
        var manifest = await capabilityPolicy.GetEntitlementManifestAsync(httpContext.User, cancellationToken);

        return new EntitlementManifestResponse(
            manifest.Tier,
            manifest.Capabilities,
            [.. manifest.Roles.Select(r => new RoleGrantSummaryResponse(r.RoleKey, r.ScopeType.ToString().ToLowerInvariant(), r.ScopeId))]);
    }
}

/// <summary>Wire shape matching the EntitlementManifest OpenAPI schema exactly (lowercase scopeType per the enum contract).</summary>
public sealed record EntitlementManifestResponse(string Tier, IReadOnlyList<string> Capabilities, IReadOnlyList<RoleGrantSummaryResponse> Roles);

public sealed record RoleGrantSummaryResponse(string RoleKey, string ScopeType, Guid? ScopeId);
