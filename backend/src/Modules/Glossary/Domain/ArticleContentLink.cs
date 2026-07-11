namespace SpecPour.Modules.Glossary.Domain;

/// <summary>
/// Article &lt;-&gt; (recipe|ingredient|equipment) join (FR-026), same polymorphic
/// pattern as <see cref="GlossaryTermContentLink"/>. <see cref="ContentId"/> crosses
/// into another module's schema by ID only — no FK constraint (ADR-0001).
/// </summary>
public sealed class ArticleContentLink
{
    public required Guid Id { get; init; }

    public required Guid ArticleId { get; init; }

    public required GlossaryContentType ContentType { get; init; }

    public required Guid ContentId { get; init; }
}
