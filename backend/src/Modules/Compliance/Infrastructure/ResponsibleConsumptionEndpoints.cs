using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Http;
using SpecPour.Modules.Compliance.Domain;

namespace SpecPour.Modules.Compliance.Infrastructure;

/// <summary>
/// GET /api/v1/compliance/messaging and /compliance/support-resources (T150,
/// FR-067/FR-069). Guest-accessible — responsible-consumption content is shown to
/// everyone, including anonymous visitors. Both resolve by jurisdiction with the
/// "default" strictest-rule-style fallback, mirroring the age-gate endpoint.
/// </summary>
public static class ResponsibleConsumptionEndpoints
{
    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        group.MapGet("/compliance/messaging", MessagingAsync);
        group.MapGet("/compliance/support-resources", SupportResourcesAsync);
    }

    private static async Task<ResponsibleConsumptionMessageResponse> MessagingAsync(
        string surface,
        string? jurisdiction,
        ComplianceDbContext db,
        CancellationToken cancellationToken)
    {
        var code = string.IsNullOrWhiteSpace(jurisdiction) ? ResponsibleConsumptionMessage.DefaultCode : jurisdiction;

        // Jurisdiction-specific row if present, else the default fallback for the
        // same surface class (FR-067's "never absent" guarantee).
        var message = await db.ResponsibleConsumptionMessages
                          .FirstOrDefaultAsync(m => m.SurfaceClass == surface && m.JurisdictionCode == code, cancellationToken)
                      ?? await db.ResponsibleConsumptionMessages
                          .FirstOrDefaultAsync(m => m.SurfaceClass == surface && m.JurisdictionCode == ResponsibleConsumptionMessage.DefaultCode, cancellationToken)
                      ?? throw new InvalidOperationException($"No default ResponsibleConsumptionMessage seeded for surface '{surface}'.");

        return new ResponsibleConsumptionMessageResponse(
            message.SurfaceClass,
            message.JurisdictionCode,
            message.PlacementDescriptor,
            message.MessageContentKey);
    }

    private static async Task<SupportResourcesResponse> SupportResourcesAsync(
        string? jurisdiction,
        ComplianceDbContext db,
        CancellationToken cancellationToken)
    {
        var code = string.IsNullOrWhiteSpace(jurisdiction) ? ResponsibleConsumptionMessage.DefaultCode : jurisdiction;

        var resources = await db.SupportResources
            .Where(r => r.JurisdictionCode == code)
            .OrderBy(r => r.DisplayOrder)
            .ToListAsync(cancellationToken);

        // Fall back to the default set when the jurisdiction has no specific rows.
        if (resources.Count == 0)
        {
            resources = await db.SupportResources
                .Where(r => r.JurisdictionCode == ResponsibleConsumptionMessage.DefaultCode)
                .OrderBy(r => r.DisplayOrder)
                .ToListAsync(cancellationToken);
        }

        return new SupportResourcesResponse(
            [.. resources.Select(r => new SupportResourceResponse(r.ResourceName, r.Link, r.DisplayOrder))]);
    }
}

public sealed record ResponsibleConsumptionMessageResponse(string Surface, string JurisdictionCode, string Placement, string MessageContentKey);

public sealed record SupportResourceResponse(string Name, string Link, int DisplayOrder);

public sealed record SupportResourcesResponse(IReadOnlyList<SupportResourceResponse> Items);
