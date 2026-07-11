namespace SpecPour.Modules.Catalog.Domain;

/// <summary>data-model.md ConceptPage (FR-021): curator-owned, e.g. "Daiquiri".</summary>
public sealed class ConceptPage
{
    public required Guid Id { get; init; }

    public required string Name { get; set; }

    public required string Description { get; set; }
}
