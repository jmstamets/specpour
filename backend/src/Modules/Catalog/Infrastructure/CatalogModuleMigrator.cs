using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Catalog.Infrastructure;

public sealed class CatalogModuleMigrator : IModuleMigrator
{
    public string ModuleName => "Catalog";

    public async Task MigrateAsync(string connectionString, CancellationToken cancellationToken)
    {
        var options = new DbContextOptionsBuilder<CatalogDbContext>()
            .UseNpgsql(connectionString)
            .Options;

        await using var context = new CatalogDbContext(options);
        await context.Database.MigrateAsync(cancellationToken);
    }
}
