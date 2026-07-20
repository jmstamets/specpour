using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Ai.Infrastructure;

/// <summary>The AI module's DbContext (data-model.md "ai" schema, T068) — the prompt registry, never prompt template text itself.</summary>
public sealed class AiDbContext(DbContextOptions<AiDbContext> options) : DbContext(options)
{
    public DbSet<Domain.PromptVersion> PromptVersions => Set<Domain.PromptVersion>();

    public DbSet<Domain.PromptEvalResult> PromptEvalResults => Set<Domain.PromptEvalResult>();

    public static class SeedIds
    {
        /// <summary>The default "inventory.recognize" prompt version — Provider/Model "unconfigured"/"none" until a real vision provider is wired (a later, credentialed task).</summary>
        public static readonly Guid InventoryRecognizeDefault = new("a0000000-0000-0000-0000-000000000001");
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(ModuleSchemas.Ai);

        modelBuilder.Entity<Domain.PromptVersion>(entity =>
        {
            entity.HasKey(p => p.Id);
            entity.HasIndex(p => new { p.FeatureKey, p.Version }).IsUnique();

            // T068: a default row for "inventory.recognize" present from day one, so
            // T069's ILabelRecognitionPort has something to look up and T147's eval
            // harness has a real PromptVersionId to record results against — real
            // provider-backed rows (Provider != "unconfigured") land once real
            // vision-provider credentials exist, not fabricated here.
            entity.HasData(new Domain.PromptVersion
            {
                Id = SeedIds.InventoryRecognizeDefault,
                FeatureKey = "inventory.recognize",
                Version = "v1",
                Provider = "unconfigured",
                Model = "none",
                Enabled = true,
                CreatedAt = new DateTimeOffset(2026, 1, 1, 0, 0, 0, TimeSpan.Zero),
            });
        });

        modelBuilder.Entity<Domain.PromptEvalResult>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.PromptVersionId);
        });

        modelBuilder.ConfigureOutbox(ownsTable: false);
    }
}
