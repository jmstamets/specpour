using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Inventory.Infrastructure;

/// <summary>
/// Composition root for the inventory module (T066). Deliberately does NOT register
/// an <c>ISearchableEntityRegistry</c> entry the way every other authored-content
/// module does (Catalog/Ingredients/Equipment) — inventory must never appear in
/// search results, by design (Phase 6 entry guidance: the most private data surface
/// in the platform, no public/curator variant at all, ever).
/// </summary>
public sealed class InventoryModule : IModule
{
    public string Name => "Inventory";
    public string? SchemaName => ModuleSchemas.Inventory;

    public void RegisterServices(IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetSpecPourConnectionString();

        services.AddDbContext<InventoryDbContext>((sp, options) =>
        {
            options.UseNpgsql(connectionString);
            options.AddInterceptors(sp.GetRequiredService<OutboxSaveChangesInterceptor>());
        });
        services.AddSpecPourOutboxWriter(Name);
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        Endpoints.InventoryItemEndpoints.Map(endpoints);
    }
}
