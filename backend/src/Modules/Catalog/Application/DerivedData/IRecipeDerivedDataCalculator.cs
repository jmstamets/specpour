using SpecPour.Modules.Catalog.Domain;

namespace SpecPour.Modules.Catalog.Application.DerivedData;

/// <summary>T036/FR-022: computes a recipe's derived (never-stored) data from its ingredient lines.</summary>
public interface IRecipeDerivedDataCalculator
{
    Task<RecipeDerivedData> CalculateAsync(Recipe recipe, IReadOnlyList<RecipeIngredientLine> ingredientLines, CancellationToken cancellationToken);
}
