using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace SpecPour.Modules.Venues.Infrastructure;

/// <summary>Design-time factory for `dotnet ef migrations add` (see EquipmentDbContextFactory for the same pattern).</summary>
public sealed class VenuesDbContextFactory : IDesignTimeDbContextFactory<VenuesDbContext>
{
    public VenuesDbContext CreateDbContext(string[] args)
    {
        var connectionString = Environment.GetEnvironmentVariable("ConnectionStrings__Postgres")
            ?? "Host=localhost;Port=5432;Database=specpour;Username=specpour;Password=specpour_dev_only";

        var optionsBuilder = new DbContextOptionsBuilder<VenuesDbContext>()
            .UseNpgsql(connectionString, o => o.UseNetTopologySuite());

        return new VenuesDbContext(optionsBuilder.Options);
    }
}
