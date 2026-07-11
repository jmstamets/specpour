namespace SpecPour.Modules.Search.Application.Ports;

/// <summary>
/// The search port (R8, FR-049): defines search behavior independent of the backing
/// engine, so a dedicated search engine (OpenSearch/Meilisearch) is a pure adapter
/// swap later. V1's <c>PostgresFullTextSearchAdapter</c> implements this over every
/// entity registered with <see cref="ISearchableEntityRegistry"/>.
/// </summary>
public interface ISearchPort
{
    Task<SearchPage> SearchAsync(SearchQuery query, CancellationToken cancellationToken);
}
