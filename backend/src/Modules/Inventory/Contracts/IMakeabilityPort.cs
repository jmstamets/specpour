namespace SpecPour.Modules.Inventory.Contracts;

/// <summary>
/// Cross-module read port (constitution Principle III) exposing T067's makeability
/// computation to other modules — T148's `/recipes`+`/search` "makeable-from-
/// inventory" facet (FR-050) is the first consumer besides `GET /inventory/makeable`
/// itself. Both callers get the exact same computation; only the response shaping
/// (name resolution, field selection) differs per surface.
/// </summary>
public interface IMakeabilityPort
{
    Task<MakeabilityInfo> ComputeAsync(Guid userId, CancellationToken cancellationToken);
}

public sealed record MakeabilityLineInfo(
    Guid RequirementIngredientId,
    decimal RequirementQuantity,
    string RequirementUnit,
    string MatchQuality,
    Guid? SatisfiedByInventoryItemId,
    Guid? SatisfiedByIngredientId);

public sealed record MakeableRecipeInfo(Guid RecipeId, string RecipeName, string MatchQuality, IReadOnlyList<MakeabilityLineInfo> Lines);

public sealed record NearMissRecipeInfo(Guid RecipeId, string RecipeName, IReadOnlyList<MakeabilityLineInfo> Lines);

public sealed record MakeabilityInfo(IReadOnlyList<MakeableRecipeInfo> Makeable, IReadOnlyList<NearMissRecipeInfo> NearMiss);
