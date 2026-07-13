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
    public DbSet<ResponsibleConsumptionMessage> ResponsibleConsumptionMessages => Set<ResponsibleConsumptionMessage>();
    public DbSet<SupportResource> SupportResources => Set<SupportResource>();

    /// <summary>Fixed seed IDs (T150) — stable across environments, same convention as the JurisdictionRule default row.</summary>
    public static class SeedIds
    {
        public static readonly Guid RecipeMessage = new("00000000-0000-0000-0000-000000000401");
        public static readonly Guid BatchOutputMessage = new("00000000-0000-0000-0000-000000000402");
        public static readonly Guid FooterAboutMessage = new("00000000-0000-0000-0000-000000000403");
        public static readonly Guid DefaultSupportResource = new("00000000-0000-0000-0000-000000000411");
    }

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

        var seedEffectiveAt = new DateTimeOffset(2026, 1, 1, 0, 0, 0, TimeSpan.Zero);

        modelBuilder.Entity<ResponsibleConsumptionMessage>(entity =>
        {
            entity.HasKey(m => m.Id);
            entity.HasIndex(m => new { m.JurisdictionCode, m.SurfaceClass }).IsUnique();

            // FR-067: a default (strictest-rule-style fallback) message per surface
            // class present from day one. Content keys are i18n keys resolved
            // client-side (never hard-coded copy) — real per-jurisdiction,
            // counsel-reviewed rows land via the Seeder/an admin console, not here.
            entity.HasData(
                new ResponsibleConsumptionMessage { Id = SeedIds.RecipeMessage, JurisdictionCode = ResponsibleConsumptionMessage.DefaultCode, SurfaceClass = "recipe", PlacementDescriptor = "below-content", MessageContentKey = "responsibleUse.message.default", EffectiveAt = seedEffectiveAt },
                new ResponsibleConsumptionMessage { Id = SeedIds.BatchOutputMessage, JurisdictionCode = ResponsibleConsumptionMessage.DefaultCode, SurfaceClass = "batch_output", PlacementDescriptor = "below-content", MessageContentKey = "responsibleUse.message.default", EffectiveAt = seedEffectiveAt },
                new ResponsibleConsumptionMessage { Id = SeedIds.FooterAboutMessage, JurisdictionCode = ResponsibleConsumptionMessage.DefaultCode, SurfaceClass = "footer_about", PlacementDescriptor = "footer", MessageContentKey = "responsibleUse.message.default", EffectiveAt = seedEffectiveAt });
        });

        modelBuilder.Entity<SupportResource>(entity =>
        {
            entity.HasKey(r => r.Id);
            entity.HasIndex(r => new { r.JurisdictionCode, r.DisplayOrder });

            // FR-069: a default support resource present from day one. Real
            // jurisdiction-specific helplines are configuration-driven, added per
            // launch market — not fabricated here beyond a generic placeholder.
            entity.HasData(new SupportResource
            {
                Id = SeedIds.DefaultSupportResource,
                JurisdictionCode = ResponsibleConsumptionMessage.DefaultCode,
                ResourceName = "International drug and alcohol support directory",
                Link = "https://www.who.int/health-topics/alcohol",
                DisplayOrder = 1,
                EffectiveAt = seedEffectiveAt,
            });
        });

        modelBuilder.ConfigureOutbox(ownsTable: false);
    }
}
