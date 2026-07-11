using Microsoft.EntityFrameworkCore;
using NpgsqlTypes;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Glossary.Domain;

namespace SpecPour.Modules.Glossary.Infrastructure;

/// <summary>The glossary module's DbContext (data-model.md "glossary" schema, T035).</summary>
public sealed class GlossaryDbContext(DbContextOptions<GlossaryDbContext> options) : DbContext(options)
{
    public DbSet<GlossaryTerm> GlossaryTerms => Set<GlossaryTerm>();
    public DbSet<GlossaryTermContentLink> GlossaryTermContentLinks => Set<GlossaryTermContentLink>();
    public DbSet<Article> Articles => Set<Article>();
    public DbSet<ArticleTermLink> ArticleTermLinks => Set<ArticleTermLink>();
    public DbSet<ArticleContentLink> ArticleContentLinks => Set<ArticleContentLink>();
    public DbSet<LinkOverride> LinkOverrides => Set<LinkOverride>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(ModuleSchemas.Glossary);

        modelBuilder.Entity<GlossaryTerm>(entity =>
        {
            entity.HasKey(t => t.Id);
            entity.HasIndex(t => t.Term).IsUnique();

            // Search (FR-049) — Term plus every Definitions entry (a text[] column),
            // same two-function pattern as Catalog.Recipe.SearchVector.
            entity.Property<NpgsqlTsVector>("SearchVector")
                .HasComputedColumnSql(
                    "specpour_immutable_to_tsvector_english(coalesce(\"Term\", '') || ' ' || coalesce(specpour_immutable_array_to_string(\"Definitions\", ' '), ''))",
                    stored: true);
        });

        modelBuilder.Entity<GlossaryTermContentLink>(entity =>
        {
            entity.HasKey(l => l.Id);
            entity.HasIndex(l => new { l.GlossaryTermId, l.ContentType, l.ContentId }).IsUnique();
            entity.HasOne<GlossaryTerm>().WithMany().HasForeignKey(l => l.GlossaryTermId).OnDelete(DeleteBehavior.Cascade);
            // ContentId crosses into another module's schema — no FK (ADR-0001).
            entity.HasIndex(l => new { l.ContentType, l.ContentId });
        });

        modelBuilder.Entity<Article>(entity =>
        {
            entity.HasKey(a => a.Id);
            entity.HasIndex(a => a.Title);

            // Search (FR-049) — Title + Body are both plain text columns.
            entity.Property<NpgsqlTsVector>("SearchVector")
                .HasComputedColumnSql(
                    "specpour_immutable_to_tsvector_english(coalesce(\"Title\", '') || ' ' || coalesce(\"Body\", ''))",
                    stored: true);
        });

        modelBuilder.Entity<ArticleTermLink>(entity =>
        {
            entity.HasKey(l => new { l.ArticleId, l.GlossaryTermId });
            entity.HasOne<Article>().WithMany().HasForeignKey(l => l.ArticleId).OnDelete(DeleteBehavior.Cascade);
            entity.HasOne<GlossaryTerm>().WithMany().HasForeignKey(l => l.GlossaryTermId).OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<ArticleContentLink>(entity =>
        {
            entity.HasKey(l => l.Id);
            entity.HasIndex(l => new { l.ArticleId, l.ContentType, l.ContentId }).IsUnique();
            entity.HasOne<Article>().WithMany().HasForeignKey(l => l.ArticleId).OnDelete(DeleteBehavior.Cascade);
            // ContentId crosses into another module's schema — no FK (ADR-0001).
            entity.HasIndex(l => new { l.ContentType, l.ContentId });
        });

        modelBuilder.Entity<LinkOverride>(entity =>
        {
            entity.HasKey(o => o.Id);
            entity.HasIndex(o => new { o.Context, o.TermId }).IsUnique();
            entity.HasOne<GlossaryTerm>().WithMany().HasForeignKey(o => o.TermId).OnDelete(DeleteBehavior.Cascade);
        });

        modelBuilder.ConfigureOutbox(ownsTable: false);
    }
}
