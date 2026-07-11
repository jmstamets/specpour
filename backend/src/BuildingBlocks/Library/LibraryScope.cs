namespace SpecPour.BuildingBlocks.Library;

/// <summary>
/// data-model.md's recurring "library scope (core|personal|bar)" shape, shared by
/// Recipe, Ingredient, and Equipment (ADR-0001) — distinct from <see cref="OwnerType"/>:
/// a venue-owned item is always Bar scope, but scope still needs its own value since
/// FR-050's "source" facet (core library / my library / public) filters on it directly.
/// </summary>
public enum LibraryScope
{
    Core,
    Personal,
    Bar,
}
