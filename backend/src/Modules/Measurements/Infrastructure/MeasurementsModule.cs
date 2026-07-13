using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Measurements.Contracts;

namespace SpecPour.Modules.Measurements.Infrastructure;

/// <summary>Composition root for the measurements module (T024).</summary>
public sealed class MeasurementsModule : IModule
{
    public string Name => "Measurements";
    public string? SchemaName => ModuleSchemas.Measurements;

    public void RegisterServices(IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetSpecPourConnectionString();

        // T155: the outbox interceptor must be attached here (not merely
        // DI-registered) for OutboxSaveChangesInterceptor to actually run — a
        // gap discovered while wiring T155's ingredient-rename event (the first
        // real outbox producer/consumer in the codebase). Fixed identically
        // across every module for consistency.
        services.AddDbContext<MeasurementsDbContext>((sp, options) =>
        {
            options.UseNpgsql(connectionString);
            options.AddInterceptors(sp.GetRequiredService<OutboxSaveChangesInterceptor>());
        });
        services.AddSpecPourOutboxWriter(Name);

        services.AddScoped<IMeasurementConversionService, MeasurementConversionService>();
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        // /recipes/{id}/scale, /batch, /costing (consuming this module's conversion
        // service) land in T073-T075.
    }
}
