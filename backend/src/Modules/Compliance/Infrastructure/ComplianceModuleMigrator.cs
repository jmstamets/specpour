using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Compliance.Infrastructure;

public sealed class ComplianceModuleMigrator : IModuleMigrator
{
    public string ModuleName => "Compliance";

    public async Task MigrateAsync(string connectionString, CancellationToken cancellationToken)
    {
        var options = new DbContextOptionsBuilder<ComplianceDbContext>()
            .UseNpgsql(connectionString)
            .Options;

        await using var context = new ComplianceDbContext(options);
        await context.Database.MigrateAsync(cancellationToken);
    }
}
