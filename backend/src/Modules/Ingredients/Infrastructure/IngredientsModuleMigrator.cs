using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Modules.Ingredients.Infrastructure;

public sealed class IngredientsModuleMigrator : IModuleMigrator
{
    public string ModuleName => "Ingredients";

    public async Task MigrateAsync(string connectionString, CancellationToken cancellationToken)
    {
        var options = new DbContextOptionsBuilder<IngredientsDbContext>()
            .UseNpgsql(connectionString)
            .Options;

        await using var context = new IngredientsDbContext(options);
        await context.Database.MigrateAsync(cancellationToken);
    }
}
