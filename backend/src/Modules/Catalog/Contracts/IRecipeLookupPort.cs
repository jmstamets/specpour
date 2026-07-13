namespace SpecPour.Modules.Catalog.Contracts;

/// <summary>
/// Cross-module read port (constitution Principle III) letting other modules
/// resolve recipe IDs to display names — Ingredients needs it to render a
/// house-made ingredient's "defined by recipe" reference as a name, not a raw
/// GUID (FR-017). Same Contracts-only, batch-resolving shape as
/// <c>Ingredients.IIngredientLookupPort</c> and <c>Equipment.IEquipmentLookupPort</c>.
/// </summary>
public interface IRecipeLookupPort
{
    /// <summary>
    /// Resolves a batch of recipe IDs to (id, primary name) pairs in one round
    /// trip. IDs not found are simply absent from the result rather than an error.
    /// </summary>
    Task<IReadOnlyDictionary<Guid, string>> GetNamesAsync(
        IReadOnlyCollection<Guid> recipeIds, CancellationToken cancellationToken);

    /// <summary>
    /// T155/FR-014a/FR-050: resolves the (public) recipe IDs whose ingredient lines
    /// reference any of <paramref name="ingredientIds"/> — the join Ingredients
    /// needs for the hierarchy-aware "uses:&lt;ingredient&gt;" facet and the
    /// ingredient-&gt;recipes bidirectional surface, without a cross-schema join
    /// (constitution Principle III). Pass an already-expanded descendant-ID set
    /// (see <c>IIngredientLookupPort.GetDescendantIdsAsync</c>) for hierarchy-aware matching.
    /// </summary>
    Task<IReadOnlyList<Guid>> GetRecipeIdsUsingIngredientsAsync(
        IReadOnlyCollection<Guid> ingredientIds, CancellationToken cancellationToken);
}
