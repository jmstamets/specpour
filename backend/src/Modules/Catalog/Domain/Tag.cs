namespace SpecPour.Modules.Catalog.Domain;

/// <summary>
/// data-model.md free-form multi-valued filterable Tags (FR-019/FR-050) — a
/// first-class, deduplicated vocabulary (ADR-0001) rather than raw text, so
/// "recipes with this tag" is a real query and near-duplicate free text
/// ("tiki" vs "Tiki") doesn't fragment the facet. <see cref="Key"/> is the
/// normalized (lowercase, trimmed) form used for uniqueness/lookup;
/// <see cref="DisplayText"/> preserves the curator's original casing.
/// </summary>
public sealed class Tag
{
    public required Guid Id { get; init; }

    public required string Key { get; init; }

    public required string DisplayText { get; set; }
}
