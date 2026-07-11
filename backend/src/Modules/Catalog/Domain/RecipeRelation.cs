namespace SpecPour.Modules.Catalog.Domain;

/// <summary>
/// data-model.md RecipeRelation (FR-020): curated related-cocktail links. Both sides
/// are Recipe rows in this same schema, so this carries a real FK, unlike the
/// cross-schema join tables elsewhere in this module (ADR-0001).
/// </summary>
public sealed class RecipeRelation
{
    public required Guid RecipeId { get; init; }

    public required Guid RelatedRecipeId { get; init; }

    public required string Note { get; set; }
}
