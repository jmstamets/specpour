using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Authorization.Infrastructure;

public sealed class AuthorizationModuleMigrator : IModuleMigrator
{
    public string ModuleName => "Authorization";

    public async Task MigrateAsync(string connectionString, CancellationToken cancellationToken)
    {
        var options = new DbContextOptionsBuilder<AuthorizationDbContext>()
            .UseNpgsql(connectionString)
            .Options;

        await using var context = new AuthorizationDbContext(options);
        await context.Database.MigrateAsync(cancellationToken);
    }
}
