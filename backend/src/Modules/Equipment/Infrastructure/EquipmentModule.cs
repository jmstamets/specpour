using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Library;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Equipment.Contracts;
using SpecPour.Modules.Search.Contracts;
using SpecPour.Modules.Venues.Contracts;

namespace SpecPour.Modules.Equipment.Infrastructure;

/// <summary>Composition root for the equipment module (T034).</summary>
public sealed class EquipmentModule : IModule
{
    public string Name => "Equipment";
    public string? SchemaName => ModuleSchemas.Equipment;

    public void RegisterServices(IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetSpecPourConnectionString();

        // T155: the outbox interceptor must be attached here (not merely
        // DI-registered) for OutboxSaveChangesInterceptor to actually run — a
        // gap discovered while wiring T155's ingredient-rename event (the first
        // real outbox producer/consumer in the codebase). Fixed identically
        // across every module for consistency.
        services.AddDbContext<EquipmentDbContext>((sp, options) =>
        {
            options.UseNpgsql(connectionString);
            options.AddInterceptors(sp.GetRequiredService<OutboxSaveChangesInterceptor>());
        });
        services.AddSpecPourOutboxWriter(Name);

        services.AddHostedService<EquipmentSearchRegistrationHostedService>();
        services.AddScoped<IEquipmentLookupPort, EquipmentLookupAdapter>();
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        Endpoints.EquipmentEndpoints.Map(endpoints);
    }
}

/// <summary>Registers Equipment as searchable (T034) — see CatalogSearchRegistrationHostedService for why this needs to be a hosted service.</summary>
public sealed class EquipmentSearchRegistrationHostedService(ISearchableEntityRegistry registry) : Microsoft.Extensions.Hosting.IHostedService
{
    public Task StartAsync(CancellationToken cancellationToken)
    {
        registry.Register(new SearchableEntityDescriptor(
            EntityType: "equipment",
            Schema: ModuleSchemas.Equipment,
            Table: "Equipment",
            IdColumn: "Id",
            TitleColumn: "Name",
            TsVectorColumn: "SearchVector",
            // T060: personal/bar-library equipment now exists alongside curated-core
            // rows and defaults private — same privacy fix as Catalog/Ingredients'
            // registrations (FR-008b).
            VisibilityColumn: "Visibility",
            PublicVisibilityValue: (int)ContentVisibility.Public));

        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
