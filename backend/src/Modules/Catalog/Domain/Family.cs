namespace SpecPour.Modules.Catalog.Domain;

/// <summary>
/// data-model.md Family (curator-managed taxonomy, FR-019): single-valued, optional
/// on Recipe. Curator-extensible; Tiki is a tag, never a family.
/// </summary>
public sealed class Family
{
    public required Guid Id { get; init; }

    public required string NameKey { get; init; }

    public required string Definition { get; set; }

    /// <summary>Optional subtype parent — julep/smash under Cobbler, nog under Flip.</summary>
    public Guid? ParentFamilyId { get; set; }
}
