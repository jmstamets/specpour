namespace SpecPour.Modules.Catalog.Domain;

/// <summary>Recipe &lt;-&gt; FlavorProfile join (ADR-0001) — multi-valued on Recipe (FR-020).</summary>
public sealed class RecipeFlavorProfile
{
    public required Guid RecipeId { get; init; }

    public required Guid FlavorProfileId { get; init; }
}
