using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace SpecPour.Tools.MigrationRunner.Persistence;

/// <summary>
/// Design-time factory so `dotnet ef migrations add` can construct <see cref="SpecPourBaseDbContext"/>
/// without running the tool's full Program.cs. The connection only needs to be valid
/// enough for EF to introspect the provider (Npgsql) — it does not need to succeed at
/// connecting when merely generating a migration.
/// </summary>
public sealed class SpecPourBaseDbContextFactory : IDesignTimeDbContextFactory<SpecPourBaseDbContext>
{
    public SpecPourBaseDbContext CreateDbContext(string[] args)
    {
        var connectionString = Environment.GetEnvironmentVariable("ConnectionStrings__Postgres")
            ?? "Host=localhost;Port=5432;Database=specpour;Username=specpour;Password=specpour_dev_only";

        var optionsBuilder = new DbContextOptionsBuilder<SpecPourBaseDbContext>()
            .UseNpgsql(connectionString);

        return new SpecPourBaseDbContext(optionsBuilder.Options);
    }
}
