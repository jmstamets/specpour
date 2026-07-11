namespace SpecPour.Modules.Glossary.Domain;

/// <summary>data-model.md Article (FR-026): longer-form informational/how-to content.</summary>
public sealed class Article
{
    public required Guid Id { get; init; }

    public required string Title { get; set; }

    public required string Body { get; set; }
}
