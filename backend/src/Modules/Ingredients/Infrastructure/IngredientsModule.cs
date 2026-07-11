using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Ingredients.Contracts;
using SpecPour.Modules.Search.Contracts;

namespace SpecPour.Modules.Ingredients.Infrastructure;

/// <summary>Composition root for the ingredients module (T033).</summary>
public sealed class IngredientsModule : IModule
{
    public string Name => "Ingredients";
    public string? SchemaName => ModuleSchemas.Ingredients;

    public void RegisterServices(IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetSpecPourConnectionString();

        services.AddDbContext<IngredientsDbContext>(options => options.UseNpgsql(connectionString));
        services.AddSpecPourOutboxWriter(Name);

        services.AddHostedService<IngredientsSearchRegistrationHostedService>();
        services.AddScoped<IIngredientLookupPort, IngredientLookupAdapter>();
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        Endpoints.IngredientEndpoints.Map(endpoints);
    }
}

/// <summary>Registers Ingredient as searchable (T033) — see CatalogSearchRegistrationHostedService for why this needs to be a hosted service rather than done inline in RegisterServices.</summary>
public sealed class IngredientsSearchRegistrationHostedService(ISearchableEntityRegistry registry) : Microsoft.Extensions.Hosting.IHostedService
{
    public Task StartAsync(CancellationToken cancellationToken)
    {
        registry.Register(new SearchableEntityDescriptor(
            EntityType: "ingredient",
            Schema: ModuleSchemas.Ingredients,
            Table: "Ingredients",
            IdColumn: "Id",
            TitleColumn: "Name",
            TsVectorColumn: "SearchVector"));

        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
