namespace SpecPour.Modules.Catalog.Domain;

/// <summary>
/// data-model.md RecipeIngredientLine (FR-012/FR-015/FR-033). <see cref="IngredientId"/>
/// is a cross-module reference into the `ingredients` schema by ID only — no FK
/// constraint, per constitution Principle III (same pattern as
/// <c>Authorization.RoleGrant.UserId</c> crossing into `identity`; see ADR-0001).
/// </summary>
public sealed class RecipeIngredientLine
{
    public required Guid Id { get; init; }

    public required Guid RecipeId { get; init; }

    public required int Position { get; set; }

    public required Guid IngredientId { get; set; }

    public required decimal Quantity { get; set; }

    public required string Unit { get; set; }

    public string? Purpose { get; set; }

    public required IngredientScalingRule ScalingRule { get; set; }
}
