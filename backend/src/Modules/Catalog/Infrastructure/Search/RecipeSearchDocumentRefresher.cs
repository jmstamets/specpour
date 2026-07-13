using Microsoft.EntityFrameworkCore;
using SpecPour.Modules.Catalog.Application.Search;
using SpecPour.Modules.Ingredients.Contracts;

namespace SpecPour.Modules.Catalog.Infrastructure.Search;

/// <summary>
/// T155/ADR-0002: orchestrates SearchDocumentComposer against real data — resolves
/// a recipe's ingredient lines' names via the cross-module lookup port, composes
/// the document, and stages the change on the tracked <see cref="Domain.Recipe"/>
/// entity. Callers own <c>SaveChangesAsync</c> so multiple refreshes (e.g. every
/// recipe referencing a just-renamed ingredient) can batch into one transaction.
/// </summary>
public sealed class RecipeSearchDocumentRefresher(CatalogDbContext db, IIngredientLookupPort ingredientLookup)
{
    public async Task RefreshAsync(Guid recipeId, CancellationToken cancellationToken)
    {
        var recipe = await db.Recipes.FirstOrDefaultAsync(r => r.Id == recipeId, cancellationToken);
        if (recipe is null)
        {
            return;
        }

        var lines = await db.RecipeIngredientLines.Where(l => l.RecipeId == recipeId).ToListAsync(cancellationToken);
        var summaries = await ingredientLookup.GetSummariesAsync(
            [.. lines.Select(l => l.IngredientId).Distinct()], cancellationToken);

        var ingredientNames = lines
            .Select(l => summaries.TryGetValue(l.IngredientId, out var summary) ? summary.Name : null)
            .Where(name => name is not null)
            .Cast<string>()
            .ToList();

        recipe.SearchDocumentText = SearchDocumentComposer.Compose(recipe, ingredientNames);
    }

    /// <summary>
    /// T155 rider: idempotent, re-runnable backfill for every existing recipe —
    /// events only cover changes going forward, so rows written before this feature
    /// shipped (or a database seeded before it) need this to get a correct document.
    /// Safe to call any number of times; always recomputes from current data.
    /// </summary>
    public async Task RefreshAllAsync(CancellationToken cancellationToken)
    {
        var recipeIds = await db.Recipes.Select(r => r.Id).ToListAsync(cancellationToken);
        foreach (var recipeId in recipeIds)
        {
            await RefreshAsync(recipeId, cancellationToken);
        }
    }
}
