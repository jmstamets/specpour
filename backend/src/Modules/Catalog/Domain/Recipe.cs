using SpecPour.BuildingBlocks.Library;
using SpecPour.Modules.Measurements.Contracts;

namespace SpecPour.Modules.Catalog.Domain;

/// <summary>
/// data-model.md Recipe (FR-018/FR-019/FR-020). Derived data (ABV, standard drinks,
/// allergen roll-up, per-serving cost) is deliberately never stored here — it's
/// computed at read time (T036/T037) from <see cref="RecipeIngredientLine"/> plus
/// whatever the referenced ingredients say, never persisted as truth.
/// </summary>
public sealed class Recipe
{
    /// <summary>
    /// The preparation method, added during T036: R14's dilution-percentage
    /// convention table is keyed by method (stirred/shaken/built), and FR-022
    /// requires ABV to "account for the preparation method's dilution assumptions"
    /// — there is no ABV calculation without knowing this. Referencing
    /// Measurements.Contracts' enum directly (not duplicating it in Catalog) since
    /// it's a pure value type, not a schema-owned entity — the same
    /// Contracts-only cross-module dependency shape as everywhere else
    /// (constitution Principle III), just at the Domain layer instead of
    /// Infrastructure.
    /// </summary>
    public required MixMethod Method { get; set; }

    public required Guid Id { get; init; }

    public required OwnerType OwnerType { get; init; }

    /// <summary>Null exactly when <see cref="OwnerType"/> is <see cref="OwnerType.System"/> (curated core).</summary>
    public Guid? OwnerId { get; init; }

    public required LibraryScope LibraryScope { get; set; }

    public required string PrimaryName { get; set; }

    /// <summary>Native Postgres text[] (ADR-0001) — all searchable alongside <see cref="PrimaryName"/> (FR-018).</summary>
    public IReadOnlyList<string> AlternateNames { get; set; } = [];

    /// <summary>Single-valued, optional (FR-019). Same-schema FK to <see cref="Family"/>.</summary>
    public Guid? FamilyId { get; set; }

    /// <summary>Ordered step-by-step instructions (FR-020) — array order IS the step order.</summary>
    public IReadOnlyList<string> Instructions { get; set; } = [];

    public IReadOnlyList<string> Garnishes { get; set; } = [];

    public required string IceSpec { get; set; }

    public string? CreatorAttribution { get; set; }

    public string? History { get; set; }

    public string? Notes { get; set; }

    /// <summary>Reversible private &lt;-&gt; public toggle (FR-008b).</summary>
    public required ContentVisibility Visibility { get; set; }

    public required DateTimeOffset CreatedAt { get; init; }

    public required DateTimeOffset UpdatedAt { get; set; }
}
