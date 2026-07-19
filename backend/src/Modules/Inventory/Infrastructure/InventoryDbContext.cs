using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Inventory.Infrastructure;

/// <summary>The inventory module's DbContext (data-model.md "inventory" schema, T066).</summary>
public sealed class InventoryDbContext(DbContextOptions<InventoryDbContext> options) : DbContext(options)
{
    public DbSet<Domain.InventoryItem> InventoryItems => Set<Domain.InventoryItem>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(ModuleSchemas.Inventory);

        modelBuilder.Entity<Domain.InventoryItem>(entity =>
        {
            entity.HasKey(i => i.Id);
            entity.HasIndex(i => new { i.OwnerType, i.OwnerId });
        });

        modelBuilder.ConfigureOutbox(ownsTable: false);
    }
}
