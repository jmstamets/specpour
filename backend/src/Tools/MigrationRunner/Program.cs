using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Tools.MigrationRunner.Persistence;

// Deploy-time migration job (constitution Principle III / research R3: forward-only,
// never applied at app start in production). Order matters: the base migration must
// run first so every module schema, the PostGIS extension, and the outbox/sync tables
// exist before any module's own migrations try to add tables into their schema.

var configuration = new ConfigurationBuilder()
    .AddJsonFile("appsettings.json", optional: true)
    .AddEnvironmentVariables()
    .Build();

var connectionString = configuration.GetConnectionString("Postgres")
    ?? Environment.GetEnvironmentVariable("ConnectionStrings__Postgres")
    ?? throw new InvalidOperationException(
        "No Postgres connection string configured (ConnectionStrings:Postgres / ConnectionStrings__Postgres).");

Console.WriteLine("SpecPour MigrationRunner");

Console.WriteLine("Applying base migration (schemas, PostGIS, outbox, sync change log)...");
var baseOptions = new DbContextOptionsBuilder<SpecPourBaseDbContext>()
    .UseNpgsql(connectionString)
    .Options;
await using (var baseContext = new SpecPourBaseDbContext(baseOptions))
{
    await baseContext.Database.MigrateAsync();
}
Console.WriteLine("Base migration applied.");

// Module migrators are registered here as each module's Infrastructure project lands
// its own DbContext + migrations (T016 Identity onward). Applied in this fixed order
// — not alphabetical, not discovery-based — so dependency direction between module
// schemas (e.g. nothing before Identity) stays an explicit, reviewable decision rather
// than an accident of assembly-scan ordering.
IModuleMigrator[] moduleMigrators =
[
    // new IdentityModuleMigrator(),      // T016
    // new AuthorizationModuleMigrator(), // T018
    // ...
];

foreach (var migrator in moduleMigrators)
{
    Console.WriteLine($"Applying {migrator.ModuleName} module migrations...");
    await migrator.MigrateAsync(connectionString, CancellationToken.None);
    Console.WriteLine($"{migrator.ModuleName} module migrations applied.");
}

Console.WriteLine("All migrations applied.");
