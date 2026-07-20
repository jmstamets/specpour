using SpecPour.BuildingBlocks.Library;

namespace SpecPour.Modules.Inventory.Domain;

/// <summary>
/// data-model.md InventoryItem (FR-029/FR-030): what a user or venue owns. Unlike
/// Recipe/Ingredient/Equipment, there is no <c>Visibility</c> field at all — inventory
/// has no public/curator variant, ever (owner-only from birth, Phase 6 entry guidance).
/// <see cref="OwnerType"/> is only ever <see cref="OwnerType.User"/> or
/// <see cref="OwnerType.Venue"/> — there is no curated/system inventory. Reuses the
/// same OwnerType shape as Recipe/Ingredient/Equipment/Venue-authored content
/// (ADR-0001) since FR-029's "users and venues" ownership axis is identical.
/// </summary>
public sealed class InventoryItem
{
    public required Guid Id { get; init; }

    public required OwnerType OwnerType { get; init; }

    public required Guid OwnerId { get; init; }

    /// <summary>Cross-module reference into the `ingredients` schema by ID only — no FK constraint (ADR-0001). Product or class level (FR-029).</summary>
    public required Guid IngredientId { get; set; }

    public decimal? Quantity { get; set; }

    public string? BottleSize { get; set; }

    public required InventorySource Source { get; init; }

    public required DateTimeOffset AddedAt { get; init; }
}
