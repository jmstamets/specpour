using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Glossary.Infrastructure;

public sealed class GlossaryModuleMigrator : IModuleMigrator
{
    public string ModuleName => "Glossary";

    public async Task MigrateAsync(string connectionString, CancellationToken cancellationToken)
    {
        var options = new DbContextOptionsBuilder<GlossaryDbContext>()
            .UseNpgsql(connectionString)
            .Options;

        await using var context = new GlossaryDbContext(options);
        await context.Database.MigrateAsync(cancellationToken);
    }
}
