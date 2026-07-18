using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Venues.Infrastructure;

/// <summary>The venues module's DbContext (data-model.md "venues" schema, T061).</summary>
public sealed class VenuesDbContext(DbContextOptions<VenuesDbContext> options) : DbContext(options)
{
    public DbSet<Domain.Venue> Venues => Set<Domain.Venue>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(ModuleSchemas.Venues);

        modelBuilder.Entity<Domain.Venue>(entity =>
        {
            entity.HasKey(v => v.Id);
            entity.HasIndex(v => v.OwnerUserId);

            // T061: FR-058's own wording — the point is stored, unused by any V1
            // feature. No spatial index yet (GiST on Location); add one when a real
            // proximity/geo query lands, not speculatively ahead of one.
            entity.Property(v => v.Location).HasColumnType("geometry (point, 4326)");
        });

        modelBuilder.ConfigureOutbox(ownsTable: false);
    }
}
