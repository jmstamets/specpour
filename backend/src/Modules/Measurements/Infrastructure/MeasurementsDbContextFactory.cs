using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace SpecPour.Modules.Measurements.Infrastructure;

/// <summary>Design-time factory for `dotnet ef migrations add`.</summary>
public sealed class MeasurementsDbContextFactory : IDesignTimeDbContextFactory<MeasurementsDbContext>
{
    public MeasurementsDbContext CreateDbContext(string[] args)
    {
        var connectionString = Environment.GetEnvironmentVariable("ConnectionStrings__Postgres")
            ?? "Host=localhost;Port=5432;Database=specpour;Username=specpour;Password=specpour_dev_only";

        var optionsBuilder = new DbContextOptionsBuilder<MeasurementsDbContext>()
            .UseNpgsql(connectionString);

        return new MeasurementsDbContext(optionsBuilder.Options);
    }
}
