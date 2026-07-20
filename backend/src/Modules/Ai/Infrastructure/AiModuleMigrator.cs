using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Ai.Infrastructure;

public sealed class AiModuleMigrator : IModuleMigrator
{
    public string ModuleName => "Ai";

    public async Task MigrateAsync(string connectionString, CancellationToken cancellationToken)
    {
        var options = new DbContextOptionsBuilder<AiDbContext>()
            .UseNpgsql(connectionString)
            .Options;

        await using var context = new AiDbContext(options);
        await context.Database.MigrateAsync(cancellationToken);
    }
}
