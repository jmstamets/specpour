using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Notifications.Infrastructure;

public sealed class NotificationsModuleMigrator : IModuleMigrator
{
    public string ModuleName => "Notifications";

    public async Task MigrateAsync(string connectionString, CancellationToken cancellationToken)
    {
        var options = new DbContextOptionsBuilder<NotificationsDbContext>()
            .UseNpgsql(connectionString)
            .Options;

        await using var context = new NotificationsDbContext(options);
        await context.Database.MigrateAsync(cancellationToken);
    }
}
