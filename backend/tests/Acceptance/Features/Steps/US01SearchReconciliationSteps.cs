using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Reqnroll;
using SpecPour.BuildingBlocks.Library;
using SpecPour.Modules.Catalog.Domain;
using SpecPour.Modules.Catalog.Infrastructure;
using SpecPour.Modules.Catalog.Infrastructure.Search;
using SpecPour.Modules.Ingredients.Domain;
using SpecPour.Modules.Ingredients.Infrastructure;
using SpecPour.Modules.Measurements.Contracts;
using SpecPour.Tests.Acceptance.Support;

namespace SpecPour.Tests.Acceptance.Features.Steps;

/// <summary>
/// T155: acceptance steps for search-document composition, the hierarchy-aware
/// "uses:&lt;ingredient&gt;" facet, FR-014a's ingredient-&gt;recipes surface, and the
/// ADR-0002 rename-refresh rider. Deliberately its own [Binding] class with its own
/// state and step wording, distinct from US01DiscoverRecipesSteps — see the feature
/// file's header comment for why (the Reqnroll cross-binding-state trap).
///
/// The rename scenario (5) uses its OWN dedicated ingredient/recipe pair, never
/// referenced by scenarios 1-4 — Background is idempotent (seeds once per feature
/// run, shared across all scenarios in the run, in whatever order the runner picks),
/// so a rename mutates that data PERMANENTLY for the rest of the run; sharing an
/// ingredient between the rename scenario and a scenario that searches for its
/// original name would make the suite's pass/fail depend on scenario execution
/// order (found the hard way — scenario 1 failed when scenario 5 happened to run first).
/// </summary>
[Binding]
public sealed class US01SearchReconciliationSteps
{
    private static class SeedIds
    {
        public static readonly Guid SpiritCategory = new("20000000-0000-0000-0000-000000000001");
        public static readonly Guid RumClassIngredient = new("20000000-0000-0000-0000-000000000002");
        public static readonly Guid JamaicanRumIngredient = new("20000000-0000-0000-0000-000000000003");
        public static readonly Guid BourbonIngredient = new("20000000-0000-0000-0000-000000000004");
        public static readonly Guid MaiTaiRecipe = new("20000000-0000-0000-0000-000000000005");
        public static readonly Guid OldFashionedRecipe = new("20000000-0000-0000-0000-000000000006");

        // Dedicated to scenario 5 (rename) only — see class doc comment.
        public static readonly Guid GingerLiqueurIngredient = new("20000000-0000-0000-0000-000000000007");
        public static readonly Guid MuleRecipe = new("20000000-0000-0000-0000-000000000008");
    }

    /// <summary>Ingredient display name -> ID, so step text can reference ingredients by name (readable Gherkin) while the backend calls need GUIDs.</summary>
    private static readonly Dictionary<string, Guid> IngredientIdByName = new()
    {
        ["Rum (T155)"] = SeedIds.RumClassIngredient,
        ["Jamaican Rum (T155)"] = SeedIds.JamaicanRumIngredient,
        ["Ginger Liqueur (T155)"] = SeedIds.GingerLiqueurIngredient,
    };

    private HttpResponseMessage _lastResponse = null!;
    private JsonDocument? _lastJson;

    [Given(@"the curated library contains a Rum ingredient class with a Jamaican Rum child, a T155 Mai Tai recipe using it, and a T155 Old Fashioned recipe using an unrelated Bourbon")]
    public static async Task GivenSeedData()
    {
        using var scope = AcceptanceHooks.Factory.Services.CreateScope();
        var ingredientsDb = scope.ServiceProvider.GetRequiredService<IngredientsDbContext>();

        if (await ingredientsDb.Ingredients.FindAsync(SeedIds.RumClassIngredient) is not null)
        {
            return;
        }

        ingredientsDb.IngredientCategories.Add(new IngredientCategory
        {
            Id = SeedIds.SpiritCategory,
            NameKey = "category.spirit.t155test",
            Definition = "Base spirits.",
        });
        ingredientsDb.Ingredients.AddRange(
            new Ingredient { Id = SeedIds.RumClassIngredient, OwnerType = OwnerType.System, LibraryScope = LibraryScope.Core, Name = "Rum (T155)", CategoryId = SeedIds.SpiritCategory, Visibility = ContentVisibility.Public },
            new Ingredient { Id = SeedIds.JamaicanRumIngredient, OwnerType = OwnerType.System, LibraryScope = LibraryScope.Core, Name = "Jamaican Rum (T155)", CategoryId = SeedIds.SpiritCategory, ParentId = SeedIds.RumClassIngredient, Visibility = ContentVisibility.Public, AbvPercent = 43m },
            new Ingredient { Id = SeedIds.BourbonIngredient, OwnerType = OwnerType.System, LibraryScope = LibraryScope.Core, Name = "Bourbon (T155)", CategoryId = SeedIds.SpiritCategory, Visibility = ContentVisibility.Public, AbvPercent = 45m },
            new Ingredient { Id = SeedIds.GingerLiqueurIngredient, OwnerType = OwnerType.System, LibraryScope = LibraryScope.Core, Name = "Ginger Liqueur (T155)", CategoryId = SeedIds.SpiritCategory, Visibility = ContentVisibility.Public, AbvPercent = 20m });
        await ingredientsDb.SaveChangesAsync();

        var catalogDb = scope.ServiceProvider.GetRequiredService<CatalogDbContext>();
        var now = DateTimeOffset.UtcNow;

        catalogDb.Recipes.AddRange(
            new Recipe
            {
                Id = SeedIds.MaiTaiRecipe,
                OwnerType = OwnerType.System,
                LibraryScope = LibraryScope.Core,
                PrimaryName = "T155 Mai Tai",
                Method = MixMethod.Shaken,
                IceSpec = "Crushed",
                Visibility = ContentVisibility.Public,
                CreatedAt = now,
                UpdatedAt = now,
            },
            new Recipe
            {
                Id = SeedIds.OldFashionedRecipe,
                OwnerType = OwnerType.System,
                LibraryScope = LibraryScope.Core,
                PrimaryName = "T155 Old Fashioned",
                Method = MixMethod.Stirred,
                IceSpec = "Large cube",
                Visibility = ContentVisibility.Public,
                CreatedAt = now,
                UpdatedAt = now,
            },
            new Recipe
            {
                Id = SeedIds.MuleRecipe,
                OwnerType = OwnerType.System,
                LibraryScope = LibraryScope.Core,
                PrimaryName = "T155 Mule",
                Method = MixMethod.Built,
                IceSpec = "Cubed",
                Visibility = ContentVisibility.Public,
                CreatedAt = now,
                UpdatedAt = now,
            });

        catalogDb.RecipeIngredientLines.AddRange(
            new RecipeIngredientLine { Id = Guid.NewGuid(), RecipeId = SeedIds.MaiTaiRecipe, Position = 1, IngredientId = SeedIds.JamaicanRumIngredient, Quantity = 1.5m, Unit = "oz", ScalingRule = IngredientScalingRule.Linear },
            new RecipeIngredientLine { Id = Guid.NewGuid(), RecipeId = SeedIds.OldFashionedRecipe, Position = 1, IngredientId = SeedIds.BourbonIngredient, Quantity = 2m, Unit = "oz", ScalingRule = IngredientScalingRule.Linear },
            new RecipeIngredientLine { Id = Guid.NewGuid(), RecipeId = SeedIds.MuleRecipe, Position = 1, IngredientId = SeedIds.GingerLiqueurIngredient, Quantity = 1m, Unit = "oz", ScalingRule = IngredientScalingRule.Linear });
        await catalogDb.SaveChangesAsync();

        // No recipe-write endpoint exists yet (US3/personal-library authoring
        // territory) — a real write endpoint will call this synchronously; here the
        // Given step plays that role directly, same as GivenSeedData writing
        // straight through each module's DbContext elsewhere in this suite.
        var refresher = scope.ServiceProvider.GetRequiredService<RecipeSearchDocumentRefresher>();
        await refresher.RefreshAllAsync(CancellationToken.None);
        await catalogDb.SaveChangesAsync();
    }

    [When(@"I look up ""(.*)"" in the recipe search")]
    public async Task WhenILookUpInTheRecipeSearch(string query) => await SearchAsync(query, uses: null);

    [When(@"I look up ""(.*)"" in the recipe search filtered to ingredient ""(.*)""")]
    public async Task WhenILookUpFilteredToIngredient(string query, string ingredientName) =>
        await SearchAsync(query, IngredientIdByName[ingredientName]);

    private async Task SearchAsync(string query, Guid? uses)
    {
        using var client = AcceptanceHooks.Factory.CreateClient();
        var url = $"/api/v1/search?q={Uri.EscapeDataString(query)}";
        if (uses is { } id)
        {
            url += $"&uses={id}";
        }

        _lastResponse = await client.GetAsync(new Uri(url, UriKind.Relative));
        await CaptureJsonAsync();
    }

    [Then(@"the matching recipes include ""(.*)""")]
    public void ThenMatchingRecipesInclude(string name) => Assert.True(HasRecipeResult(name));

    [Then(@"the matching recipes exclude ""(.*)""")]
    public void ThenMatchingRecipesExclude(string name) => Assert.False(HasRecipeResult(name));

    private bool HasRecipeResult(string name)
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        return _lastJson!.RootElement.GetProperty("items").EnumerateArray().Any(item =>
            item.GetProperty("entityType").GetString() == "recipe" &&
            item.GetProperty("title").GetString() == name);
    }

    [When(@"I browse recipes that use the ingredient ""(.*)""")]
    public async Task WhenIBrowseRecipesThatUseIngredient(string ingredientName)
    {
        using var client = AcceptanceHooks.Factory.CreateClient();
        _lastResponse = await client.GetAsync(new Uri($"/api/v1/recipes?uses={IngredientIdByName[ingredientName]}", UriKind.Relative));
        await CaptureJsonAsync();
    }

    [Then(@"only the recipe ""(.*)"" is browsed")]
    public void ThenOnlyTheRecipeIsBrowsed(string name)
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        var items = _lastJson!.RootElement.GetProperty("items").EnumerateArray().ToList();
        Assert.Single(items);
        Assert.Equal(name, items[0].GetProperty("primaryName").GetString());
    }

    [When(@"I look up the recipes that use ingredient ""(.*)""")]
    public async Task WhenILookUpTheRecipesThatUseIngredient(string ingredientName)
    {
        using var client = AcceptanceHooks.Factory.CreateClient();
        _lastResponse = await client.GetAsync(new Uri($"/api/v1/ingredients/{IngredientIdByName[ingredientName]}/recipes", UriKind.Relative));
        await CaptureJsonAsync();
    }

    [Then(@"the ingredient's recipe usage includes ""(.*)""")]
    public void ThenIngredientRecipeUsageIncludes(string name) => Assert.True(HasIngredientRecipeItem(name));

    [Then(@"the ingredient's recipe usage excludes ""(.*)""")]
    public void ThenIngredientRecipeUsageExcludes(string name) => Assert.False(HasIngredientRecipeItem(name));

    private bool HasIngredientRecipeItem(string name)
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        return _lastJson!.RootElement.GetProperty("items").EnumerateArray()
            .Any(item => item.GetProperty("name").GetString() == name);
    }

    [When(@"I rename the ingredient ""(.*)"" to ""(.*)""")]
    public static async Task WhenIRenameTheIngredient(string ingredientName, string newName)
    {
        // No public rename endpoint exists yet (T155 scoped the rename mechanism
        // itself, not a curator-facing PUT /ingredients/{id} — see tasks.md) — this
        // drives the real domain/event/outbox pipeline directly via the DI-resolved
        // service a future endpoint would call, exactly what the ADR-0002 rider
        // needs to prove: rename -> event -> outbox -> dispatch -> search refresh.
        using var scope = AcceptanceHooks.Factory.Services.CreateScope();
        var renameService = scope.ServiceProvider.GetRequiredService<IngredientRenameService>();
        await renameService.RenameAsync(IngredientIdByName[ingredientName], newName, CancellationToken.None);
    }

    [Then(@"eventually looking up ""(.*)"" in the recipe search includes ""(.*)""")]
    public async Task ThenEventuallyLookingUpIncludes(string query, string recipeName) =>
        await PollUntilAsync(async () =>
        {
            await SearchAsync(query, uses: null);
            return HasRecipeResult(recipeName);
        });

    [Then(@"eventually looking up ""(.*)"" in the recipe search excludes ""(.*)""")]
    public async Task ThenEventuallyLookingUpExcludes(string query, string recipeName) =>
        await PollUntilAsync(async () =>
        {
            await SearchAsync(query, uses: null);
            return !HasRecipeResult(recipeName);
        });

    /// <summary>
    /// Bounded poll for the outbox dispatch pipeline (SpecPourWebApplicationFactory
    /// configures a fast 200ms test-only polling interval): retries every 250ms for
    /// up to 10s before failing the assertion, covering the eventual-consistency
    /// window ADR-0002 documents.
    /// </summary>
    private static async Task PollUntilAsync(Func<Task<bool>> conditionAsync)
    {
        var deadline = DateTimeOffset.UtcNow.AddSeconds(10);
        while (DateTimeOffset.UtcNow < deadline)
        {
            if (await conditionAsync())
            {
                return;
            }

            await Task.Delay(250);
        }

        Assert.True(await conditionAsync(), "Condition did not become true within the 10s poll window.");
    }

    private async Task CaptureJsonAsync()
    {
        _lastJson?.Dispose();
        _lastJson = null;

        var body = await _lastResponse.Content.ReadAsStringAsync();
        if (!string.IsNullOrWhiteSpace(body) && _lastResponse.Content.Headers.ContentType?.MediaType?.Contains("json", StringComparison.OrdinalIgnoreCase) == true)
        {
            _lastJson = JsonDocument.Parse(body);
        }
    }
}
