using SpecPour.Modules.Catalog.Domain;

namespace SpecPour.Modules.Catalog.Application.Search;

/// <summary>
/// T155/ADR-0002/amended FR-049: composes the text a recipe's SearchVector is
/// generated from. Pure and side-effect-free so it's independently testable —
/// callers (RecipeSearchDocumentRefresher) own fetching <paramref name="ingredientNames"/>
/// across the module boundary and persisting the result.
/// </summary>
public static class SearchDocumentComposer
{
    /// <summary>
    /// <paramref name="ingredientNames"/> are the names of the ingredients this
    /// recipe's lines reference, AT THE REFERENCED HIERARCHY LEVEL — i.e. exactly
    /// as resolved by <c>IIngredientLookupPort.GetSummariesAsync</c> for each
    /// line's own IngredientId, no ancestor/descendant walking (that's a query-time
    /// concern for the "uses:" facet, not a document-composition one).
    /// </summary>
    public static string Compose(Recipe recipe, IReadOnlyCollection<string> ingredientNames)
    {
        var parts = new List<string>(capacity: 4 + recipe.AlternateNames.Count + ingredientNames.Count + recipe.Garnishes.Count)
        {
            recipe.PrimaryName,
        };

        parts.AddRange(recipe.AlternateNames);
        parts.AddRange(ingredientNames);
        parts.AddRange(recipe.Garnishes);

        // data-model.md's Recipe has no separate "description" field — History and
        // Notes are the closest fit to FR-049's "description/history text", and both
        // are already public content (RecipeDetailResponse exposes both today).
        if (!string.IsNullOrWhiteSpace(recipe.History))
        {
            parts.Add(recipe.History);
        }

        if (!string.IsNullOrWhiteSpace(recipe.Notes))
        {
            parts.Add(recipe.Notes);
        }

        return string.Join(' ', parts.Where(p => !string.IsNullOrWhiteSpace(p)));
    }
}
