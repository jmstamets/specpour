using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Http;
using SpecPour.Modules.Compliance.Contracts;
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
        ILegalDrinkingAgePort legalDrinkingAge,
        CancellationToken cancellationToken)
    {
        var strictness = await db.SurfaceGateConfigs
            .Where(c => c.SurfaceKey == surface)
            .Select(c => (GateStrictness?)c.Strictness)
            // No config for this surface -> fail safe to Mandatory rather than Off
            // (Principle XIII regulated-industry posture: unconfigured means gated).
            .FirstOrDefaultAsync(cancellationToken) ?? GateStrictness.Mandatory;

        // T155-pattern contract sweep: jurisdiction resolution moved to
        // ILegalDrinkingAgePort so Identity's registration endpoint (T047) can reuse
        // the identical logic — this handler's own behavior is unchanged.
        var rule = await legalDrinkingAge.ResolveFromIpAsync(httpContext.Connection.RemoteIpAddress, cancellationToken);

        return new AgeGateResponse(
            strictness.ToString().ToLowerInvariant(),
            rule.JurisdictionCode,
            rule.LegalDrinkingAge,
            rule.StrictestRuleApplied);
    }
}

public sealed record AgeGateResponse(string SurfaceStrictness, string JurisdictionCode, int LegalDrinkingAge, bool StrictestRuleApplied);
