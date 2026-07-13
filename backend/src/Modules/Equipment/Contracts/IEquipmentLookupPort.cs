namespace SpecPour.Modules.Equipment.Contracts;

/// <summary>
/// Cross-module read port (constitution Principle III) letting other modules
/// resolve equipment IDs to display names — Catalog needs it to render a recipe's
/// glassware/required-equipment references as names, not raw GUIDs (FR-020). Same
/// Contracts-only, batch-resolving shape as <c>Ingredients.IIngredientLookupPort</c>.
/// </summary>
public interface IEquipmentLookupPort
{
    /// <summary>
    /// Resolves a batch of equipment IDs to (id, name) pairs in one round trip.
    /// IDs not found (private equipment the caller can't see, or deleted rows) are
    /// simply absent from the result rather than an error.
    /// </summary>
    Task<IReadOnlyDictionary<Guid, string>> GetNamesAsync(
        IReadOnlyCollection<Guid> equipmentIds, CancellationToken cancellationToken);
}
