namespace SpecPour.Modules.Ingredients.Contracts;

/// <summary>
/// Cross-module read port (constitution Principle III) letting Catalog resolve the
/// ABV and allergen data it needs for a recipe's derived-data calculation (T036)
/// without depending on Ingredients' Domain/Infrastructure directly — the same
/// Contracts-only dependency shape as <c>Measurements.IMeasurementConversionService</c>.
/// </summary>
public interface IIngredientLookupPort
{
    /// <summary>
    /// Resolves a batch of ingredient IDs at once (rather than one call per
    /// ingredient line) so a recipe with N ingredient lines costs one round trip,
    /// not N. IDs not found (e.g. a private ingredient the caller can't see) are
    /// simply absent from the result rather than an error.
    /// </summary>
    Task<IReadOnlyDictionary<Guid, IngredientSummary>> GetSummariesAsync(
        IReadOnlyCollection<Guid> ingredientIds, CancellationToken cancellationToken);
}

/// <summary>
/// The subset of an ingredient's data other modules need. <see cref="AbvPercent"/>
/// is null for non-alcoholic ingredients (FR-022's ABV calculator treats that as
/// 0%, not an error). <see cref="AllergenKeys"/> is empty, never null, when the
/// ingredient carries no allergen attributes.
/// </summary>
public sealed record IngredientSummary(Guid Id, string Name, decimal? AbvPercent, IReadOnlyList<string> AllergenKeys);
