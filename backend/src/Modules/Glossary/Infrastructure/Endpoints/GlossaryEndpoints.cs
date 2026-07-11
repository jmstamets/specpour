using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Http;

namespace SpecPour.Modules.Glossary.Infrastructure.Endpoints;

/// <summary>
/// GET /api/v1/glossary/terms(+/{id}), GET /api/v1/glossary/articles(+/{id})
/// (T037, FR-025/FR-026). Guest-accessible (FR-004b) — the whole glossary is
/// curator-authored reference content with no owner/visibility axis, unlike
/// Recipe/Ingredient/Equipment.
/// </summary>
public static class GlossaryEndpoints
{
    private const int DefaultLimit = 20;

    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        group.MapGet("/glossary/terms", ListTermsAsync);
        group.MapGet("/glossary/terms/{id:guid}", GetTermAsync);
        group.MapGet("/glossary/articles", ListArticlesAsync);
        group.MapGet("/glossary/articles/{id:guid}", GetArticleAsync);
    }

    private static async Task<GlossaryTermPageResponse> ListTermsAsync(
        string? cursor, int? limit, GlossaryDbContext db, CancellationToken cancellationToken)
    {
        var pageSize = Math.Clamp(limit ?? DefaultLimit, 1, 100);
        var offset = CursorPagination.Decode(cursor);

        var terms = await db.GlossaryTerms
            .OrderBy(t => t.Term)
            .Skip(offset)
            .Take(pageSize + 1)
            .ToListAsync(cancellationToken);

        var hasMore = terms.Count > pageSize;
        var page = hasMore ? terms[..pageSize] : terms;
        var nextCursor = hasMore ? CursorPagination.Encode(offset + pageSize) : null;

        return new GlossaryTermPageResponse(
            [.. page.Select(t => new GlossaryTermSummaryResponse(t.Id, t.Term))],
            nextCursor);
    }

    private static async Task<Results<Ok<GlossaryTermDetailResponse>, NotFound>> GetTermAsync(
        Guid id, GlossaryDbContext db, CancellationToken cancellationToken)
    {
        var term = await db.GlossaryTerms.FirstOrDefaultAsync(t => t.Id == id, cancellationToken);
        if (term is null)
        {
            return TypedResults.NotFound();
        }

        return TypedResults.Ok(new GlossaryTermDetailResponse(term.Id, term.Term, term.Definitions));
    }

    private static async Task<GlossaryArticlePageResponse> ListArticlesAsync(
        string? cursor, int? limit, GlossaryDbContext db, CancellationToken cancellationToken)
    {
        var pageSize = Math.Clamp(limit ?? DefaultLimit, 1, 100);
        var offset = CursorPagination.Decode(cursor);

        var articles = await db.Articles
            .OrderBy(a => a.Title)
            .Skip(offset)
            .Take(pageSize + 1)
            .ToListAsync(cancellationToken);

        var hasMore = articles.Count > pageSize;
        var page = hasMore ? articles[..pageSize] : articles;
        var nextCursor = hasMore ? CursorPagination.Encode(offset + pageSize) : null;

        return new GlossaryArticlePageResponse(
            [.. page.Select(a => new GlossaryArticleSummaryResponse(a.Id, a.Title))],
            nextCursor);
    }

    private static async Task<Results<Ok<GlossaryArticleDetailResponse>, NotFound>> GetArticleAsync(
        Guid id, GlossaryDbContext db, CancellationToken cancellationToken)
    {
        var article = await db.Articles.FirstOrDefaultAsync(a => a.Id == id, cancellationToken);
        if (article is null)
        {
            return TypedResults.NotFound();
        }

        return TypedResults.Ok(new GlossaryArticleDetailResponse(article.Id, article.Title, article.Body));
    }
}

public sealed record GlossaryTermPageResponse(IReadOnlyList<GlossaryTermSummaryResponse> Items, string? NextCursor);

public sealed record GlossaryTermSummaryResponse(Guid Id, string Term);

public sealed record GlossaryTermDetailResponse(Guid Id, string Term, IReadOnlyList<string> Definitions);

public sealed record GlossaryArticlePageResponse(IReadOnlyList<GlossaryArticleSummaryResponse> Items, string? NextCursor);

public sealed record GlossaryArticleSummaryResponse(Guid Id, string Title);

public sealed record GlossaryArticleDetailResponse(Guid Id, string Title, string Body);
