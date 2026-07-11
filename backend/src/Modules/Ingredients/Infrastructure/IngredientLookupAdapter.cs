using Microsoft.EntityFrameworkCore;
using SpecPour.Modules.Ingredients.Contracts;

namespace SpecPour.Modules.Ingredients.Infrastructure;

/// <summary>T036's implementation of the cross-module ingredient lookup port.</summary>
public sealed class IngredientLookupAdapter(IngredientsDbContext db) : IIngredientLookupPort
{
    public async Task<IReadOnlyDictionary<Guid, IngredientSummary>> GetSummariesAsync(
        IReadOnlyCollection<Guid> ingredientIds, CancellationToken cancellationToken)
    {
        if (ingredientIds.Count == 0)
        {
            return new Dictionary<Guid, IngredientSummary>();
        }

        var ingredients = await db.Ingredients
            .Where(i => ingredientIds.Contains(i.Id))
            .Select(i => new { i.Id, i.Name, i.AbvPercent })
            .ToListAsync(cancellationToken);

        var allergensByIngredient = await db.IngredientAllergens
            .Where(a => ingredientIds.Contains(a.IngredientId))
            .Join(db.Allergens, a => a.AllergenId, al => al.Id, (a, al) => new { a.IngredientId, al.Key })
            .ToListAsync(cancellationToken);

        return ingredients.ToDictionary(
            i => i.Id,
            i => new IngredientSummary(
                i.Id,
                i.Name,
                i.AbvPercent,
                allergensByIngredient.Where(a => a.IngredientId == i.Id).Select(a => a.Key).ToList()));
    }
}
