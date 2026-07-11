using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace SpecPour.BuildingBlocks.Events.Outbox;

public static class OutboxServiceCollectionExtensions
{
    /// <summary>
    /// Registers the outbox dispatch pipeline: the event-type catalog (singleton, modules
    /// populate it via <see cref="IModuleMigrator"/>-adjacent RegisterServices calls), a
    /// read-only <see cref="OutboxDbContext"/> for the poller, and the background
    /// dispatcher itself. Call once from the Api host (T014); does not register
    /// per-module write-path pieces (<see cref="EventBuffer"/>, <see cref="OutboxSaveChangesInterceptor"/>) —
    /// each module registers those itself since they must share its own DbContext's scope.
    /// </summary>
    public static IServiceCollection AddSpecPourOutboxDispatcher(
        this IServiceCollection services,
        string connectionString,
        Action<OutboxDispatcherOptions>? configure = null)
    {
        services.AddSingleton<IEventTypeCatalog, EventTypeCatalog>();

        services.AddDbContext<OutboxDbContext>(options => options.UseNpgsql(connectionString));

        services.AddOptions<OutboxDispatcherOptions>();
        if (configure is not null)
        {
            services.Configure(configure);
        }

        services.AddHostedService<OutboxDispatcherBackgroundService>();

        return services;
    }

    /// <summary>
    /// Registers the write-path pieces a module's own DbContext needs to buffer and
    /// persist events transactionally: a scoped <see cref="EventBuffer"/> (bound to both
    /// <see cref="IDomainEventDispatcher"/> and itself so the interceptor can resolve the
    /// concrete type) and the module's own <see cref="OutboxSaveChangesInterceptor"/>.
    /// </summary>
    public static IServiceCollection AddSpecPourOutboxWriter(this IServiceCollection services, string moduleName)
    {
        services.AddScoped<EventBuffer>();
        services.AddScoped<IDomainEventDispatcher>(sp => sp.GetRequiredService<EventBuffer>());
        services.AddScoped(sp => new OutboxSaveChangesInterceptor(sp.GetRequiredService<EventBuffer>(), moduleName));

        return services;
    }

    /// <summary>Reads the Postgres connection string from configuration under the conventional key.</summary>
    public static string GetSpecPourConnectionString(this IConfiguration configuration) =>
        configuration.GetConnectionString("Postgres")
        ?? throw new InvalidOperationException("Missing ConnectionStrings:Postgres configuration value.");
}
