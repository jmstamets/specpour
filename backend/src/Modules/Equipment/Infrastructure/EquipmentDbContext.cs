using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Equipment.Infrastructure;

/// <summary>The equipment module's DbContext (data-model.md "equipment" schema, T034).</summary>
public sealed class EquipmentDbContext(DbContextOptions<EquipmentDbContext> options) : DbContext(options)
{
    public DbSet<Domain.Equipment> Equipment => Set<Domain.Equipment>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(ModuleSchemas.Equipment);

        modelBuilder.Entity<Domain.Equipment>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.Name);
            entity.HasIndex(e => e.OwnerId);

            // Search (FR-049) — single plain source column, same shadow-property
            // pattern as Ingredient.SearchVector.
            entity.Property<NpgsqlTypes.NpgsqlTsVector>("SearchVector")
                .HasComputedColumnSql(
                    "specpour_immutable_to_tsvector_english(coalesce(\"Name\", ''))",
                    stored: true);
        });

        modelBuilder.ConfigureOutbox(ownsTable: false);
    }
}
