using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.Modules.Catalog.Infrastructure;
using SpecPour.Modules.Catalog.Infrastructure.Search;
using SpecPour.Modules.Ingredients.Contracts;
using SpecPour.Modules.Ingredients.Infrastructure;

// T155 rider: an idempotent, re-runnable backfill of every existing recipe's
// SearchDocumentText, standalone from Seeder (which is scoped to curated-content
// import + Super Admin bootstrap — not appropriate to run again against a
// database that already has real, non-seed content). Safe to run any number of
// times against any environment: it only recomputes SearchDocumentText from
// current data, never touches anything else.

var configuration = new ConfigurationBuilder()
    .AddJsonFile("appsettings.json", optional: true)
    .AddEnvironmentVariables()
    .Build();

var connectionString = configuration.GetConnectionString("Postgres")
    ?? Environment.GetEnvironmentVariable("ConnectionStrings__Postgres")
    ?? throw new InvalidOperationException(
        "No Postgres connection string configured (ConnectionStrings:Postgres / ConnectionStrings__Postgres).");

Console.WriteLine("SpecPour SearchBackfill");

var services = new ServiceCollection();
services.AddDbContext<CatalogDbContext>(o => o.UseNpgsql(connectionString));
services.AddDbContext<IngredientsDbContext>(o => o.UseNpgsql(connectionString));
services.AddScoped<IIngredientLookupPort, IngredientLookupAdapter>();
services.AddScoped<RecipeSearchDocumentRefresher>();

await using var provider = services.BuildServiceProvider();
await using var scope = provider.CreateAsyncScope();

var catalogDb = scope.ServiceProvider.GetRequiredService<CatalogDbContext>();
var recipeCount = await catalogDb.Recipes.CountAsync();
Console.WriteLine($"Refreshing search documents for {recipeCount} recipe(s)...");

var refresher = scope.ServiceProvider.GetRequiredService<RecipeSearchDocumentRefresher>();
await refresher.RefreshAllAsync(CancellationToken.None);
await catalogDb.SaveChangesAsync();

Console.WriteLine("SearchBackfill complete.");
