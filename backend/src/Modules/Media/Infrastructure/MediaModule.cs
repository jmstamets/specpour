using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Media.Application.Ports;

namespace SpecPour.Modules.Media.Infrastructure;

/// <summary>Composition root for the media module (T021).</summary>
public sealed class MediaModule : IModule
{
    public string Name => "Media";
    public string? SchemaName => ModuleSchemas.Media;

    public void RegisterServices(IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetSpecPourConnectionString();

        // T155: the outbox interceptor must be attached here (not merely
        // DI-registered) for OutboxSaveChangesInterceptor to actually run — a
        // gap discovered while wiring T155's ingredient-rename event (the first
        // real outbox producer/consumer in the codebase). Fixed identically
        // across every module for consistency.
        services.AddDbContext<MediaDbContext>((sp, options) =>
        {
            options.UseNpgsql(connectionString);
            options.AddInterceptors(sp.GetRequiredService<OutboxSaveChangesInterceptor>());
        });
        services.AddSpecPourOutboxWriter(Name);

        var endpointConfig = configuration["ObjectStorage:Endpoint"]
            ?? throw new InvalidOperationException("Missing ObjectStorage:Endpoint configuration.");
        // docker-compose.yml supplies a full URL (e.g. "http://minio:9000"); the Minio
        // SDK wants bare host:port plus a separate Secure flag, so split them here
        // rather than asking every deployment to configure two separate settings.
        var endpointUri = new Uri(endpointConfig);

        services.AddSingleton(new MediaStorageOptions
        {
            Endpoint = endpointUri.Authority,
            AccessKey = configuration["ObjectStorage:AccessKey"] ?? throw new InvalidOperationException("Missing ObjectStorage:AccessKey configuration."),
            SecretKey = configuration["ObjectStorage:SecretKey"] ?? throw new InvalidOperationException("Missing ObjectStorage:SecretKey configuration."),
            BucketName = configuration["ObjectStorage:BucketName"] ?? "specpour-media",
            Secure = endpointUri.Scheme == Uri.UriSchemeHttps,
        });
        services.AddSingleton<IObjectStoragePort, MinioObjectStorageAdapter>();
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        // The authenticated attach/upload endpoint lands with author content (T062);
        // this module provides the port + storage capability it will call into.
    }
}
