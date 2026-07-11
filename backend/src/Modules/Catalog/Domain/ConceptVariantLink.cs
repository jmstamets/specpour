namespace SpecPour.Modules.Catalog.Domain;

/// <summary>
/// data-model.md ConceptVariantLink (FR-021): a recipe attached to a concept page,
/// with a short differentiator. Both sides are same-schema, so a real FK applies.
/// Referenced <see cref="RecipeId"/> must be public or core (application-layer rule,
/// not a DB constraint — private recipes cannot attach, FR-021).
/// </summary>
public sealed class ConceptVariantLink
{
    public required Guid Id { get; init; }

    public required Guid ConceptId { get; init; }

    public required Guid RecipeId { get; init; }

    public required string DifferentiatorText { get; set; }

    public required ConceptVariantState State { get; set; }
}
