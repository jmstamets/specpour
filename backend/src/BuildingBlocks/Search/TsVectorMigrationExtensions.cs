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
        migrationBuilder.EnsureImmutableToTsVectorFunction(textSearchConfig);

        var concatExpression = string.Join(" || ' ' || ", sourceColumns.Select(c => $"coalesce(\"{c}\"::text, '')"));

        migrationBuilder.Sql($"""
            ALTER TABLE {schema}."{table}"
            ADD COLUMN "{tsVectorColumn}" tsvector GENERATED ALWAYS AS ({ImmutableToTsVectorCall(textSearchConfig, concatExpression)}) STORED;
            """);

        migrationBuilder.Sql($"""
            CREATE INDEX "IX_{table}_{tsVectorColumn}" ON {schema}."{table}" USING GIN ("{tsVectorColumn}");
            """);
    }

    /// <summary>
    /// Postgres refuses <c>to_tsvector('english', content)</c> directly inside a
    /// <c>GENERATED ... STORED</c> column expression ("generation expression is not
    /// immutable") — casting the config name literal to <c>regconfig</c>
    /// (<c>regconfigin</c>) is only STABLE, and that cast poisons the outer
    /// expression even through a wrapper function, because Postgres evaluates it in
    /// the *caller's* expression tree wherever the argument is passed in from
    /// outside. The fix: bake the config into the function body (a compile-time
    /// literal there, not a runtime argument) rather than passing it in, and use
    /// PL/pgSQL rather than SQL — a plain SQL-language function gets inlined by the
    /// planner during the immutability check, re-exposing the STABLE call it
    /// wraps; PL/pgSQL is opaque to that inlining, so only the function's own
    /// declared IMMUTABLE label is checked. One function per config name, named
    /// accordingly. <c>CREATE OR REPLACE</c> makes this idempotent across every
    /// module's migration that needs it, regardless of which one runs first.
    /// </summary>
    public static void EnsureImmutableToTsVectorFunction(this MigrationBuilder migrationBuilder, string textSearchConfig = "english")
    {
        migrationBuilder.Sql($"""
            CREATE OR REPLACE FUNCTION {ImmutableToTsVectorFunctionName(textSearchConfig)}(content text)
            RETURNS tsvector AS $$
            BEGIN
                RETURN to_tsvector('{textSearchConfig}', content);
            END;
            $$ LANGUAGE plpgsql IMMUTABLE PARALLEL SAFE;
            """);

        // array_to_string is STABLE (not IMMUTABLE) for every anyarray input, so a
        // module concatenating a text[] source column (e.g. Recipe.AlternateNames)
        // into its tsvector content needs the same PL/pgSQL-opacity trick.
        migrationBuilder.Sql("""
            CREATE OR REPLACE FUNCTION specpour_immutable_array_to_string(arr text[], sep text)
            RETURNS text AS $$
            BEGIN
                RETURN array_to_string(arr, sep);
            END;
            $$ LANGUAGE plpgsql IMMUTABLE PARALLEL SAFE;
            """);
    }

    /// <summary>The name of the per-config function <see cref="EnsureImmutableToTsVectorFunction"/> creates.</summary>
    public static string ImmutableToTsVectorFunctionName(string textSearchConfig = "english") =>
        $"specpour_immutable_to_tsvector_{textSearchConfig}";

    private static string ImmutableToTsVectorCall(string textSearchConfig, string contentExpression) =>
        $"{ImmutableToTsVectorFunctionName(textSearchConfig)}({contentExpression})";

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
