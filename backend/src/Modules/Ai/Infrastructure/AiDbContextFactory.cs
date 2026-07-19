using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace SpecPour.Modules.Ai.Infrastructure;

/// <summary>Design-time factory for `dotnet ef migrations add` (see VenuesDbContextFactory for the same pattern).</summary>
public sealed class AiDbContextFactory : IDesignTimeDbContextFactory<AiDbContext>
{
    public AiDbContext CreateDbContext(string[] args)
    {
        var connectionString = Environment.GetEnvironmentVariable("ConnectionStrings__Postgres")
            ?? "Host=localhost;Port=5432;Database=specpour;Username=specpour;Password=specpour_dev_only";

        var optionsBuilder = new DbContextOptionsBuilder<AiDbContext>()
            .UseNpgsql(connectionString);

        return new AiDbContext(optionsBuilder.Options);
    }
}
