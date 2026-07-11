using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace SpecPour.Modules.Glossary.Infrastructure;

/// <summary>Design-time factory for `dotnet ef migrations add` (see AuthorizationDbContextFactory for the same pattern).</summary>
public sealed class GlossaryDbContextFactory : IDesignTimeDbContextFactory<GlossaryDbContext>
{
    public GlossaryDbContext CreateDbContext(string[] args)
    {
        var connectionString = Environment.GetEnvironmentVariable("ConnectionStrings__Postgres")
            ?? "Host=localhost;Port=5432;Database=specpour;Username=specpour;Password=specpour_dev_only";

        var optionsBuilder = new DbContextOptionsBuilder<GlossaryDbContext>()
            .UseNpgsql(connectionString);

        return new GlossaryDbContext(optionsBuilder.Options);
    }
}
