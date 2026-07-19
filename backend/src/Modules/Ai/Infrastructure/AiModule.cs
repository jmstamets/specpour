using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Ai.Contracts;

namespace SpecPour.Modules.Ai.Infrastructure;

/// <summary>
/// Composition root for the AI module foundation (T068): prompt registry +
/// provider-adapter ports, no endpoints of its own — every feature consumes it via
/// <see cref="IPromptRegistryPort"/>/<see cref="IVisionProviderAdapter"/>/
/// <see cref="ILlmProviderAdapter"/>, T069 (bottle recognition) being the first.
/// </summary>
public sealed class AiModule : IModule
{
    public string Name => "Ai";
    public string? SchemaName => ModuleSchemas.Ai;

    public void RegisterServices(IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetSpecPourConnectionString();

        services.AddDbContext<AiDbContext>((sp, options) =>
        {
            options.UseNpgsql(connectionString);
            options.AddInterceptors(sp.GetRequiredService<OutboxSaveChangesInterceptor>());
        });
        services.AddSpecPourOutboxWriter(Name);

        services.AddScoped<IPromptRegistryPort, PromptRegistryAdapter>();
        services.AddScoped<IVisionProviderAdapter, UnconfiguredVisionProviderAdapter>();
        services.AddScoped<ILlmProviderAdapter, UnconfiguredLlmProviderAdapter>();
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        // No endpoints of its own — a pure foundation module.
    }
}
