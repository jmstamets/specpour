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

    // T155: in-memory BFS over the whole (Id, ParentId) table rather than a
    // recursive CTE — V1's ingredient count is small (tens to low hundreds), and
    // this avoids a raw-SQL recursive query for a same-schema, small-data walk.
    // Revisit with a recursive CTE if the ingredient table grows large enough for
    // this to matter.
    public async Task<IReadOnlyList<Guid>> GetDescendantIdsAsync(Guid ingredientId, CancellationToken cancellationToken)
    {
        var idsAndParents = await db.Ingredients
            .Select(i => new { i.Id, i.ParentId })
            .ToListAsync(cancellationToken);

        var childrenByParent = idsAndParents
            .Where(i => i.ParentId.HasValue)
            .GroupBy(i => i.ParentId!.Value)
            .ToDictionary(g => g.Key, g => g.Select(i => i.Id).ToList());

        var result = new List<Guid> { ingredientId };
        var queue = new Queue<Guid>();
        queue.Enqueue(ingredientId);

        while (queue.Count > 0)
        {
            var current = queue.Dequeue();
            if (!childrenByParent.TryGetValue(current, out var children))
            {
                continue;
            }

            foreach (var child in children)
            {
                result.Add(child);
                queue.Enqueue(child);
            }
        }

        return result;
    }

    public async Task<IReadOnlyList<SubstitutionCandidate>> GetSubstitutesForAsync(Guid requiredIngredientId, CancellationToken cancellationToken) =>
        await db.SubstitutionRules
            .Where(s => s.FromIngredientId == requiredIngredientId)
            .Select(s => new SubstitutionCandidate(s.ToIngredientId, s.SuitabilityNote))
            .ToListAsync(cancellationToken);
}
