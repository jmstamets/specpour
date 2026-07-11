using Microsoft.EntityFrameworkCore.Migrations;

namespace SpecPour.BuildingBlocks.Search;

/// <summary>
/// Reusable migration helpers for the "tsvector columns live in owning-module
/// schemas" pattern (T013/T022, research R8): every content module that wants to be
/// searchable adds a generated tsvector column plus a GIN index to its own table via
/// its own migration, then registers the table with
/// <c>ISearchableEntityRegistry</c> (Search.Application) at startup. Search itself
/// owns no schema — it only ever reads columns other modules maintain.
/// </summary>
public static class TsVectorMigrationExtensions
{
    /// <summary>
    /// Adds a PostgreSQL-generated (STORED) tsvector column combining
    /// <paramref name="sourceColumns"/>, plus a GIN index for fast <c>@@</c> queries
    /// (websearch_to_tsquery). The column is maintained automatically by PostgreSQL on
    /// every write — no application-level maintenance code is needed.
    /// </summary>
    public static void AddGeneratedTsVectorColumn(
        this MigrationBuilder migrationBuilder,
        string schema,
        string table,
        string tsVectorColumn,
        IEnumerable<string> sourceColumns,
        string textSearchConfig = "english")
    {
        var concatExpression = string.Join(" || ' ' || ", sourceColumns.Select(c => $"coalesce(\"{c}\"::text, '')"));

        migrationBuilder.Sql($"""
            ALTER TABLE {schema}."{table}"
            ADD COLUMN "{tsVectorColumn}" tsvector GENERATED ALWAYS AS (to_tsvector('{textSearchConfig}', {concatExpression})) STORED;
            """);

        migrationBuilder.Sql($"""
            CREATE INDEX "IX_{table}_{tsVectorColumn}" ON {schema}."{table}" USING GIN ("{tsVectorColumn}");
            """);
    }

    /// <summary>
    /// Adds a trigram (pg_trgm) GIN index on <paramref name="column"/> for fuzzy
    /// name matching (R8) — catches typos/partial matches that plain tsvector ranking
    /// misses.
    /// </summary>
    public static void AddTrigramIndex(this MigrationBuilder migrationBuilder, string schema, string table, string column)
    {
        migrationBuilder.Sql("CREATE EXTENSION IF NOT EXISTS pg_trgm;");
        migrationBuilder.Sql($"""
            CREATE INDEX "IX_{table}_{column}_trgm" ON {schema}."{table}" USING GIN ("{column}" gin_trgm_ops);
            """);
    }
}
