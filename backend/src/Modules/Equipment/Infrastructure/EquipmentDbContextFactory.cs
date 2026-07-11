using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace SpecPour.Modules.Equipment.Infrastructure;

/// <summary>Design-time factory for `dotnet ef migrations add` (see AuthorizationDbContextFactory for the same pattern).</summary>
public sealed class EquipmentDbContextFactory : IDesignTimeDbContextFactory<EquipmentDbContext>
{
    public EquipmentDbContext CreateDbContext(string[] args)
    {
        var connectionString = Environment.GetEnvironmentVariable("ConnectionStrings__Postgres")
            ?? "Host=localhost;Port=5432;Database=specpour;Username=specpour;Password=specpour_dev_only";

        var optionsBuilder = new DbContextOptionsBuilder<EquipmentDbContext>()
            .UseNpgsql(connectionString);

        return new EquipmentDbContext(optionsBuilder.Options);
    }
}
