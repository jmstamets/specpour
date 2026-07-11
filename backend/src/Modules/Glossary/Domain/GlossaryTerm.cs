namespace SpecPour.Modules.Glossary.Domain;

/// <summary>
/// data-model.md GlossaryTerm (FR-025): a term exists exactly once. Definitions are
/// ordered and numbered — array order IS the numbering (native Postgres text[],
/// ADR-0001), no separate ordinal column needed.
/// </summary>
public sealed class GlossaryTerm
{
    public required Guid Id { get; init; }

    public required string Term { get; set; }

    public IReadOnlyList<string> Definitions { get; set; } = [];
}
