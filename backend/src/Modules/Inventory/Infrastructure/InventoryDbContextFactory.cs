using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace SpecPour.Modules.Inventory.Infrastructure;

/// <summary>Design-time factory for `dotnet ef migrations add` (see VenuesDbContextFactory for the same pattern).</summary>
public sealed class InventoryDbContextFactory : IDesignTimeDbContextFactory<InventoryDbContext>
{
    public InventoryDbContext CreateDbContext(string[] args)
    {
        var connectionString = Environment.GetEnvironmentVariable("ConnectionStrings__Postgres")
            ?? "Host=localhost;Port=5432;Database=specpour;Username=specpour;Password=specpour_dev_only";

        var optionsBuilder = new DbContextOptionsBuilder<InventoryDbContext>()
            .UseNpgsql(connectionString);

        return new InventoryDbContext(optionsBuilder.Options);
    }
}
