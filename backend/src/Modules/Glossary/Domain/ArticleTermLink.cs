namespace SpecPour.Modules.Glossary.Domain;

/// <summary>Article &lt;-&gt; GlossaryTerm join (FR-026). Both sides same-schema, so a real FK applies — unlike <see cref="ArticleContentLink"/>.</summary>
public sealed class ArticleTermLink
{
    public required Guid ArticleId { get; init; }

    public required Guid GlossaryTermId { get; init; }
}
