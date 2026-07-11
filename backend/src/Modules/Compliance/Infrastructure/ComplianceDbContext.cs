using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Compliance.Domain;

namespace SpecPour.Modules.Compliance.Infrastructure;

/// <summary>The compliance module's DbContext (data-model.md "compliance" schema, T020).</summary>
public sealed class ComplianceDbContext(DbContextOptions<ComplianceDbContext> options) : DbContext(options)
{
    public DbSet<SurfaceGateConfig> SurfaceGateConfigs => Set<SurfaceGateConfig>();
    public DbSet<JurisdictionRule> JurisdictionRules => Set<JurisdictionRule>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(ModuleSchemas.Compliance);

        modelBuilder.Entity<SurfaceGateConfig>(entity =>
        {
            entity.HasKey(c => c.SurfaceKey);
            // No rows seeded: surface keys are declared by the feature that gates
            // them (e.g. T144's registration surface), not by this foundational module.
        });

        modelBuilder.Entity<JurisdictionRule>(entity =>
        {
            entity.HasKey(r => r.JurisdictionCode);

            // The strictest-rule fallback (R13) must exist from day one — real
            // per-jurisdiction legal-counsel-supplied rows land via the Seeder/an
            // admin console, not fabricated here. 21 is the strictest common legal
            // drinking age across V1's expected launch markets.
            entity.HasData(new JurisdictionRule
            {
                JurisdictionCode = Domain.JurisdictionRule.DefaultCode,
                LegalDrinkingAge = 21,
                Source = "Operator-configured strictest-rule default pending per-jurisdiction legal review",
                EffectiveAt = new DateTimeOffset(2026, 1, 1, 0, 0, 0, TimeSpan.Zero),
            });
        });

        modelBuilder.ConfigureOutbox(ownsTable: false);
    }
}
