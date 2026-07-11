using Microsoft.EntityFrameworkCore;

namespace SpecPour.BuildingBlocks.Sync;

public static class SyncModelBuilderExtensions
{
    public const string SchemaName = "sync";
    public const string TableName = "sync_change";

    /// <summary>Maps <see cref="SyncChange"/> onto the shared <c>sync.sync_change</c> table (see remarks on ConfigureOutbox for the ownsTable convention).</summary>
    public static ModelBuilder ConfigureSyncChangeLog(this ModelBuilder builder, bool ownsTable)
    {
        builder.Entity<SyncChange>(entity =>
        {
            entity.ToTable(TableName, SchemaName, table =>
            {
                if (!ownsTable)
                {
                    table.ExcludeFromMigrations();
                }
            });

            entity.HasKey(c => c.Cursor);
            entity.Property(c => c.Cursor).UseIdentityAlwaysColumn();
            entity.Property(c => c.EntityType).IsRequired();
            entity.HasIndex(c => new { c.EntityType, c.EntityId });
        });

        return builder;
    }
}
