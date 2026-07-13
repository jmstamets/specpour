using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Glossary.Application.AutoLink;
using SpecPour.Modules.Search.Contracts;

namespace SpecPour.Modules.Glossary.Infrastructure;

/// <summary>Composition root for the glossary module (T035).</summary>
public sealed class GlossaryModule : IModule
{
    public string Name => "Glossary";
    public string? SchemaName => ModuleSchemas.Glossary;

    public void RegisterServices(IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetSpecPourConnectionString();

        // T155: the outbox interceptor must be attached here (not merely
        // DI-registered) for OutboxSaveChangesInterceptor to actually run — a
        // gap discovered while wiring T155's ingredient-rename event (the first
        // real outbox producer/consumer in the codebase). Fixed identically
        // across every module for consistency.
        services.AddDbContext<GlossaryDbContext>((sp, options) =>
        {
            options.UseNpgsql(connectionString);
            options.AddInterceptors(sp.GetRequiredService<OutboxSaveChangesInterceptor>());
        });
        services.AddSpecPourOutboxWriter(Name);

        services.AddHostedService<GlossarySearchRegistrationHostedService>();
        services.AddScoped<IGlossaryAutoLinkService, AutoLink.GlossaryAutoLinkService>();
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        Endpoints.GlossaryEndpoints.Map(endpoints);
        AutoLink.AutoLinkEndpoint.Map(endpoints);
    }
}

/// <summary>Registers GlossaryTerm and Article as searchable (T035) — see CatalogSearchRegistrationHostedService for why this needs to be a hosted service.</summary>
public sealed class GlossarySearchRegistrationHostedService(ISearchableEntityRegistry registry) : Microsoft.Extensions.Hosting.IHostedService
{
    public Task StartAsync(CancellationToken cancellationToken)
    {
        registry.Register(new SearchableEntityDescriptor(
            EntityType: "glossaryTerm",
            Schema: ModuleSchemas.Glossary,
            Table: "GlossaryTerms",
            IdColumn: "Id",
            TitleColumn: "Term",
            TsVectorColumn: "SearchVector"));

        registry.Register(new SearchableEntityDescriptor(
            EntityType: "article",
            Schema: ModuleSchemas.Glossary,
            Table: "Articles",
            IdColumn: "Id",
            TitleColumn: "Title",
            TsVectorColumn: "SearchVector"));

        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
