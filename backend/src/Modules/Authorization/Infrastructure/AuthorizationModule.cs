using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Authorization.Application.Ports;
using SpecPour.Modules.Authorization.Contracts.Audit;
using SpecPour.Modules.Authorization.Infrastructure.Audit;

namespace SpecPour.Modules.Authorization.Infrastructure;

/// <summary>Composition root for the authorization module (T018 capability policy, T019 audit log).</summary>
public sealed class AuthorizationModule : IModule
{
    public string Name => "Authorization";
    public string? SchemaName => ModuleSchemas.Authorization;

    public void RegisterServices(IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetSpecPourConnectionString();

        // T155: the outbox interceptor must be attached here (not merely
        // DI-registered) for OutboxSaveChangesInterceptor to actually run — a
        // gap discovered while wiring T155's ingredient-rename event (the first
        // real outbox producer/consumer in the codebase). Fixed identically
        // across every module for consistency.
        services.AddDbContext<AuthorizationDbContext>((sp, options) =>
        {
            options.UseNpgsql(connectionString);
            options.AddInterceptors(sp.GetRequiredService<OutboxSaveChangesInterceptor>());
        });
        services.AddSpecPourOutboxWriter(Name);

        services.AddScoped<ICapabilityPolicy, CapabilityPolicy>();
        services.AddScoped<IAuditWriter, AuditWriter>();
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        EntitlementsEndpoint.Map(endpoints);

        // Role/tier admin consoles and the audit-log review endpoint land in T079-T084.
    }
}
