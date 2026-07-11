using SpecPour.BuildingBlocks.Library;

namespace SpecPour.Modules.Equipment.Domain;

/// <summary>
/// data-model.md Equipment (FR-024). "type/category" is a plain curator/user-entered
/// string here (unlike Catalog's Family/Category), since FR-024 doesn't call for a
/// curator-managed taxonomy the way recipe taxonomy does — whether a given piece of
/// equipment is glassware vs. a tool lives entirely in which of Catalog's
/// RecipeGlassware/RecipeEquipment join tables a recipe links it through, not here.
/// Bidirectional links to recipes (via Catalog's join tables) and glossary articles
/// (via Glossary's content links) are owned by those modules, not this one.
/// </summary>
public sealed class Equipment
{
    public required Guid Id { get; init; }

    public required OwnerType OwnerType { get; init; }

    /// <summary>Null exactly when <see cref="OwnerType"/> is <see cref="OwnerType.System"/> (curated core).</summary>
    public Guid? OwnerId { get; init; }

    public required LibraryScope LibraryScope { get; set; }

    public required string Name { get; set; }

    public required string Category { get; set; }

    public decimal? Cost { get; set; }

    public string? Description { get; set; }

    public string? UsageGuidance { get; set; }

    /// <summary>Native Postgres text[] (ADR-0001).</summary>
    public IReadOnlyList<string> TypicalApplications { get; set; } = [];

    public required ContentVisibility Visibility { get; set; }
}
