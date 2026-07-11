using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Npgsql;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Search.Application.Ports;
using SpecPour.Modules.Search.Contracts;

namespace SpecPour.Modules.Search.Infrastructure;

/// <summary>
/// Composition root for the search module (T022). Deliberately has no
/// SchemaName/migrator — Search owns no schema (T141 ADR); it only ever reads
/// tsvector columns other modules maintain in their own migrations.
/// </summary>
public sealed class SearchModule : IModule
{
    public string Name => "Search";
    public string? SchemaName => null;

    public void RegisterServices(IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetSpecPourConnectionString();

        services.AddSingleton(NpgsqlDataSource.Create(connectionString));
        services.AddSingleton<ISearchableEntityRegistry, SearchableEntityRegistry>();
        services.AddScoped<ISearchPort, PostgresFullTextSearchAdapter>();
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        // GET /api/v1/search lands in T038, once content modules exist to search.
    }
}
