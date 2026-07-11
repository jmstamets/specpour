using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Sync;

namespace SpecPour.Tools.MigrationRunner.Persistence;

/// <summary>
/// T013's base migration owner: creates the PostGIS extension, all 18 module schemas
/// (empty — each module's own migrations, applied after this one, add their tables into
/// their pre-created schema), and the two BuildingBlocks-owned cross-cutting tables
/// (outbox, sync change log). Always migrated first by MigrationRunner's Program.cs,
/// before any module migrator runs.
///
/// The 18 module <c>CREATE SCHEMA</c> statements and the PostGIS extension are not
/// derivable from this context's model (EF has no "empty schema" entity to hang them
/// off), so they are hand-added to the generated InitialBase migration's Up()/Down()
/// — see Migrations/&lt;timestamp&gt;_InitialBase.cs.
/// </summary>
public sealed class SpecPourBaseDbContext(DbContextOptions<SpecPourBaseDbContext> options) : DbContext(options)
{
    public DbSet<OutboxMessage> OutboxMessages => Set<OutboxMessage>();
    public DbSet<SyncChange> SyncChanges => Set<SyncChange>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasPostgresExtension("postgis");

        modelBuilder.ConfigureOutbox(ownsTable: true);
        modelBuilder.ConfigureSyncChangeLog(ownsTable: true);
    }
}
