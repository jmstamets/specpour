using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.BuildingBlocks.Events;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Catalog.Application.DerivedData;
using SpecPour.Modules.Catalog.Contracts;
using SpecPour.Modules.Catalog.Infrastructure.Search;
using SpecPour.Modules.Ingredients.Contracts.Events;
using SpecPour.Modules.Search.Contracts;

namespace SpecPour.Modules.Catalog.Infrastructure;

/// <summary>Composition root for the catalog module (T032).</summary>
public sealed class CatalogModule : IModule
{
    public string Name => "Catalog";
    public string? SchemaName => ModuleSchemas.Catalog;

    public void RegisterServices(IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetSpecPourConnectionString();

        // T155: the outbox interceptor must be attached here (not merely
        // DI-registered) for OutboxSaveChangesInterceptor to actually run — a
        // gap discovered while wiring T155's ingredient-rename event (the first
        // real outbox producer/consumer in the codebase). Fixed identically
        // across every module for consistency.
        services.AddDbContext<CatalogDbContext>((sp, options) =>
        {
            options.UseNpgsql(connectionString);
            options.AddInterceptors(sp.GetRequiredService<OutboxSaveChangesInterceptor>());
        });
        services.AddSpecPourOutboxWriter(Name);

        services.AddHostedService<CatalogSearchRegistrationHostedService>();
        services.AddScoped<IRecipeDerivedDataCalculator, RecipeDerivedDataCalculator>();
        services.AddScoped<IRecipeLookupPort, RecipeLookupAdapter>();

        // T155/ADR-0002: event-maintained search document.
        services.AddScoped<RecipeSearchDocumentRefresher>();
        services.AddScoped<IDomainEventHandler<IngredientRenamed>, IngredientRenamedSearchDocumentHandler>();
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        Endpoints.RecipeEndpoints.Map(endpoints);
        Endpoints.ConceptEndpoints.Map(endpoints);
    }
}

/// <summary>
/// Registers Recipe as searchable (T032) — mirrors
/// OpenIddictClientSeedingHostedService's "run once against the fully-built DI
/// container at startup" pattern, needed here because
/// ISearchableEntityRegistry.Register only makes sense against the live singleton
/// instance, which doesn't exist yet during RegisterServices (still just service
/// descriptors at that point).
/// </summary>
public sealed class CatalogSearchRegistrationHostedService(ISearchableEntityRegistry registry) : Microsoft.Extensions.Hosting.IHostedService
{
    public Task StartAsync(CancellationToken cancellationToken)
    {
        registry.Register(new SearchableEntityDescriptor(
            EntityType: "recipe",
            Schema: ModuleSchemas.Catalog,
            Table: "Recipes",
            IdColumn: "Id",
            TitleColumn: "PrimaryName",
            TsVectorColumn: "SearchVector"));

        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
