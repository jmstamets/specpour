using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Equipment.Infrastructure;

public sealed class EquipmentModuleMigrator : IModuleMigrator
{
    public string ModuleName => "Equipment";

    public async Task MigrateAsync(string connectionString, CancellationToken cancellationToken)
    {
        var options = new DbContextOptionsBuilder<EquipmentDbContext>()
            .UseNpgsql(connectionString)
            .Options;

        await using var context = new EquipmentDbContext(options);
        await context.Database.MigrateAsync(cancellationToken);
    }
}
