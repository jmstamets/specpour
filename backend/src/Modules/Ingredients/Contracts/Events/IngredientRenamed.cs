using SpecPour.BuildingBlocks.Events;

namespace SpecPour.Modules.Ingredients.Contracts.Events;

/// <summary>
/// Published when an ingredient's <c>Name</c> changes (T155/ADR-0002). Catalog
/// subscribes to refresh the search document of every recipe referencing this
/// ingredient — the event-maintained alternative to a cross-schema generated
/// column (constitution Principle III).
/// </summary>
public sealed record IngredientRenamed(Guid IngredientId, string OldName, string NewName) : DomainEvent;
