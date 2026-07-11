using Microsoft.EntityFrameworkCore;

namespace SpecPour.BuildingBlocks.Events.Outbox;

/// <summary>
/// Minimal DbContext over the shared outbox table, used only by
/// <see cref="OutboxDispatcherBackgroundService"/> to poll and mark messages processed.
/// It does not own the table's DDL (the base migration, T013, does) and is separate
/// from every module's own DbContext.
/// </summary>
public sealed class OutboxDbContext(DbContextOptions<OutboxDbContext> options) : DbContext(options)
{
    public DbSet<OutboxMessage> OutboxMessages => Set<OutboxMessage>();

    protected override void OnModelCreating(ModelBuilder modelBuilder) =>
        modelBuilder.ConfigureOutbox(ownsTable: false);
}
