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
public sealed record SearchableEntityDescriptor(
    string EntityType,
    string Schema,
    string Table,
    string IdColumn,
    string TitleColumn,
    string TsVectorColumn);
