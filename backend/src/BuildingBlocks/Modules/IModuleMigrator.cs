namespace SpecPour.BuildingBlocks.Modules;

/// <summary>
/// Deploy-time migration seam for a module (constitution Principle III: forward-only,
/// per-module migrations applied by a migration runner job, never at app start in
/// production). Implemented by each module's Infrastructure project once it owns a
/// DbContext, and driven in order by MigrationRunner (T012) after the base migration
/// (T013) has created the module's schema.
/// </summary>
public interface IModuleMigrator
{
    /// <summary>Stable module name, matching <see cref="IModule.Name"/>.</summary>
    string ModuleName { get; }

    /// <summary>Applies this module's pending EF Core migrations.</summary>
    Task MigrateAsync(string connectionString, CancellationToken cancellationToken);
}
