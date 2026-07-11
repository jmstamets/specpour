namespace SpecPour.Modules.Catalog.Domain;

/// <summary>data-model.md RecipeIngredientLine.scaling_rule (FR-033).</summary>
public enum IngredientScalingRule
{
    Linear,
    Stepwise,
    OmitInBatch,
    AddFreshAtService,
}
