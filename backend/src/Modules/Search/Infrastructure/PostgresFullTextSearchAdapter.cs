using System.Text;
using Npgsql;
using SpecPour.Modules.Search.Application;
using SpecPour.Modules.Search.Application.Ports;
using SpecPour.Modules.Search.Contracts;

namespace SpecPour.Modules.Search.Infrastructure;

/// <summary>
/// V1's <see cref="ISearchPort"/> adapter (R8): PostgreSQL full-text search
/// (<c>websearch_to_tsquery</c> against each registered entity's generated tsvector
/// column) unioned with trigram similarity (<c>pg_trgm</c>) for name-fuzziness
/// matching, ranked and paginated. Facet filtering composition is completed by
/// T038/T148/T149 once content modules exist to filter on — this adapter accepts
/// <see cref="SearchQuery.Facets"/> in its contract today (so the port shape doesn't
/// need to change later) but does not yet apply them.
/// </summary>
public sealed class PostgresFullTextSearchAdapter(NpgsqlDataSource dataSource, ISearchableEntityRegistry registry) : ISearchPort
{
    private const double TrigramSimilarityThreshold = 0.3;

    public async Task<SearchPage> SearchAsync(SearchQuery query, CancellationToken cancellationToken)
    {
        var descriptors = registry.All;
        if (descriptors.Count == 0 || string.IsNullOrWhiteSpace(query.Text))
        {
            return new SearchPage([], null);
        }

        var offset = DecodeCursor(query.Cursor);
        var sql = BuildUnionQuery(descriptors);

        await using var command = dataSource.CreateCommand(sql);
        command.Parameters.AddWithValue("query", query.Text);
        command.Parameters.AddWithValue("threshold", TrigramSimilarityThreshold);
        command.Parameters.AddWithValue("limit", query.Limit + 1);
        command.Parameters.AddWithValue("offset", offset);

        var items = new List<SearchResultItem>();
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            items.Add(new SearchResultItem(
                reader.GetString(0),
                reader.GetGuid(1),
                reader.GetString(2),
                null,
                reader.GetDouble(3)));
        }

        var hasMore = items.Count > query.Limit;
        var page = hasMore ? items[..query.Limit] : items;
        var nextCursor = hasMore ? EncodeCursor(offset + query.Limit) : null;

        return new SearchPage(page, nextCursor);
    }

    private static string BuildUnionQuery(IReadOnlyList<SearchableEntityDescriptor> descriptors)
    {
        var branches = descriptors.Select(d => $"""
            SELECT
                '{EscapeLiteral(d.EntityType)}' AS entity_type,
                "{d.IdColumn}" AS entity_id,
                "{d.TitleColumn}" AS title,
                ts_rank("{d.TsVectorColumn}", websearch_to_tsquery('english', @query)) + similarity("{d.TitleColumn}", @query) AS score
            FROM {d.Schema}."{d.Table}"
            WHERE "{d.TsVectorColumn}" @@ websearch_to_tsquery('english', @query)
               OR similarity("{d.TitleColumn}", @query) > @threshold
            """);

        var union = string.Join("\nUNION ALL\n", branches);

        var sql = new StringBuilder()
            .AppendLine("SELECT entity_type, entity_id, title, score FROM (")
            .AppendLine(union)
            .AppendLine(") AS ranked")
            .AppendLine("ORDER BY score DESC, entity_id ASC")
            .AppendLine("OFFSET @offset LIMIT @limit");

        return sql.ToString();
    }

    // Descriptor EntityType strings come from trusted module registration code, not
    // request input, but this still guards against a typo introducing a broken query
    // (an unescaped quote) rather than a silent wrong answer.
    private static string EscapeLiteral(string value) => value.Replace("'", "''", StringComparison.Ordinal);

    private static int DecodeCursor(string? cursor)
    {
        if (string.IsNullOrEmpty(cursor))
        {
            return 0;
        }

        var bytes = Convert.FromBase64String(cursor);
        return int.Parse(Encoding.UTF8.GetString(bytes), System.Globalization.CultureInfo.InvariantCulture);
    }

    private static string EncodeCursor(int offset) => Convert.ToBase64String(Encoding.UTF8.GetBytes(offset.ToString(System.Globalization.CultureInfo.InvariantCulture)));
}
