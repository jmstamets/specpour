using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Identity.Infrastructure;

public sealed class IdentityModuleMigrator : IModuleMigrator
{
    public string ModuleName => "Identity";

    public async Task MigrateAsync(string connectionString, CancellationToken cancellationToken)
    {
        var options = new DbContextOptionsBuilder<IdentityDbContext>()
            .UseNpgsql(connectionString)
            .Options;

        await using var context = new IdentityDbContext(options);
        await context.Database.MigrateAsync(cancellationToken);
    }
}
