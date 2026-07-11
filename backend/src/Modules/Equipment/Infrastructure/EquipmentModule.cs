using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Search.Contracts;

namespace SpecPour.Modules.Equipment.Infrastructure;

/// <summary>Composition root for the equipment module (T034).</summary>
public sealed class EquipmentModule : IModule
{
    public string Name => "Equipment";
    public string? SchemaName => ModuleSchemas.Equipment;

    public void RegisterServices(IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetSpecPourConnectionString();

        services.AddDbContext<EquipmentDbContext>(options => options.UseNpgsql(connectionString));
        services.AddSpecPourOutboxWriter(Name);

        services.AddHostedService<EquipmentSearchRegistrationHostedService>();
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
            TsVectorColumn: "SearchVector"));

        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
