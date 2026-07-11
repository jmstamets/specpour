using Microsoft.EntityFrameworkCore;

namespace SpecPour.BuildingBlocks.Events.Outbox;

public static class OutboxModelBuilderExtensions
{
    public const string SchemaName = "outbox";
    public const string TableName = "outbox_messages";

    /// <summary>
    /// Maps <see cref="OutboxMessage"/> onto the shared <c>outbox.outbox_messages</c> table.
    /// </summary>
    /// <param name="builder">The DbContext's model builder.</param>
    /// <param name="ownsTable">
    /// True only for the base/migration DbContext (T013's SpecPourBaseDbContext), which
    /// owns the table's DDL. Every module DbContext maps the same physical table with
    /// <paramref name="ownsTable"/> false (<c>ExcludeFromMigrations</c>) so its own
    /// per-module migrations never try to create or alter a table another module also
    /// writes rows into — the write path (SaveChanges via the interceptor) still works
    /// because it is the same physical table.
    /// </param>
    public static ModelBuilder ConfigureOutbox(this ModelBuilder builder, bool ownsTable)
    {
        builder.Entity<OutboxMessage>(entity =>
        {
            entity.ToTable(TableName, SchemaName, table =>
            {
                if (!ownsTable)
                {
                    table.ExcludeFromMigrations();
                }
            });

            entity.HasKey(m => m.Id);
            entity.Property(m => m.EventType).IsRequired();
            entity.Property(m => m.PayloadJson).IsRequired().HasColumnType("jsonb");
            entity.Property(m => m.SourceModule).IsRequired();
            entity.HasIndex(m => m.ProcessedAt);
        });

        return builder;
    }
}
