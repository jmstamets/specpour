namespace SpecPour.Modules.Catalog.Domain;

/// <summary>Recipe &lt;-&gt; Tag join (ADR-0001) — free-form multi-valued Tags (FR-019/FR-050).</summary>
public sealed class RecipeTag
{
    public required Guid RecipeId { get; init; }

    public required Guid TagId { get; init; }
}
