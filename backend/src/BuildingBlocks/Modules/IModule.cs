using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace SpecPour.BuildingBlocks.Modules;

/// <summary>
/// Composition-root contract every business module implements (constitution Principle
/// III). The Api host discovers and drives one instance of this per module; modules
/// never reference each other directly, only through their own Contracts project.
/// </summary>
public interface IModule
{
    /// <summary>Stable module name, matching its schema/folder name (e.g. "Identity").</summary>
    string Name { get; }

    /// <summary>
    /// PostgreSQL schema this module owns, or <c>null</c> for modules that own no
    /// schema (Search — its indexes live in owning-module schemas, per the T141 ADR).
    /// </summary>
    string? SchemaName { get; }

    /// <summary>Registers the module's DbContext, application services, and ports/adapters.</summary>
    void RegisterServices(IServiceCollection services, IConfiguration configuration);

    /// <summary>Maps the module's minimal-API endpoints onto the host's route builder.</summary>
    void MapEndpoints(IEndpointRouteBuilder endpoints);
}
