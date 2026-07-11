using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.BuildingBlocks.Events;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Notifications.Application.Ports;

namespace SpecPour.Modules.Notifications.Infrastructure;

/// <summary>Composition root for the notifications thin slice (T023).</summary>
public sealed class NotificationsModule : IModule
{
    public string Name => "Notifications";
    public string? SchemaName => ModuleSchemas.Notifications;

    public void RegisterServices(IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetSpecPourConnectionString();

        services.AddDbContext<NotificationsDbContext>(options => options.UseNpgsql(connectionString));
        services.AddSpecPourOutboxWriter(Name);

        services.AddScoped<IEmailChannelAdapter, LoggingEmailChannelAdapter>();

        // Open-generic registration: resolves for any concrete TEvent that satisfies
        // NotificationEventConsumer<TEvent>'s "where TEvent : INotificationEvent"
        // constraint, and only those — a future event type that does NOT implement
        // INotificationEvent simply never matches this registration.
        services.AddScoped(typeof(IDomainEventHandler<>), typeof(NotificationEventConsumer<>));
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        InboxEndpoint.Map(endpoints);

        // POST /inbox/{id}/read and GET/PUT /me/channels are not yet scheduled by
        // any task (tracked separately — see memory) — only GET /inbox is in scope.
    }
}
