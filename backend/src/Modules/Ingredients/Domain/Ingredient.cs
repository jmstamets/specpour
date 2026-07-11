using SpecPour.BuildingBlocks.Library;

namespace SpecPour.Modules.Ingredients.Domain;

/// <summary>
/// data-model.md Ingredient (FR-012/FR-014/FR-016/FR-017). The house-made extension
/// (<see cref="DefiningRecipeId"/> onward) is a nullable 1:1 — present exactly when
/// this ingredient is defined by its own recipe rather than sourced.
/// <see cref="DefiningRecipeId"/> is a cross-module reference into the `catalog`
/// schema by ID only — no FK constraint, per constitution Principle III (ADR-0001).
/// Validation that the defining recipe doesn't transitively include this ingredient
/// itself (circular-reference rejection) is an application-layer rule, not a DB one.
/// </summary>
public sealed class Ingredient
{
    public required Guid Id { get; init; }

    public required OwnerType OwnerType { get; init; }

    /// <summary>Null exactly when <see cref="OwnerType"/> is <see cref="OwnerType.System"/> (curated core).</summary>
    public Guid? OwnerId { get; init; }

    public required LibraryScope LibraryScope { get; set; }

    public required string Name { get; set; }

    public required Guid CategoryId { get; set; }

    /// <summary>Hierarchy: class -&gt; ... -&gt; product (FR-012). Null at the root.</summary>
    public Guid? ParentId { get; set; }

    /// <summary>
    /// Percent alcohol by volume (0-100), added during T036: computing a recipe's
    /// ABV (FR-022) requires knowing each alcoholic ingredient's own strength, which
    /// data-model.md's Ingredient section didn't carry a field for. Null for
    /// non-alcoholic ingredients (citrus, syrups, bitters used in dash quantities,
    /// etc.) — treated as 0% by the calculator, not an error.
    /// </summary>
    public decimal? AbvPercent { get; set; }

    /// <summary>Native Postgres text[] (ADR-0001).</summary>
    public IReadOnlyList<string> Sources { get; set; } = [];

    public string? Description { get; set; }

    public required ContentVisibility Visibility { get; set; }

    public Guid? DefiningRecipeId { get; set; }

    public decimal? YieldQuantity { get; set; }

    public string? YieldUnit { get; set; }

    public TimeSpan? ShelfLife { get; set; }

    public string? StorageInstructions { get; set; }
}
