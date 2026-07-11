using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Measurements.Domain;

namespace SpecPour.Modules.Measurements.Infrastructure;

/// <summary>The measurements module's DbContext (data-model.md "measurements" schema, T024).</summary>
public sealed class MeasurementsDbContext(DbContextOptions<MeasurementsDbContext> options) : DbContext(options)
{
    /// <summary>The seed convention table's version — bumped by curators adding a new version row, never by editing this one.</summary>
    public const int InitialConventionTableVersion = 1;

    public DbSet<ConventionTable> ConventionTables => Set<ConventionTable>();
    public DbSet<UnitEquivalence> UnitEquivalences => Set<UnitEquivalence>();
    public DbSet<MethodDilution> MethodDilutions => Set<MethodDilution>();
    public DbSet<StandardDrinkGramValue> StandardDrinkGramValues => Set<StandardDrinkGramValue>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(ModuleSchemas.Measurements);

        var seedEffectiveAt = new DateTimeOffset(2026, 1, 1, 0, 0, 0, TimeSpan.Zero);

        modelBuilder.Entity<ConventionTable>(entity =>
        {
            entity.HasKey(c => c.Version);
            entity.HasData(new ConventionTable
            {
                Version = InitialConventionTableVersion,
                EffectiveAt = seedEffectiveAt,
                Effective = true,
                Notes = "R14 seed values: dash/barspoon ml equivalences, stirred/shaken/built dilution midpoints, default standard-drink grams. Curator-adjustable via a new version row.",
            });
        });

        modelBuilder.Entity<UnitEquivalence>(entity =>
        {
            entity.HasKey(u => new { u.ConventionTableVersion, u.UnitKey });
            entity.HasData(
                new UnitEquivalence { ConventionTableVersion = InitialConventionTableVersion, UnitKey = "dash", MilliliterValue = 0.92m },
                new UnitEquivalence { ConventionTableVersion = InitialConventionTableVersion, UnitKey = "barspoon", MilliliterValue = 5m });
        });

        modelBuilder.Entity<MethodDilution>(entity =>
        {
            entity.HasKey(d => new { d.ConventionTableVersion, d.MethodKey });
            entity.HasData(
                new MethodDilution { ConventionTableVersion = InitialConventionTableVersion, MethodKey = "stirred", DilutionPercentage = 0.225m, MinPercentage = 0.20m, MaxPercentage = 0.25m },
                new MethodDilution { ConventionTableVersion = InitialConventionTableVersion, MethodKey = "shaken", DilutionPercentage = 0.275m, MinPercentage = 0.25m, MaxPercentage = 0.30m },
                new MethodDilution { ConventionTableVersion = InitialConventionTableVersion, MethodKey = "built", DilutionPercentage = 0m, MinPercentage = 0m, MaxPercentage = 0m });
        });

        modelBuilder.Entity<StandardDrinkGramValue>(entity =>
        {
            entity.HasKey(s => new { s.ConventionTableVersion, s.JurisdictionCode });
            entity.HasData(new StandardDrinkGramValue
            {
                ConventionTableVersion = InitialConventionTableVersion,
                JurisdictionCode = StandardDrinkGramValue.DefaultJurisdictionCode,
                GramsPerStandardDrink = 14m,
            });
        });

        modelBuilder.ConfigureOutbox(ownsTable: false);
    }
}
