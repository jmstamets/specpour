namespace SpecPour.Modules.Catalog.Domain;

/// <summary>
/// Recipe &lt;-&gt; Equipment(glassware) join (data-model.md "glassware_ids[] (≥1
/// acceptable)", FR-020). <see cref="EquipmentId"/> is a cross-module reference into
/// the `equipment` schema by ID only — no FK constraint, per constitution Principle
/// III (ADR-0001). The "≥1 acceptable" rule is enforced at the application layer,
/// not the database.
/// </summary>
public sealed class RecipeGlassware
{
    public required Guid RecipeId { get; init; }

    public required Guid EquipmentId { get; init; }
}
