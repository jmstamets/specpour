namespace SpecPour.Modules.Catalog.Domain;

/// <summary>Recipe &lt;-&gt; Category join (ADR-0001) — Category is multi-valued on Recipe (FR-019).</summary>
public sealed class RecipeCategory
{
    public required Guid RecipeId { get; init; }

    public required Guid CategoryId { get; init; }
}
