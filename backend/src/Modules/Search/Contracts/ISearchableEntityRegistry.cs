namespace SpecPour.Modules.Search.Contracts;

/// <summary>
/// Content modules register their searchable tables here during their own
/// <c>IModule.RegisterServices</c> (starting with Catalog, T032) — Search never
/// hard-codes a content module's schema/table names, matching "Search owns no
/// schema" (T141 ADR). This is a cross-module surface (constitution Principle III):
/// other modules depend on this Contracts interface, never on Search's
/// Application/Infrastructure directly. An empty registry (true today, before any
/// content module exists) is a valid, correct state: search results are simply empty.
/// </summary>
public interface ISearchableEntityRegistry
{
    void Register(SearchableEntityDescriptor descriptor);

    IReadOnlyList<SearchableEntityDescriptor> All { get; }
}

/// <summary>
/// Describes one searchable table for the PostgreSQL FTS adapter to query. The
/// referenced table must have a generated tsvector column
/// (<c>SpecPour.BuildingBlocks.Search.TsVectorMigrationExtensions.AddGeneratedTsVectorColumn</c>)
/// and, for name-fuzziness matching, a trigram index on <paramref name="TitleColumn"/>.
/// </summary>
/// <param name="VisibilityColumn">
/// T058: name of the entity's integer <c>ContentVisibility</c> column, if it has one —
/// null for entity types with no visibility concept. When set alongside
/// <paramref name="PublicVisibilityValue"/>, the adapter restricts this branch to that
/// value, so a private/personal-library row (e.g. an authored Recipe) is never
/// returned to a search caller who isn't its owner (FR-008b privacy). Search itself
/// stays entity-agnostic (T141 ADR) — this is a column NAME and a plain integer, not a
/// dependency on any content module's own enum type.
/// </param>
public sealed record SearchableEntityDescriptor(
    string EntityType,
    string Schema,
    string Table,
    string IdColumn,
    string TitleColumn,
    string TsVectorColumn,
    string? VisibilityColumn = null,
    int? PublicVisibilityValue = null);
