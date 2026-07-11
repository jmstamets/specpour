namespace SpecPour.Modules.Ingredients.Domain;

/// <summary>
/// data-model.md Ingredient &lt;-&gt; Allergen join, carrying the per-attribute
/// certainty (certain|uncertain) FR-055 requires (ADR-0001).
/// </summary>
public sealed class IngredientAllergen
{
    public required Guid IngredientId { get; init; }

    public required Guid AllergenId { get; init; }

    public required AllergenCertainty Certainty { get; set; }
}
