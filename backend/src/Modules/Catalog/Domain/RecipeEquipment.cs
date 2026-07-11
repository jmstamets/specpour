namespace SpecPour.Modules.Catalog.Domain;

/// <summary>
/// Recipe &lt;-&gt; Equipment(required tools) join (data-model.md "equipment_ids[]",
/// FR-020). <see cref="EquipmentId"/> is a cross-module reference into the
/// `equipment` schema by ID only — no FK constraint, per constitution Principle III
/// (ADR-0001).
/// </summary>
public sealed class RecipeEquipment
{
    public required Guid RecipeId { get; init; }

    public required Guid EquipmentId { get; init; }
}
