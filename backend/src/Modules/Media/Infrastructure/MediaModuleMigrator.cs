using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Media.Infrastructure;

public sealed class MediaModuleMigrator : IModuleMigrator
{
    public string ModuleName => "Media";

    public async Task MigrateAsync(string connectionString, CancellationToken cancellationToken)
    {
        var options = new DbContextOptionsBuilder<MediaDbContext>()
            .UseNpgsql(connectionString)
            .Options;

        await using var context = new MediaDbContext(options);
        await context.Database.MigrateAsync(cancellationToken);
    }
}
