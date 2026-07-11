using Microsoft.EntityFrameworkCore;
using NpgsqlTypes;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Catalog.Domain;

namespace SpecPour.Modules.Catalog.Infrastructure;

/// <summary>The catalog module's DbContext (data-model.md "catalog" schema, T032).</summary>
public sealed class CatalogDbContext(DbContextOptions<CatalogDbContext> options) : DbContext(options)
{
    /// <summary>Fixed seed IDs (T032) — stable across environments, same convention as AuthorizationDbContext.SeedIds.</summary>
    public static class SeedIds
    {
        public static readonly Guid CocktailFamily = new("00000000-0000-0000-0000-000000000101");
        public static readonly Guid SpiritForwardFamily = new("00000000-0000-0000-0000-000000000102");
        public static readonly Guid SourFamily = new("00000000-0000-0000-0000-000000000103");
        public static readonly Guid HighballFamily = new("00000000-0000-0000-0000-000000000104");
        public static readonly Guid CobblerFamily = new("00000000-0000-0000-0000-000000000105");
        public static readonly Guid JulepFamily = new("00000000-0000-0000-0000-000000000106");
        public static readonly Guid SmashFamily = new("00000000-0000-0000-0000-000000000107");
        public static readonly Guid FlipFamily = new("00000000-0000-0000-0000-000000000108");
        public static readonly Guid NogFamily = new("00000000-0000-0000-0000-000000000109");
    }

    public DbSet<Recipe> Recipes => Set<Recipe>();
    public DbSet<RecipeIngredientLine> RecipeIngredientLines => Set<RecipeIngredientLine>();
    public DbSet<RecipeRelation> RecipeRelations => Set<RecipeRelation>();
    public DbSet<ConceptPage> ConceptPages => Set<ConceptPage>();
    public DbSet<ConceptVariantLink> ConceptVariantLinks => Set<ConceptVariantLink>();
    public DbSet<Family> Families => Set<Family>();
    public DbSet<Category> Categories => Set<Category>();
    public DbSet<FlavorProfile> FlavorProfiles => Set<FlavorProfile>();
    public DbSet<Tag> Tags => Set<Tag>();
    public DbSet<RecipeCategory> RecipeCategories => Set<RecipeCategory>();
    public DbSet<RecipeFlavorProfile> RecipeFlavorProfiles => Set<RecipeFlavorProfile>();
    public DbSet<RecipeTag> RecipeTags => Set<RecipeTag>();
    public DbSet<RecipeGlassware> RecipeGlassware => Set<RecipeGlassware>();
    public DbSet<RecipeEquipment> RecipeEquipment => Set<RecipeEquipment>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(ModuleSchemas.Catalog);

        modelBuilder.Entity<Recipe>(entity =>
        {
            entity.HasKey(r => r.Id);
            entity.HasIndex(r => r.PrimaryName);
            entity.HasIndex(r => r.OwnerId);

            // Search registration (tsvector column, trigram index) is added by raw
            // SQL in the initial migration rather than TsVectorMigrationExtensions,
            // because FR-018 requires AlternateNames (a text[] column) to be
            // searchable too, and the shared helper only concatenates plain columns.
            // Modeled here as a DB-computed shadow property purely so EF's model
            // snapshot knows this column exists and never proposes dropping it in a
            // future migration diff — nothing in the app ever reads/writes it
            // through EF (PostgresFullTextSearchAdapter queries it via raw SQL).
            // to_tsvector('english', ...) directly, and array_to_string(...) on
            // AlternateNames, are both rejected by Postgres inside a GENERATED
            // STORED expression ("generation expression is not immutable") — routed
            // through the IMMUTABLE wrapper functions the migration creates
            // (TsVectorMigrationExtensions.EnsureImmutableToTsVectorFunction).
            entity.Property<NpgsqlTsVector>("SearchVector")
                .HasComputedColumnSql(
                    "specpour_immutable_to_tsvector_english(coalesce(\"PrimaryName\", '') || ' ' || coalesce(specpour_immutable_array_to_string(\"AlternateNames\", ' '), ''))",
                    stored: true);
        });

        modelBuilder.Entity<RecipeIngredientLine>(entity =>
        {
            entity.HasKey(l => l.Id);
            entity.HasIndex(l => new { l.RecipeId, l.Position }).IsUnique();
            entity.HasOne<Recipe>().WithMany().HasForeignKey(l => l.RecipeId).OnDelete(DeleteBehavior.Cascade);
        });

        modelBuilder.Entity<RecipeRelation>(entity =>
        {
            entity.HasKey(r => new { r.RecipeId, r.RelatedRecipeId });
            entity.HasOne<Recipe>().WithMany().HasForeignKey(r => r.RecipeId).OnDelete(DeleteBehavior.Cascade);
            entity.HasOne<Recipe>().WithMany().HasForeignKey(r => r.RelatedRecipeId).OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<ConceptPage>(entity =>
        {
            entity.HasKey(c => c.Id);
            entity.HasIndex(c => c.Name).IsUnique();
        });

        modelBuilder.Entity<ConceptVariantLink>(entity =>
        {
            entity.HasKey(l => l.Id);
            entity.HasIndex(l => new { l.ConceptId, l.RecipeId }).IsUnique();
            entity.HasOne<ConceptPage>().WithMany().HasForeignKey(l => l.ConceptId).OnDelete(DeleteBehavior.Cascade);
            entity.HasOne<Recipe>().WithMany().HasForeignKey(l => l.RecipeId).OnDelete(DeleteBehavior.Cascade);
        });

        modelBuilder.Entity<Family>(entity =>
        {
            entity.HasKey(f => f.Id);
            entity.HasIndex(f => f.NameKey).IsUnique();
            entity.HasOne<Family>().WithMany().HasForeignKey(f => f.ParentFamilyId).OnDelete(DeleteBehavior.Restrict);

            // FR-019's named starter taxonomy — curator-extensible from here (SC-011
            // style: new families/subtypes land by adding rows, never a release).
            entity.HasData(
                new Family { Id = SeedIds.CocktailFamily, NameKey = "family.cocktail", Definition = "The base cocktail family." },
                new Family { Id = SeedIds.SpiritForwardFamily, NameKey = "family.spiritForward", Definition = "Spirit-forward, stirred drinks." },
                new Family { Id = SeedIds.SourFamily, NameKey = "family.sour", Definition = "Spirit, citrus, sweetener." },
                new Family { Id = SeedIds.HighballFamily, NameKey = "family.highball", Definition = "Spirit lengthened with a mixer over ice." },
                new Family { Id = SeedIds.CobblerFamily, NameKey = "family.cobbler", Definition = "Wine or spirit, sugar, and fruit over crushed ice." },
                new Family { Id = SeedIds.JulepFamily, NameKey = "family.julep", Definition = "Cobbler subtype: spirit, sugar, and mint over crushed ice.", ParentFamilyId = SeedIds.CobblerFamily },
                new Family { Id = SeedIds.SmashFamily, NameKey = "family.smash", Definition = "Cobbler subtype: spirit, sugar, and muddled fruit/herbs over crushed ice.", ParentFamilyId = SeedIds.CobblerFamily },
                new Family { Id = SeedIds.FlipFamily, NameKey = "family.flip", Definition = "Spirit or wine, sugar, and a whole egg, shaken." },
                new Family { Id = SeedIds.NogFamily, NameKey = "family.nog", Definition = "Flip subtype: served over ice with milk or cream.", ParentFamilyId = SeedIds.FlipFamily });
        });

        modelBuilder.Entity<Category>(entity =>
        {
            entity.HasKey(c => c.Id);
            entity.HasIndex(c => c.NameKey).IsUnique();
            // No rows seeded here: FR-019's example list (buck, collins, fizz, ...) is
            // curator-authored content, not a fixed platform vocabulary like Family's
            // subtype hierarchy — T040's seed content pack supplies real rows.
        });

        modelBuilder.Entity<FlavorProfile>(entity =>
        {
            entity.HasKey(f => f.Id);
            entity.HasIndex(f => f.NameKey).IsUnique();
        });

        modelBuilder.Entity<Tag>(entity =>
        {
            entity.HasKey(t => t.Id);
            entity.HasIndex(t => t.Key).IsUnique();
        });

        modelBuilder.Entity<RecipeCategory>(entity =>
        {
            entity.HasKey(rc => new { rc.RecipeId, rc.CategoryId });
            entity.HasOne<Recipe>().WithMany().HasForeignKey(rc => rc.RecipeId).OnDelete(DeleteBehavior.Cascade);
            entity.HasOne<Category>().WithMany().HasForeignKey(rc => rc.CategoryId).OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<RecipeFlavorProfile>(entity =>
        {
            entity.HasKey(rf => new { rf.RecipeId, rf.FlavorProfileId });
            entity.HasOne<Recipe>().WithMany().HasForeignKey(rf => rf.RecipeId).OnDelete(DeleteBehavior.Cascade);
            entity.HasOne<FlavorProfile>().WithMany().HasForeignKey(rf => rf.FlavorProfileId).OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<RecipeTag>(entity =>
        {
            entity.HasKey(rt => new { rt.RecipeId, rt.TagId });
            entity.HasOne<Recipe>().WithMany().HasForeignKey(rt => rt.RecipeId).OnDelete(DeleteBehavior.Cascade);
            entity.HasOne<Tag>().WithMany().HasForeignKey(rt => rt.TagId).OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<RecipeGlassware>(entity =>
        {
            entity.HasKey(rg => new { rg.RecipeId, rg.EquipmentId });
            entity.HasOne<Recipe>().WithMany().HasForeignKey(rg => rg.RecipeId).OnDelete(DeleteBehavior.Cascade);
            // EquipmentId crosses into the `equipment` schema — no FK (ADR-0001).
            entity.HasIndex(rg => rg.EquipmentId);
        });

        modelBuilder.Entity<RecipeEquipment>(entity =>
        {
            entity.HasKey(re => new { re.RecipeId, re.EquipmentId });
            entity.HasOne<Recipe>().WithMany().HasForeignKey(re => re.RecipeId).OnDelete(DeleteBehavior.Cascade);
            entity.HasIndex(re => re.EquipmentId);
        });

        modelBuilder.ConfigureOutbox(ownsTable: false);
    }
}
