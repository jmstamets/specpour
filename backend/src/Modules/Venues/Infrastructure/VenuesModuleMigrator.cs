using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Venues.Infrastructure;

public sealed class VenuesModuleMigrator : IModuleMigrator
{
    public string ModuleName => "Venues";

    public async Task MigrateAsync(string connectionString, CancellationToken cancellationToken)
    {
        var options = new DbContextOptionsBuilder<VenuesDbContext>()
            .UseNpgsql(connectionString, o => o.UseNetTopologySuite())
            .Options;

        await using var context = new VenuesDbContext(options);
        await context.Database.MigrateAsync(cancellationToken);
    }
}
