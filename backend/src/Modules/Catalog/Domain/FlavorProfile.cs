namespace SpecPour.Modules.Catalog.Domain;

/// <summary>
/// Curator-managed flavor descriptor vocabulary (FR-020's "multi-valued flavor
/// profile descriptors", a facet in FR-050) — modeled as its own taxonomy lookup
/// alongside <see cref="Family"/>/<see cref="Category"/> rather than free text, since
/// it's a bounded, curator-controlled set the same way those are.
/// </summary>
public sealed class FlavorProfile
{
    public required Guid Id { get; init; }

    public required string NameKey { get; init; }

    public required string Definition { get; set; }
}
