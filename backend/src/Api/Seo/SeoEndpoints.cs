using System.Globalization;
using System.Net;
using System.Text;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Library;
using SpecPour.Modules.Catalog.Application.DerivedData;
using SpecPour.Modules.Catalog.Domain;
using SpecPour.Modules.Catalog.Infrastructure;
using SpecPour.Modules.Glossary.Infrastructure;
using SpecPour.Modules.Ingredients.Contracts;

namespace SpecPour.Api.Seo;

/// <summary>
/// T044 (FR-004b, R18): server-rendered lightweight HTML projections of public
/// content for crawlers/shareable links, served OUTSIDE the /api/v1 surface (plain
/// /pages/... URLs) as text/html. The Flutter web app remains the interactive
/// experience; these exist only so search engines and link unfurlers see real
/// content instead of an empty SPA shell.
///
/// Owned by the Api host (not a module) because it's a cross-module read
/// projection; it injects the modules' read services rather than duplicating their
/// query logic. Only public content is served — the same visibility filter the
/// module read endpoints apply.
///
/// URLs are keyed by entity ID today. Human-readable keyword slugs
/// (e.g. /pages/recipes/mai-tai) are better for SEO but need a stored, unique,
/// collision-handled slug column that interacts with recipe rename/edit (US3+);
/// deferred and tracked as T153 rather than built mid-MVP. ID URLs are still fully
/// crawlable and shareable, satisfying FR-004b's letter.
/// </summary>
public static class SeoEndpoints
{
    public static void MapSpecPourSeoPages(this Microsoft.AspNetCore.Builder.WebApplication app)
    {
        app.MapGet("/pages/recipes/{id:guid}", RecipePageAsync);
        app.MapGet("/pages/concepts/{id:guid}", ConceptPageAsync);
        app.MapGet("/pages/glossary/terms/{id:guid}", GlossaryTermPageAsync);
    }

    private static async Task<Results<ContentHttpResult, NotFound>> RecipePageAsync(
        Guid id,
        CatalogDbContext catalogDb,
        IRecipeDerivedDataCalculator calculator,
        IIngredientLookupPort ingredientLookup,
        CancellationToken cancellationToken)
    {
        var recipe = await catalogDb.Recipes.FirstOrDefaultAsync(r => r.Id == id && r.Visibility == ContentVisibility.Public, cancellationToken);
        if (recipe is null)
        {
            return TypedResults.NotFound();
        }

        var lines = await catalogDb.RecipeIngredientLines.Where(l => l.RecipeId == id).OrderBy(l => l.Position).ToListAsync(cancellationToken);
        var derived = await calculator.CalculateAsync(recipe, lines, cancellationToken);
        var ingredientSummaries = await ingredientLookup.GetSummariesAsync([.. lines.Select(l => l.IngredientId).Distinct()], cancellationToken);

        var body = new StringBuilder();
        body.Append("<ul>");
        foreach (var line in lines)
        {
            var name = ingredientSummaries.TryGetValue(line.IngredientId, out var s) ? s.Name : line.IngredientId.ToString();
            body.Append(CultureInfo.InvariantCulture, $"<li>{E(line.Quantity)} {E(line.Unit)} {E(name)}</li>");
        }

        body.Append("</ul>");

        body.Append(CultureInfo.InvariantCulture, $"<p>{E(derived.AbvPercent)}% ABV, {E(derived.StandardDrinks)} standard drinks per serving.</p>");
        if (derived.Allergens.Count > 0)
        {
            body.Append(CultureInfo.InvariantCulture, $"<p><strong>Contains:</strong> {E(string.Join(", ", derived.Allergens))}</p>");
        }

        if (recipe.Instructions.Count > 0)
        {
            body.Append("<ol>");
            foreach (var step in recipe.Instructions)
            {
                body.Append(CultureInfo.InvariantCulture, $"<li>{E(step)}</li>");
            }

            body.Append("</ol>");
        }

        if (!string.IsNullOrWhiteSpace(recipe.History))
        {
            body.Append(CultureInfo.InvariantCulture, $"<p>{E(recipe.History)}</p>");
        }

        var description = $"{recipe.PrimaryName} — {derived.AbvPercent}% ABV, {derived.StandardDrinks} standard drinks.";
        return TypedResults.Content(Page(recipe.PrimaryName, description, $"<h1>{E(recipe.PrimaryName)}</h1>{body}"), "text/html; charset=utf-8");
    }

    private static async Task<Results<ContentHttpResult, NotFound>> ConceptPageAsync(
        Guid id, CatalogDbContext catalogDb, CancellationToken cancellationToken)
    {
        var concept = await catalogDb.ConceptPages.FirstOrDefaultAsync(c => c.Id == id, cancellationToken);
        if (concept is null)
        {
            return TypedResults.NotFound();
        }

        var variants = await catalogDb.ConceptVariantLinks
            .Where(v => v.ConceptId == id && v.State == ConceptVariantState.Approved)
            .Join(catalogDb.Recipes, v => v.RecipeId, r => r.Id, (v, r) => new { r.Id, r.PrimaryName, v.DifferentiatorText })
            .ToListAsync(cancellationToken);

        var body = new StringBuilder(FormattableString.Invariant($"<p>{E(concept.Description)}</p><ul>"));
        foreach (var variant in variants)
        {
            body.Append(CultureInfo.InvariantCulture, $"<li><a href=\"/pages/recipes/{variant.Id}\">{E(variant.PrimaryName)}</a> — {E(variant.DifferentiatorText)}</li>");
        }

        body.Append("</ul>");

        return TypedResults.Content(Page(concept.Name, concept.Description, $"<h1>{E(concept.Name)}</h1>{body}"), "text/html; charset=utf-8");
    }

    private static async Task<Results<ContentHttpResult, NotFound>> GlossaryTermPageAsync(
        Guid id, GlossaryDbContext glossaryDb, CancellationToken cancellationToken)
    {
        var term = await glossaryDb.GlossaryTerms.FirstOrDefaultAsync(t => t.Id == id, cancellationToken);
        if (term is null)
        {
            return TypedResults.NotFound();
        }

        var body = new StringBuilder("<ol>");
        foreach (var definition in term.Definitions)
        {
            body.Append(CultureInfo.InvariantCulture, $"<li>{E(definition)}</li>");
        }

        body.Append("</ol>");

        var description = term.Definitions.Count > 0 ? term.Definitions[0] : term.Term;
        return TypedResults.Content(Page(term.Term, description, $"<h1>{E(term.Term)}</h1>{body}"), "text/html; charset=utf-8");
    }

    /// <summary>Wraps body content in a minimal crawlable HTML document with title + description + Open Graph tags.</summary>
    private static string Page(string title, string description, string bodyHtml) =>
        $"""
        <!doctype html>
        <html lang="en">
        <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>{E(title)} — SpecPour</title>
        <meta name="description" content="{E(description)}">
        <meta property="og:title" content="{E(title)}">
        <meta property="og:description" content="{E(description)}">
        <meta property="og:type" content="article">
        </head>
        <body>
        {bodyHtml}
        </body>
        </html>
        """;

    /// <summary>
    /// HTML-encodes any interpolated value — all content is curator/user text and
    /// must never be trusted raw in markup. Formats <see cref="IFormattable"/>
    /// values (decimals like quantity/ABV) with the invariant culture so the
    /// crawlable output is deterministic regardless of server locale.
    /// </summary>
    private static string E(object? value)
    {
        var text = value is IFormattable formattable
            ? formattable.ToString(null, CultureInfo.InvariantCulture)
            : value?.ToString() ?? string.Empty;
        return WebUtility.HtmlEncode(text);
    }
}
