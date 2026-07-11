using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Compliance.Application.Ports;

namespace SpecPour.Modules.Compliance.Infrastructure;

/// <summary>Composition root for the compliance module (T020).</summary>
public sealed class ComplianceModule : IModule
{
    public string Name => "Compliance";
    public string? SchemaName => ModuleSchemas.Compliance;

    public void RegisterServices(IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetSpecPourConnectionString();

        services.AddDbContext<ComplianceDbContext>(options => options.UseNpgsql(connectionString));
        services.AddSpecPourOutboxWriter(Name);

        services.AddSingleton<IGeoIpPort, MaxMindGeoIpAdapter>();
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        AgeGateEndpoint.Map(endpoints);

        // Responsible-consumption messaging + support resources land in T150.
    }
}
