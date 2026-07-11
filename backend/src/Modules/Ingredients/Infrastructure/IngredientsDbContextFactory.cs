using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace SpecPour.Modules.Ingredients.Infrastructure;

/// <summary>Design-time factory for `dotnet ef migrations add` (see AuthorizationDbContextFactory for the same pattern).</summary>
public sealed class IngredientsDbContextFactory : IDesignTimeDbContextFactory<IngredientsDbContext>
{
    public IngredientsDbContext CreateDbContext(string[] args)
    {
        var connectionString = Environment.GetEnvironmentVariable("ConnectionStrings__Postgres")
            ?? "Host=localhost;Port=5432;Database=specpour;Username=specpour;Password=specpour_dev_only";

        var optionsBuilder = new DbContextOptionsBuilder<IngredientsDbContext>()
            .UseNpgsql(connectionString);

        return new IngredientsDbContext(optionsBuilder.Options);
    }
}
