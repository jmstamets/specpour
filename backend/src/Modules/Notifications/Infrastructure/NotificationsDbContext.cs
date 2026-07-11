using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Notifications.Domain;

namespace SpecPour.Modules.Notifications.Infrastructure;

/// <summary>The notifications module's DbContext (data-model.md "notifications" schema, T023).</summary>
public sealed class NotificationsDbContext(DbContextOptions<NotificationsDbContext> options) : DbContext(options)
{
    public DbSet<InboxMessage> InboxMessages => Set<InboxMessage>();
    public DbSet<ChannelPreference> ChannelPreferences => Set<ChannelPreference>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(ModuleSchemas.Notifications);

        modelBuilder.Entity<InboxMessage>(entity =>
        {
            entity.HasKey(m => m.Id);
            entity.HasIndex(m => new { m.UserId, m.CreatedAt });
        });

        modelBuilder.Entity<ChannelPreference>(entity =>
        {
            entity.HasKey(p => new { p.UserId, p.Channel });
        });

        modelBuilder.ConfigureOutbox(ownsTable: false);
    }
}
