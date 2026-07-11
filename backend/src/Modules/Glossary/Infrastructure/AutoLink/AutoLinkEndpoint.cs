using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing;
using SpecPour.BuildingBlocks.Http;
using SpecPour.Modules.Glossary.Application.AutoLink;

namespace SpecPour.Modules.Glossary.Infrastructure.AutoLink;

/// <summary>
/// GET /api/v1/glossary/autolink (T039, contracts/openapi/paths/glossary.yaml).
/// api-v1-surface.md documents this as "?context=…" (abbreviated, same convention
/// as e.g. "/sync/changes?cursor=…" eliding its own additional params) — the
/// content to resolve links against is supplied by the caller as a query param
/// too, since this computes links over arbitrary caller-supplied text rather than
/// requiring a server-side context-to-content-body lookup registry that doesn't
/// exist anywhere else in this codebase.
/// </summary>
public static class AutoLinkEndpoint
{
    public static void Map(IEndpointRouteBuilder endpoints) =>
        endpoints.MapApiV1Group().MapGet("/glossary/autolink", HandleAsync);

    private static async Task<AutoLinkResponse> HandleAsync(
        string context, string content, IGlossaryAutoLinkService autoLinkService, CancellationToken cancellationToken)
    {
        var matches = await autoLinkService.ResolveLinksAsync(context, content, cancellationToken);

        return new AutoLinkResponse([.. matches.Select(m => new AutoLinkMatchResponse(m.Start, m.Length, m.TermId, m.Term))]);
    }
}

public sealed record AutoLinkResponse(IReadOnlyList<AutoLinkMatchResponse> Matches);

public sealed record AutoLinkMatchResponse(int Start, int Length, Guid TermId, string Term);
