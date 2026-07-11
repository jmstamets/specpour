using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Media.Domain;

namespace SpecPour.Modules.Media.Infrastructure;

/// <summary>The media module's DbContext (data-model.md "media" schema, T021).</summary>
public sealed class MediaDbContext(DbContextOptions<MediaDbContext> options) : DbContext(options)
{
    public DbSet<MediaAttachment> MediaAttachments => Set<MediaAttachment>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(ModuleSchemas.Media);

        modelBuilder.Entity<MediaAttachment>(entity =>
        {
            entity.HasKey(m => m.Id);
            entity.HasIndex(m => new { m.SubjectType, m.SubjectId });
        });

        modelBuilder.ConfigureOutbox(ownsTable: false);
    }
}
