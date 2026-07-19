using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Inventory.Infrastructure;

public sealed class InventoryModuleMigrator : IModuleMigrator
{
    public string ModuleName => "Inventory";

    public async Task MigrateAsync(string connectionString, CancellationToken cancellationToken)
    {
        var options = new DbContextOptionsBuilder<InventoryDbContext>()
            .UseNpgsql(connectionString)
            .Options;

        await using var context = new InventoryDbContext(options);
        await context.Database.MigrateAsync(cancellationToken);
    }
}
