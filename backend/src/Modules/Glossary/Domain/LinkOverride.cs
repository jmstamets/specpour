namespace SpecPour.Modules.Glossary.Domain;

/// <summary>
/// data-model.md LinkOverride (FR-027): curator override for the auto-link engine.
/// <see cref="Context"/> is the page/content ID being overridden — a free string
/// since the auto-linker (T039) runs over content living in several different
/// modules' schemas, not just one.
/// </summary>
public sealed class LinkOverride
{
    public required Guid Id { get; init; }

    public required string Context { get; init; }

    public required Guid TermId { get; init; }

    public required LinkOverrideAction Action { get; set; }
}
