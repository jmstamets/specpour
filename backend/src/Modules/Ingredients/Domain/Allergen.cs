namespace SpecPour.Modules.Ingredients.Domain;

/// <summary>
/// data-model.md's allergen/dietary attribute vocabulary (FR-016: "egg, dairy, nuts,
/// sulfites, gluten, etc." — an open-ended list) — modeled as a curator-extensible
/// lookup, same pattern as <see cref="IngredientCategory"/>, rather than a fixed
/// enum, since new attributes can be added without a release. Named "Allergen"
/// rather than "AllergenAttribute" to avoid CA1711 (a type ending in "Attribute" is
/// conventionally reserved for a <see cref="System.Attribute"/> subclass).
/// </summary>
public sealed class Allergen
{
    public required Guid Id { get; init; }

    public required string Key { get; init; }

    public required string DisplayNameKey { get; set; }
}
