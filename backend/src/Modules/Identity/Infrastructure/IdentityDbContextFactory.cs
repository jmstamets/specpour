using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace SpecPour.Modules.Identity.Infrastructure;

/// <summary>Design-time factory for `dotnet ef migrations add` (see MigrationRunner's SpecPourBaseDbContextFactory for the same pattern).</summary>
public sealed class IdentityDbContextFactory : IDesignTimeDbContextFactory<IdentityDbContext>
{
    public IdentityDbContext CreateDbContext(string[] args)
    {
        var connectionString = Environment.GetEnvironmentVariable("ConnectionStrings__Postgres")
            ?? "Host=localhost;Port=5432;Database=specpour;Username=specpour;Password=specpour_dev_only";

        var optionsBuilder = new DbContextOptionsBuilder<IdentityDbContext>()
            .UseNpgsql(connectionString);

        return new IdentityDbContext(optionsBuilder.Options);
    }
}
