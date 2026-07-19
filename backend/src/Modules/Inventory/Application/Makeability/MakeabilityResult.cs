namespace SpecPour.Modules.Inventory.Application.Makeability;

/// <summary>
/// One recipe line's resolution against the caller's inventory (T067). Every line
/// carries its own match quality — statement §2's ladder, ratified 2026-07-19 to also
/// require this per-line detail rather than just a recipe-level summary (T064's
/// makeable/near-miss contract): "exact-product" | "class-satisfied" | "substitution"
/// | "missing". <see cref="SatisfiedByInventoryItemId"/>/<see cref="SatisfiedByIngredientId"/>
/// are both null exactly when <see cref="MatchQuality"/> is "missing".
/// </summary>
public sealed record RecipeLineMatch(
    Guid RequirementIngredientId,
    decimal RequirementQuantity,
    string RequirementUnit,
    string MatchQuality,
    Guid? SatisfiedByInventoryItemId,
    Guid? SatisfiedByIngredientId);

/// <summary>
/// A fully-makeable recipe (every line satisfied). <see cref="MatchQuality"/> is a
/// DERIVED SUMMARY of <see cref="Lines"/> — the loosest quality among them — never
/// independent truth (John's 2026-07-19 ratification).
/// </summary>
public sealed record MakeableRecipe(Guid RecipeId, string RecipeName, string MatchQuality, IReadOnlyList<RecipeLineMatch> Lines);

/// <summary>A recipe within the near-miss threshold (at least one missing line, but not too many).</summary>
public sealed record NearMissRecipe(Guid RecipeId, string RecipeName, IReadOnlyList<RecipeLineMatch> Lines);

public sealed record MakeabilityResult(IReadOnlyList<MakeableRecipe> Makeable, IReadOnlyList<NearMissRecipe> NearMiss);
