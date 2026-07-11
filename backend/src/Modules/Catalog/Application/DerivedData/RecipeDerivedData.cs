namespace SpecPour.Modules.Catalog.Application.DerivedData;

/// <summary>
/// T036/FR-022: a recipe's calculated ABV, standard drinks, and rolled-up allergen
/// flags — never persisted (data-model.md), always computed at read time.
/// </summary>
public sealed record RecipeDerivedData(decimal AbvPercent, decimal StandardDrinks, IReadOnlyList<string> Allergens);
