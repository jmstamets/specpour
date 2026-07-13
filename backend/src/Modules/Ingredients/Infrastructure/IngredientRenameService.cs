using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Events;
using SpecPour.Modules.Ingredients.Contracts.Events;

namespace SpecPour.Modules.Ingredients.Infrastructure;

/// <summary>
/// T155: the minimal rename capability needed to exercise the event-maintained
/// search-document refresh (ADR-0002's rider — rename an ingredient, assert
/// dependent recipes become searchable under the new name). Deliberately not
/// exposed over HTTP here — a public ingredient-editing endpoint (PUT
/// /ingredients/{id}) is curator/authoring-story scope, not T155's; this is the
/// core a future endpoint would call, built now because the rename mechanism
/// itself is required to prove the refresh pipeline works.
/// </summary>
public sealed class IngredientRenameService(IngredientsDbContext db, IDomainEventDispatcher dispatcher)
{
    public async Task RenameAsync(Guid ingredientId, string newName, CancellationToken cancellationToken)
    {
        var ingredient = await db.Ingredients.FirstOrDefaultAsync(i => i.Id == ingredientId, cancellationToken)
            ?? throw new InvalidOperationException($"Ingredient {ingredientId} not found.");

        var oldName = ingredient.Name;
        if (string.Equals(oldName, newName, StringComparison.Ordinal))
        {
            return;
        }

        ingredient.Name = newName;
        dispatcher.Raise(new IngredientRenamed(ingredientId, oldName, newName));

        await db.SaveChangesAsync(cancellationToken);
    }
}
