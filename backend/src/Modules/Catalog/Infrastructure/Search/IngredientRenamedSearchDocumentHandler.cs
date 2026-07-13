using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Events;
using SpecPour.Modules.Ingredients.Contracts.Events;

namespace SpecPour.Modules.Catalog.Infrastructure.Search;

/// <summary>
/// T155/ADR-0002: Catalog's subscription to Ingredients' rename event — refreshes
/// the search document of every recipe referencing the renamed ingredient, so a
/// text search for the new name starts matching and the old name stops (after the
/// eventual-consistency window the ADR documents and John accepted).
/// </summary>
public sealed class IngredientRenamedSearchDocumentHandler(
    CatalogDbContext db,
    RecipeSearchDocumentRefresher refresher) : IDomainEventHandler<IngredientRenamed>
{
    public async Task HandleAsync(IngredientRenamed domainEvent, CancellationToken cancellationToken)
    {
        var recipeIds = await db.RecipeIngredientLines
            .Where(l => l.IngredientId == domainEvent.IngredientId)
            .Select(l => l.RecipeId)
            .Distinct()
            .ToListAsync(cancellationToken);

        foreach (var recipeId in recipeIds)
        {
            await refresher.RefreshAsync(recipeId, cancellationToken);
        }

        if (recipeIds.Count > 0)
        {
            await db.SaveChangesAsync(cancellationToken);
        }
    }
}
