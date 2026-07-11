namespace SpecPour.Modules.Glossary.Domain;

/// <summary>
/// data-model.md GlossaryTerm "tags[] linking recipes/ingredients/equipment"
/// (FR-025/FR-028's cross-discovery, e.g. "recipes using Agricole" from the Agricole
/// entry) — modeled as direct entity links, not a shared tag vocabulary (that's
/// Catalog.Tag, a different concept). <see cref="ContentId"/> crosses into another
/// module's schema by ID only — no FK constraint, per constitution Principle III
/// (ADR-0001).
/// </summary>
public sealed class GlossaryTermContentLink
{
    public required Guid Id { get; init; }

    public required Guid GlossaryTermId { get; init; }

    public required GlossaryContentType ContentType { get; init; }

    public required Guid ContentId { get; init; }
}
