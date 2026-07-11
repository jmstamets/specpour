using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Http;
using SpecPour.Modules.Compliance.Application.Ports;
using SpecPour.Modules.Compliance.Domain;

namespace SpecPour.Modules.Compliance.Infrastructure;

/// <summary>GET /api/v1/compliance/age-gate (contracts/openapi/paths/compliance.yaml, T020).</summary>
public static class AgeGateEndpoint
{
    public static void Map(IEndpointRouteBuilder endpoints)
    {
        endpoints.MapApiV1Group().MapGet("/compliance/age-gate", HandleAsync);
    }

    private static async Task<AgeGateResponse> HandleAsync(
        string surface,
        HttpContext httpContext,
        ComplianceDbContext db,
        IGeoIpPort geoIp,
        CancellationToken cancellationToken)
    {
        var strictness = await db.SurfaceGateConfigs
            .Where(c => c.SurfaceKey == surface)
            .Select(c => (GateStrictness?)c.Strictness)
            // No config for this surface -> fail safe to Mandatory rather than Off
            // (Principle XIII regulated-industry posture: unconfigured means gated).
            .FirstOrDefaultAsync(cancellationToken) ?? GateStrictness.Mandatory;

        var remoteIp = httpContext.Connection.RemoteIpAddress;
        var jurisdictionCode = remoteIp is not null
            ? await geoIp.ResolveJurisdictionAsync(remoteIp, cancellationToken)
            : null;

        var strictestRuleApplied = jurisdictionCode is null;
        var effectiveCode = jurisdictionCode ?? JurisdictionRule.DefaultCode;

        var rule = await db.JurisdictionRules.FindAsync([effectiveCode], cancellationToken)
            ?? await db.JurisdictionRules.FindAsync([JurisdictionRule.DefaultCode], cancellationToken)
            ?? throw new InvalidOperationException("No default JurisdictionRule row is seeded.");

        var appliedDefault = strictestRuleApplied || rule.JurisdictionCode == JurisdictionRule.DefaultCode;

        return new AgeGateResponse(
            strictness.ToString().ToLowerInvariant(),
            rule.JurisdictionCode,
            rule.LegalDrinkingAge,
            appliedDefault);
    }
}

public sealed record AgeGateResponse(string SurfaceStrictness, string JurisdictionCode, int LegalDrinkingAge, bool StrictestRuleApplied);
