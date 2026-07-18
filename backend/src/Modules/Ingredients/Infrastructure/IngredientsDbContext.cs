using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Ingredients.Domain;

namespace SpecPour.Modules.Ingredients.Infrastructure;

/// <summary>The ingredients module's DbContext (data-model.md "ingredients" schema, T033).</summary>
public sealed class IngredientsDbContext(DbContextOptions<IngredientsDbContext> options) : DbContext(options)
{
    public DbSet<Ingredient> Ingredients => Set<Ingredient>();
    public DbSet<IngredientCategory> IngredientCategories => Set<IngredientCategory>();
    public DbSet<Allergen> Allergens => Set<Allergen>();
    public DbSet<IngredientAllergen> IngredientAllergens => Set<IngredientAllergen>();
    public DbSet<SubstitutionRule> SubstitutionRules => Set<SubstitutionRule>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(ModuleSchemas.Ingredients);

        modelBuilder.Entity<Ingredient>(entity =>
        {
            entity.HasKey(i => i.Id);
            entity.HasIndex(i => i.Name);
            entity.HasIndex(i => i.OwnerId);
            entity.HasIndex(i => i.ParentId);
            entity.HasOne<IngredientCategory>().WithMany().HasForeignKey(i => i.CategoryId).OnDelete(DeleteBehavior.Restrict);
            entity.HasOne<Ingredient>().WithMany().HasForeignKey(i => i.ParentId).OnDelete(DeleteBehavior.Restrict);
            // DefiningRecipeId crosses into the `catalog` schema — no FK (ADR-0001).

            // Search (FR-049) — a single plain source column, so (unlike Catalog's
            // Recipe.AlternateNames) TsVectorMigrationExtensions.AddGeneratedTsVectorColumn
            // applies directly. Modeled here as a shadow property purely so EF's
            // model snapshot knows the column exists (same reasoning as
            // CatalogDbContext.Recipe.SearchVector).
            entity.Property<NpgsqlTypes.NpgsqlTsVector>("SearchVector")
                .HasComputedColumnSql(
                    "specpour_immutable_to_tsvector_english(coalesce(\"Name\", ''))",
                    stored: true);
        });

        modelBuilder.Entity<IngredientCategory>(entity =>
        {
            entity.HasKey(c => c.Id);
            entity.HasIndex(c => c.NameKey).IsUnique();

            // T059: one fixed system fallback category for personal-library ingredient
            // authoring — the create request doesn't require the author to pick a
            // category (data-model.md's category_id is "curator-extensible," not a
            // structure John's ATDD scenarios ask the author to navigate at V1). All
            // other categories remain curator-authored content (T040's seed pack).
            entity.HasData(new IngredientCategory
            {
                Id = IngredientsDbContextSeedIds.UncategorizedCategory,
                NameKey = "category.uncategorized",
                Definition = "Fallback category for personal-library ingredients created without an explicit category.",
            });
        });

        modelBuilder.Entity<Allergen>(entity =>
        {
            entity.HasKey(a => a.Id);
            entity.HasIndex(a => a.Key).IsUnique();

            // FR-016's named starter vocabulary ("egg, dairy, nuts, sulfites, gluten,
            // etc.") — curator-extensible from here, same convention as Catalog.Family.
            entity.HasData(
                new Allergen { Id = IngredientsDbContextSeedIds.EggAllergen, Key = "egg", DisplayNameKey = "allergen.egg" },
                new Allergen { Id = IngredientsDbContextSeedIds.DairyAllergen, Key = "dairy", DisplayNameKey = "allergen.dairy" },
                new Allergen { Id = IngredientsDbContextSeedIds.TreeNutAllergen, Key = "treeNut", DisplayNameKey = "allergen.treeNut" },
                new Allergen { Id = IngredientsDbContextSeedIds.PeanutAllergen, Key = "peanut", DisplayNameKey = "allergen.peanut" },
                new Allergen { Id = IngredientsDbContextSeedIds.GlutenAllergen, Key = "gluten", DisplayNameKey = "allergen.gluten" },
                new Allergen { Id = IngredientsDbContextSeedIds.SulfitesAllergen, Key = "sulfites", DisplayNameKey = "allergen.sulfites" });
        });

        modelBuilder.Entity<IngredientAllergen>(entity =>
        {
            entity.HasKey(a => new { a.IngredientId, a.AllergenId });
            entity.HasOne<Ingredient>().WithMany().HasForeignKey(a => a.IngredientId).OnDelete(DeleteBehavior.Cascade);
            entity.HasOne<Allergen>().WithMany().HasForeignKey(a => a.AllergenId).OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<SubstitutionRule>(entity =>
        {
            entity.HasKey(s => s.Id);
            entity.HasIndex(s => new { s.FromIngredientId, s.ToIngredientId }).IsUnique();
            entity.HasOne<Ingredient>().WithMany().HasForeignKey(s => s.FromIngredientId).OnDelete(DeleteBehavior.Cascade);
            entity.HasOne<Ingredient>().WithMany().HasForeignKey(s => s.ToIngredientId).OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.ConfigureOutbox(ownsTable: false);
    }
}

/// <summary>Fixed seed IDs (T033) — stable across environments, same convention as AuthorizationDbContext.SeedIds.</summary>
public static class IngredientsDbContextSeedIds
{
    public static readonly Guid EggAllergen = new("00000000-0000-0000-0000-000000000201");
    public static readonly Guid DairyAllergen = new("00000000-0000-0000-0000-000000000202");
    public static readonly Guid TreeNutAllergen = new("00000000-0000-0000-0000-000000000203");
    public static readonly Guid PeanutAllergen = new("00000000-0000-0000-0000-000000000204");
    public static readonly Guid GlutenAllergen = new("00000000-0000-0000-0000-000000000205");
    public static readonly Guid SulfitesAllergen = new("00000000-0000-0000-0000-000000000206");
    public static readonly Guid UncategorizedCategory = new("00000000-0000-0000-0000-000000000207");
}
