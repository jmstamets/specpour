using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Venues.Infrastructure;

/// <summary>Composition root for the venues module (T061).</summary>
public sealed class VenuesModule : IModule
{
    public string Name => "Venues";
    public string? SchemaName => ModuleSchemas.Venues;

    public void RegisterServices(IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetSpecPourConnectionString();

        services.AddDbContext<VenuesDbContext>((sp, options) =>
        {
            // T061: UseNetTopologySuite() is what actually activates the
            // geometry <-> Point type mapping this module's Venue.Location needs —
            // the postgis extension exists (T013), but without this the Npgsql
            // provider has no idea how to read/write it.
            options.UseNpgsql(connectionString, o => o.UseNetTopologySuite());
            options.AddInterceptors(sp.GetRequiredService<OutboxSaveChangesInterceptor>());
        });
        services.AddSpecPourOutboxWriter(Name);
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        Endpoints.VenueEndpoints.Map(endpoints);
    }
}
