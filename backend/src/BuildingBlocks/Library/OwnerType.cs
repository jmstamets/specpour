namespace SpecPour.BuildingBlocks.Library;

/// <summary>
/// data-model.md's recurring "owner (system=curated core | user_id | venue_id)"
/// shape, shared by Recipe, Ingredient, and Equipment (ADR-0001). The owning ID
/// lives in a separate nullable <c>OwnerId</c> property — null exactly when
/// <see cref="System"/>, since curated-core content has no individual owner.
/// </summary>
public enum OwnerType
{
    System,
    User,
    Venue,
}
