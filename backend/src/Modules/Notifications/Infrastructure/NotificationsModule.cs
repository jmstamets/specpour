using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.BuildingBlocks.Events;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Notifications.Contracts;
using SpecPour.Modules.Notifications.Infrastructure.Email;

namespace SpecPour.Modules.Notifications.Infrastructure;

/// <summary>Composition root for the notifications thin slice (T023).</summary>
public sealed class NotificationsModule : IModule
{
    public string Name => "Notifications";
    public string? SchemaName => ModuleSchemas.Notifications;

    public void RegisterServices(IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetSpecPourConnectionString();

        // T155: the outbox interceptor must be attached here (not merely
        // DI-registered) for OutboxSaveChangesInterceptor to actually run — a
        // gap discovered while wiring T155's ingredient-rename event (the first
        // real outbox producer/consumer in the codebase). Fixed identically
        // across every module for consistency.
        services.AddDbContext<NotificationsDbContext>((sp, options) =>
        {
            options.UseNpgsql(connectionString);
            options.AddInterceptors(sp.GetRequiredService<OutboxSaveChangesInterceptor>());
        });
        services.AddSpecPourOutboxWriter(Name);

        // T146: the real adapter — LoggingEmailChannelAdapter is now test-only
        // (SpecPourWebApplicationFactory/ComposedHostFixture override back to it, the
        // same way they swap IClock, so the shared acceptance/contract hosts don't
        // need a reachable SMTP server just to boot).
        services.Configure<SmtpEmailOptions>(configuration.GetSection("Email:Smtp"));
        services.AddScoped<IEmailChannelAdapter, SmtpEmailChannelAdapter>();

        // Open-generic registration: resolves for any concrete TEvent that satisfies
        // NotificationEventConsumer<TEvent>'s "where TEvent : INotificationEvent"
        // constraint, and only those — a future event type that does NOT implement
        // INotificationEvent simply never matches this registration.
        services.AddScoped(typeof(IDomainEventHandler<>), typeof(NotificationEventConsumer<>));
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        InboxEndpoint.Map(endpoints);
        InboxReadEndpoint.Map(endpoints);
        ChannelPreferencesEndpoint.Map(endpoints);
    }
}
