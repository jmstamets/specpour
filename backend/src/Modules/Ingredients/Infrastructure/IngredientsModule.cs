using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.BuildingBlocks.Events;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Library;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Ingredients.Contracts;
using SpecPour.Modules.Ingredients.Contracts.Events;
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

        // T155: the outbox interceptor must be attached here (not merely
        // DI-registered) for OutboxSaveChangesInterceptor to actually run — a
        // gap discovered while wiring T155's ingredient-rename event (the first
        // real outbox producer/consumer in the codebase). Fixed identically
        // across every module for consistency.
        services.AddDbContext<IngredientsDbContext>((sp, options) =>
        {
            options.UseNpgsql(connectionString);
            options.AddInterceptors(sp.GetRequiredService<OutboxSaveChangesInterceptor>());
        });
        services.AddSpecPourOutboxWriter(Name);

        services.AddHostedService<IngredientsSearchRegistrationHostedService>();
        services.AddHostedService<IngredientsEventRegistrationHostedService>();
        services.AddScoped<IIngredientLookupPort, IngredientLookupAdapter>();
        services.AddScoped<IngredientRenameService>();
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        Endpoints.IngredientEndpoints.Map(endpoints);
    }
}

/// <summary>
/// T155: registers IngredientRenamed with the process-wide event-type catalog so
/// the outbox dispatcher can resolve the CLR type for deserialization — the
/// producing module owns this registration (see CatalogSearchRegistrationHostedService
/// for why it must be a hosted service, not inline RegisterServices code).
/// </summary>
public sealed class IngredientsEventRegistrationHostedService(IEventTypeCatalog eventTypeCatalog) : Microsoft.Extensions.Hosting.IHostedService
{
    public Task StartAsync(CancellationToken cancellationToken)
    {
        eventTypeCatalog.Register<IngredientRenamed>();
        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
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
            TsVectorColumn: "SearchVector",
            // T059: personal-library ingredients (including house-made ones) now
            // exist alongside curated-core ones and default private — same privacy
            // fix as CatalogModule's Recipe registration (FR-008b).
            VisibilityColumn: "Visibility",
            PublicVisibilityValue: (int)ContentVisibility.Public));

        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
