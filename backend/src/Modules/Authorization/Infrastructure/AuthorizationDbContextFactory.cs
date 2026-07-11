using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace SpecPour.Modules.Authorization.Infrastructure;

/// <summary>Design-time factory for `dotnet ef migrations add` (see IdentityDbContextFactory for the same pattern).</summary>
public sealed class AuthorizationDbContextFactory : IDesignTimeDbContextFactory<AuthorizationDbContext>
{
    public AuthorizationDbContext CreateDbContext(string[] args)
    {
        var connectionString = Environment.GetEnvironmentVariable("ConnectionStrings__Postgres")
            ?? "Host=localhost;Port=5432;Database=specpour;Username=specpour;Password=specpour_dev_only";

        var optionsBuilder = new DbContextOptionsBuilder<AuthorizationDbContext>()
            .UseNpgsql(connectionString);

        return new AuthorizationDbContext(optionsBuilder.Options);
    }
}
