namespace SpecPour.Modules.Ingredients.Domain;

/// <summary>data-model.md IngredientCategory (curator-extensible, FR-014).</summary>
public sealed class IngredientCategory
{
    public required Guid Id { get; init; }

    public required string NameKey { get; init; }

    public required string Definition { get; set; }
}
