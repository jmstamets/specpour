namespace SpecPour.Modules.Ingredients.Domain;

/// <summary>
/// data-model.md SubstitutionRule (FR-013): curated suitability notes between two
/// ingredients. Hierarchy-implied substitution (descendant satisfies ancestor) is
/// computed at read time, never stored.
/// </summary>
public sealed class SubstitutionRule
{
    public required Guid Id { get; init; }

    public required Guid FromIngredientId { get; init; }

    public required Guid ToIngredientId { get; init; }

    public required string SuitabilityNote { get; set; }
}
