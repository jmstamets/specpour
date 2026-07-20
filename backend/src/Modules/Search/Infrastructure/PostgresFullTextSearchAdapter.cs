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
/// T038/T148/T149 once content modules exist to filter on. <see cref="SearchQuery.EntityIdFilter"/>
/// (T148) is applied INSIDE this adapter's own SQL, per matching entity-type branch,
/// before the OFFSET/LIMIT — fixing the previous post-filter-after-pagination
/// limitation without this adapter needing any opinion on what a facet means.
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
        var entityIdFilter = query.EntityIdFilter ?? new Dictionary<string, IReadOnlyList<Guid>>();
        var sql = BuildUnionQuery(descriptors, entityIdFilter);

        await using var command = dataSource.CreateCommand(sql);
        command.Parameters.AddWithValue("query", query.Text);
        command.Parameters.AddWithValue("threshold", TrigramSimilarityThreshold);
        command.Parameters.AddWithValue("limit", query.Limit + 1);
        command.Parameters.AddWithValue("offset", offset);
        foreach (var descriptor in descriptors)
        {
            if (entityIdFilter.TryGetValue(descriptor.EntityType, out var allowedIds))
            {
                command.Parameters.AddWithValue(FilterParameterName(descriptor.EntityType), allowedIds.ToArray());
            }
        }

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

    private static string BuildUnionQuery(IReadOnlyList<SearchableEntityDescriptor> descriptors, IReadOnlyDictionary<string, IReadOnlyList<Guid>> entityIdFilter)
    {
        var branches = descriptors.Select(d =>
        {
            // T058: private/personal-library rows (e.g. an authored Recipe) must never
            // surface in another caller's search results (FR-008b) — descriptors that
            // carry a visibility column get an extra AND clause restricting this branch
            // to the public value. PublicVisibilityValue is a plain int from trusted
            // module-registration code (never request input), safe to interpolate
            // directly the same way the other descriptor fields already are.
            var visibilityClause = d.VisibilityColumn is not null && d.PublicVisibilityValue is not null
                ? $"""AND "{d.VisibilityColumn}" = {d.PublicVisibilityValue.Value}"""
                : string.Empty;

            // T148: an entity-type-scoped ID allowlist (e.g. a "makeable"/"uses"
            // facet already resolved elsewhere, since Search stays entity-agnostic
            // and has no idea what those mean) — applied here, inside the branch,
            // before this whole query's OFFSET/LIMIT, so pagination reflects the
            // filtered count rather than needing a post-filter after the fact.
            var idFilterClause = entityIdFilter.ContainsKey(d.EntityType)
                ? $"""AND "{d.IdColumn}" = ANY(@{FilterParameterName(d.EntityType)})"""
                : string.Empty;

            return $"""
                SELECT
                    '{EscapeLiteral(d.EntityType)}' AS entity_type,
                    "{d.IdColumn}" AS entity_id,
                    "{d.TitleColumn}" AS title,
                    ts_rank("{d.TsVectorColumn}", websearch_to_tsquery('english', @query)) + similarity("{d.TitleColumn}", @query) AS score
                FROM {d.Schema}."{d.Table}"
                WHERE ("{d.TsVectorColumn}" @@ websearch_to_tsquery('english', @query)
                   OR similarity("{d.TitleColumn}", @query) > @threshold)
                {visibilityClause}
                {idFilterClause}
                """;
        });

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

    // Entity types are trusted, simple strings from module registration (e.g.
    // "recipe") — sanitized defensively so a future entity-type naming choice can't
    // accidentally produce an invalid Npgsql parameter name.
    private static string FilterParameterName(string entityType) =>
        "filter_" + new string([.. entityType.Where(char.IsLetterOrDigit)]);

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
