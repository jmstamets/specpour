using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Measurements.Infrastructure;

public sealed class MeasurementsModuleMigrator : IModuleMigrator
{
    public string ModuleName => "Measurements";

    public async Task MigrateAsync(string connectionString, CancellationToken cancellationToken)
    {
        var options = new DbContextOptionsBuilder<MeasurementsDbContext>()
            .UseNpgsql(connectionString)
            .Options;

        await using var context = new MeasurementsDbContext(options);
        await context.Database.MigrateAsync(cancellationToken);
    }
}
