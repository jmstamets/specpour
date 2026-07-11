using Npgsql;
using SpecPour.Modules.Search.Application;
using SpecPour.Modules.Search.Contracts;
using SpecPour.Modules.Search.Infrastructure;
using Testcontainers.PostgreSql;

namespace SpecPour.Tests.Contract.Modules.Search;

/// <summary>
/// T022's port contract-test suite (research R8: "port contract tests define
/// behavior so a dedicated engine is a pure adapter swap"). No content module exists
/// yet (Catalog lands T032), so this exercises the adapter's core mechanics —
/// tsvector ranking, trigram fuzzy matching, empty-registry safety, pagination —
/// against a throwaway table built the same way any future content module's
/// migration will (SpecPour.BuildingBlocks.Search.TsVectorMigrationExtensions'
/// pattern), via a real Postgres (Testcontainers), not a fake/in-memory double.
/// </summary>
public sealed class SearchPortContractTests : IAsyncLifetime
{
    private static readonly IReadOnlyDictionary<string, IReadOnlyList<string>> NoFacets =
        new Dictionary<string, IReadOnlyList<string>>();

    private readonly PostgreSqlContainer _postgres = new PostgreSqlBuilder("postgis/postgis:17-3.5").Build();

    private NpgsqlDataSource _dataSource = null!;
    private SearchableEntityRegistry _registry = null!;
    private PostgresFullTextSearchAdapter _adapter = null!;

    public async Task InitializeAsync()
    {
        await _postgres.StartAsync();

        _dataSource = NpgsqlDataSource.Create(_postgres.GetConnectionString());

        await using (var command = _dataSource.CreateCommand("""
            CREATE EXTENSION IF NOT EXISTS pg_trgm;
            CREATE SCHEMA test_search;
            CREATE TABLE test_search.widgets (
                id uuid PRIMARY KEY,
                name text NOT NULL,
                description text NOT NULL,
                search_vector tsvector GENERATED ALWAYS AS
                    (to_tsvector('english', coalesce(name, '') || ' ' || coalesce(description, ''))) STORED
            );
            CREATE INDEX ON test_search.widgets USING GIN (search_vector);
            CREATE INDEX ON test_search.widgets USING GIN (name gin_trgm_ops);
            """))
        {
            await command.ExecuteNonQueryAsync();
        }

        await SeedAsync(new Guid("11111111-1111-1111-1111-111111111111"), "Mai Tai", "A classic tiki cocktail with rum and orgeat.");
        await SeedAsync(new Guid("22222222-2222-2222-2222-222222222222"), "Daiquiri", "Rum, lime, and sugar.");
        await SeedAsync(new Guid("33333333-3333-3333-3333-333333333333"), "Old Fashioned", "Whiskey, bitters, and sugar.");

        _registry = new SearchableEntityRegistry();
        _registry.Register(new SearchableEntityDescriptor("Widget", "test_search", "widgets", "id", "name", "search_vector"));

        _adapter = new PostgresFullTextSearchAdapter(_dataSource, _registry);
    }

    public async Task DisposeAsync()
    {
        await _dataSource.DisposeAsync();
        await _postgres.DisposeAsync();
    }

    [Fact]
    public async Task Exact_word_match_ranks_the_matching_row_first()
    {
        var page = await _adapter.SearchAsync(new SearchQuery("Daiquiri", NoFacets, null, 10), CancellationToken.None);

        Assert.NotEmpty(page.Items);
        Assert.Equal("Daiquiri", page.Items[0].Title);
    }

    [Fact]
    public async Task Trigram_fuzzy_match_finds_a_misspelled_name()
    {
        var page = await _adapter.SearchAsync(new SearchQuery("Daiquri", NoFacets, null, 10), CancellationToken.None);

        Assert.Contains(page.Items, i => i.Title == "Daiquiri");
    }

    [Fact]
    public async Task No_match_returns_an_empty_page()
    {
        var page = await _adapter.SearchAsync(new SearchQuery("xyzzyzzyzzy", NoFacets, null, 10), CancellationToken.None);

        Assert.Empty(page.Items);
        Assert.Null(page.NextCursor);
    }

    [Fact]
    public async Task Empty_registry_returns_an_empty_page()
    {
        var adapter = new PostgresFullTextSearchAdapter(_dataSource, new SearchableEntityRegistry());

        var page = await adapter.SearchAsync(new SearchQuery("Daiquiri", NoFacets, null, 10), CancellationToken.None);

        Assert.Empty(page.Items);
    }

    [Fact]
    public async Task Pagination_cursor_returns_the_next_page_without_repeating_items()
    {
        var firstPage = await _adapter.SearchAsync(new SearchQuery("sugar", NoFacets, null, 1), CancellationToken.None);
        Assert.NotNull(firstPage.NextCursor);
        Assert.Single(firstPage.Items);

        var secondPage = await _adapter.SearchAsync(new SearchQuery("sugar", NoFacets, firstPage.NextCursor, 1), CancellationToken.None);

        Assert.Single(secondPage.Items);
        Assert.NotEqual(firstPage.Items[0].EntityId, secondPage.Items[0].EntityId);
    }

    private async Task SeedAsync(Guid id, string name, string description)
    {
        await using var command = _dataSource.CreateCommand(
            "INSERT INTO test_search.widgets (id, name, description) VALUES (@id, @name, @description)");
        command.Parameters.AddWithValue("id", id);
        command.Parameters.AddWithValue("name", name);
        command.Parameters.AddWithValue("description", description);
        await command.ExecuteNonQueryAsync();
    }
}
