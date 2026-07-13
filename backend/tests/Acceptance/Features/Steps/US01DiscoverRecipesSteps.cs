using System.Net.Http.Json;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Reqnroll;
using SpecPour.BuildingBlocks.Library;
using SpecPour.Modules.Catalog.Domain;
using SpecPour.Modules.Catalog.Infrastructure;
using SpecPour.Modules.Equipment.Infrastructure;
using SpecPour.Modules.Ingredients.Domain;
using SpecPour.Modules.Ingredients.Infrastructure;
using SpecPour.Modules.Measurements.Contracts;
using SpecPour.Tests.Acceptance.Support;

namespace SpecPour.Tests.Acceptance.Features.Steps;

/// <summary>
/// T030: US1 acceptance steps. Background data is seeded directly through each
/// module's own DbContext (never through an endpoint — GET /recipes etc. don't
/// exist yet, that's exactly the point of "failing first"), using fixed IDs
/// (<see cref="SeedIds"/>) so the Given step is idempotent across the several
/// scenarios in this feature that all share one Background — Reqnroll runs
/// Background once per scenario against the one Testcontainers instance the whole
/// suite shares (AcceptanceHooks), so re-seeding on every scenario without an
/// existence check would violate ConceptPage.Name's/IngredientCategory.NameKey's
/// unique constraints on the second scenario onward.
/// </summary>
[Binding]
public sealed class US01DiscoverRecipesSteps
{
    private static class SeedIds
    {
        public static readonly Guid MaiTaiRecipe = new("10000000-0000-0000-0000-000000000001");
        public static readonly Guid EggWhiteFlipRecipe = new("10000000-0000-0000-0000-000000000002");
        public static readonly Guid DaiquiriConcept = new("10000000-0000-0000-0000-000000000003");
        public static readonly Guid DaiquiriVariantRecipe = new("10000000-0000-0000-0000-000000000004");
        public static readonly Guid SpiritCategory = new("10000000-0000-0000-0000-000000000005");
        public static readonly Guid RumIngredient = new("10000000-0000-0000-0000-000000000006");
        public static readonly Guid LimeIngredient = new("10000000-0000-0000-0000-000000000007");
        public static readonly Guid OrgeatIngredient = new("10000000-0000-0000-0000-000000000008");
        public static readonly Guid EggWhiteIngredient = new("10000000-0000-0000-0000-000000000009");
        public static readonly Guid Glass = new("10000000-0000-0000-0000-00000000000a");
        public static readonly Guid Shaker = new("10000000-0000-0000-0000-00000000000b");
    }

    private HttpResponseMessage _lastResponse = null!;
    private JsonDocument? _lastJson;
    private string _lastResponseBody = string.Empty;
    private JsonElement _foundRecipeRef;
    private readonly List<HttpResponseMessage> _anonymousResponses = [];

    [Given(@"the curated library contains the Mai Tai, with an egg-white Flip variant, and a Daiquiri concept with variants")]
    public static async Task GivenSeedData()
    {
        using var scope = AcceptanceHooks.Factory.Services.CreateScope();
        var catalogDb = scope.ServiceProvider.GetRequiredService<CatalogDbContext>();

        if (await catalogDb.Recipes.FindAsync(SeedIds.MaiTaiRecipe) is not null)
        {
            return;
        }

        var equipmentDb = scope.ServiceProvider.GetRequiredService<EquipmentDbContext>();
        var ingredientsDb = scope.ServiceProvider.GetRequiredService<IngredientsDbContext>();

        equipmentDb.Equipment.AddRange(
            new SpecPour.Modules.Equipment.Domain.Equipment { Id = SeedIds.Glass, OwnerType = OwnerType.System, LibraryScope = LibraryScope.Core, Name = "Double Old Fashioned Glass", Category = "Glassware", Visibility = ContentVisibility.Public },
            new SpecPour.Modules.Equipment.Domain.Equipment { Id = SeedIds.Shaker, OwnerType = OwnerType.System, LibraryScope = LibraryScope.Core, Name = "Cocktail Shaker", Category = "Bar Tool", Visibility = ContentVisibility.Public });
        await equipmentDb.SaveChangesAsync();

        ingredientsDb.IngredientCategories.Add(new IngredientCategory { Id = SeedIds.SpiritCategory, NameKey = "category.spirit.us01test", Definition = "Base spirits." });
        ingredientsDb.Ingredients.AddRange(
            new Ingredient { Id = SeedIds.RumIngredient, OwnerType = OwnerType.System, LibraryScope = LibraryScope.Core, Name = "Jamaican Rum", CategoryId = SeedIds.SpiritCategory, Visibility = ContentVisibility.Public, AbvPercent = 43m },
            new Ingredient { Id = SeedIds.LimeIngredient, OwnerType = OwnerType.System, LibraryScope = LibraryScope.Core, Name = "Lime Juice", CategoryId = SeedIds.SpiritCategory, Visibility = ContentVisibility.Public },
            new Ingredient { Id = SeedIds.OrgeatIngredient, OwnerType = OwnerType.System, LibraryScope = LibraryScope.Core, Name = "Orgeat", CategoryId = SeedIds.SpiritCategory, Visibility = ContentVisibility.Public },
            new Ingredient { Id = SeedIds.EggWhiteIngredient, OwnerType = OwnerType.System, LibraryScope = LibraryScope.Core, Name = "Egg White", CategoryId = SeedIds.SpiritCategory, Visibility = ContentVisibility.Public });
        ingredientsDb.IngredientAllergens.Add(new IngredientAllergen
        {
            IngredientId = SeedIds.EggWhiteIngredient,
            AllergenId = IngredientsDbContextSeedIds.EggAllergen,
            Certainty = AllergenCertainty.Certain,
        });
        await ingredientsDb.SaveChangesAsync();

        var now = DateTimeOffset.UtcNow;

        catalogDb.Recipes.AddRange(
            new Recipe
            {
                Id = SeedIds.MaiTaiRecipe,
                OwnerType = OwnerType.System,
                LibraryScope = LibraryScope.Core,
                PrimaryName = "Mai Tai",
                AlternateNames = ["Trader Vic's Mai Tai"],
                Method = MixMethod.Shaken,
                FamilyId = CatalogDbContext.SeedIds.CocktailFamily,
                Instructions = ["Shake with crushed ice", "Strain into glass", "Garnish with mint"],
                Garnishes = ["Mint sprig", "Spent lime shell"],
                IceSpec = "Crushed",
                CreatorAttribution = "Trader Vic",
                History = "Created in 1944 at Trader Vic's in Oakland.",
                Visibility = ContentVisibility.Public,
                CreatedAt = now,
                UpdatedAt = now,
            },
            new Recipe
            {
                Id = SeedIds.EggWhiteFlipRecipe,
                OwnerType = OwnerType.System,
                LibraryScope = LibraryScope.Core,
                PrimaryName = "Whiskey Flip",
                Method = MixMethod.Shaken,
                FamilyId = CatalogDbContext.SeedIds.FlipFamily,
                Instructions = ["Dry shake", "Shake with ice", "Strain"],
                Garnishes = ["Grated nutmeg"],
                IceSpec = "None (served up)",
                Visibility = ContentVisibility.Public,
                CreatedAt = now,
                UpdatedAt = now,
            },
            new Recipe
            {
                Id = SeedIds.DaiquiriVariantRecipe,
                OwnerType = OwnerType.System,
                LibraryScope = LibraryScope.Core,
                PrimaryName = "Hemingway Daiquiri",
                Method = MixMethod.Shaken,
                FamilyId = CatalogDbContext.SeedIds.SourFamily,
                Instructions = ["Shake with ice", "Strain"],
                IceSpec = "None (served up)",
                Visibility = ContentVisibility.Public,
                CreatedAt = now,
                UpdatedAt = now,
            });

        catalogDb.RecipeIngredientLines.AddRange(
            new RecipeIngredientLine { Id = Guid.NewGuid(), RecipeId = SeedIds.MaiTaiRecipe, Position = 1, IngredientId = SeedIds.RumIngredient, Quantity = 1.5m, Unit = "oz", ScalingRule = IngredientScalingRule.Linear },
            new RecipeIngredientLine { Id = Guid.NewGuid(), RecipeId = SeedIds.MaiTaiRecipe, Position = 2, IngredientId = SeedIds.LimeIngredient, Quantity = 1m, Unit = "oz", ScalingRule = IngredientScalingRule.Linear },
            new RecipeIngredientLine { Id = Guid.NewGuid(), RecipeId = SeedIds.MaiTaiRecipe, Position = 3, IngredientId = SeedIds.OrgeatIngredient, Quantity = 0.5m, Unit = "oz", ScalingRule = IngredientScalingRule.Linear },
            new RecipeIngredientLine { Id = Guid.NewGuid(), RecipeId = SeedIds.EggWhiteFlipRecipe, Position = 1, IngredientId = SeedIds.EggWhiteIngredient, Quantity = 1m, Unit = "whole", ScalingRule = IngredientScalingRule.Linear });

        catalogDb.RecipeGlassware.Add(new RecipeGlassware { RecipeId = SeedIds.MaiTaiRecipe, EquipmentId = SeedIds.Glass });
        catalogDb.RecipeEquipment.Add(new RecipeEquipment { RecipeId = SeedIds.MaiTaiRecipe, EquipmentId = SeedIds.Shaker });

        catalogDb.ConceptPages.Add(new ConceptPage { Id = SeedIds.DaiquiriConcept, Name = "Daiquiri (US01 test)", Description = "A rum sour built on lime and sugar." });
        catalogDb.ConceptVariantLinks.Add(new ConceptVariantLink
        {
            Id = Guid.NewGuid(),
            ConceptId = SeedIds.DaiquiriConcept,
            RecipeId = SeedIds.DaiquiriVariantRecipe,
            DifferentiatorText = "Adds maraschino liqueur and grapefruit juice.",
            State = ConceptVariantState.Approved,
        });

        await catalogDb.SaveChangesAsync();
    }

    [When(@"I search ""(.*)""")]
    public async Task WhenISearch(string query)
    {
        using var client = AcceptanceHooks.Factory.CreateClient();
        _lastResponse = await client.GetAsync(new Uri($"/api/v1/search?q={Uri.EscapeDataString(query)}", UriKind.Relative));
        await CaptureJsonAsync();
    }

    [Then(@"the search results include a recipe named ""(.*)""")]
    public void ThenSearchResultsInclude(string expectedName)
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        var items = _lastJson!.RootElement.GetProperty("items").EnumerateArray();
        _foundRecipeRef = items.First(item =>
            item.GetProperty("entityType").GetString() == "recipe" &&
            item.GetProperty("title").GetString() == expectedName);
    }

    [When(@"I request the found recipe")]
    public async Task WhenIRequestTheFoundRecipe()
    {
        var id = _foundRecipeRef.GetProperty("entityId").GetGuid();
        await RequestRecipeAsync(id);
    }

    [Then(@"the recipe response includes the ordered ingredient lines, instructions, garnish, glassware, ice spec, equipment, flavor profile, creator ""(.*)"", and history")]
    public void ThenRecipeIncludesFullDetail(string expectedCreator)
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        var root = _lastJson!.RootElement;
        Assert.True(root.GetProperty("ingredientLines").GetArrayLength() > 0);
        Assert.True(root.GetProperty("instructions").GetArrayLength() > 0);
        Assert.True(root.GetProperty("garnishes").GetArrayLength() > 0);
        // Contract sweep: glassware/equipment are now {id,name} objects, not raw
        // ID arrays — assert both that they're present and that names resolved.
        var glassware = root.GetProperty("glassware");
        Assert.True(glassware.GetArrayLength() > 0);
        Assert.False(string.IsNullOrWhiteSpace(glassware[0].GetProperty("name").GetString()));
        Assert.False(string.IsNullOrWhiteSpace(root.GetProperty("iceSpec").GetString()));
        var equipment = root.GetProperty("equipment");
        Assert.True(equipment.GetArrayLength() > 0);
        Assert.False(string.IsNullOrWhiteSpace(equipment[0].GetProperty("name").GetString()));
        Assert.Equal(expectedCreator, root.GetProperty("creatorAttribution").GetString());
        Assert.False(string.IsNullOrWhiteSpace(root.GetProperty("history").GetString()));
    }

    [When(@"I request the egg-white recipe")]
    public async Task WhenIRequestTheEggWhiteRecipe() => await RequestRecipeAsync(SeedIds.EggWhiteFlipRecipe);

    [Then(@"the recipe response includes the rolled-up allergen ""(.*)""")]
    public void ThenRecipeIncludesAllergen(string expectedAllergenKey)
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        var allergens = _lastJson!.RootElement.GetProperty("allergens").EnumerateArray().Select(a => a.GetString());
        Assert.Contains(expectedAllergenKey, allergens);
    }

    [When(@"I request the Daiquiri concept page")]
    public async Task WhenIRequestTheDaiquiriConceptPage()
    {
        using var client = AcceptanceHooks.Factory.CreateClient();
        _lastResponse = await client.GetAsync(new Uri($"/api/v1/concepts/{SeedIds.DaiquiriConcept}", UriKind.Relative));
        await CaptureJsonAsync();
    }

    [Then(@"the concept response lists each variant with a differentiator and a recipe id")]
    public void ThenConceptListsVariants()
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        var variants = _lastJson!.RootElement.GetProperty("variants").EnumerateArray().ToList();
        Assert.NotEmpty(variants);
        Assert.All(variants, v =>
        {
            Assert.False(string.IsNullOrWhiteSpace(v.GetProperty("differentiatorText").GetString()));
            Assert.NotEqual(Guid.Empty, v.GetProperty("recipeId").GetGuid());
        });
    }

    [When(@"I request the Mai Tai recipe")]
    public async Task WhenIRequestTheMaiTaiRecipe() => await RequestRecipeAsync(SeedIds.MaiTaiRecipe);

    [Then(@"the recipe response includes a calculated ABV and standard drinks per serving")]
    public void ThenRecipeIncludesDerivedData()
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        var root = _lastJson!.RootElement;
        Assert.True(root.GetProperty("abvPercent").GetDouble() > 0);
        Assert.True(root.GetProperty("standardDrinks").GetDouble() > 0);
    }

    [When(@"I browse recipes filtered by family ""(.*)""")]
    public async Task WhenIBrowseRecipesFilteredByFamily(string familyKey)
    {
        using var client = AcceptanceHooks.Factory.CreateClient();
        _lastResponse = await client.GetAsync(new Uri($"/api/v1/recipes?family={Uri.EscapeDataString(familyKey)}", UriKind.Relative));
        await CaptureJsonAsync();
    }

    [Then(@"only recipes in the ""(.*)"" family are returned")]
    public void ThenOnlyRecipesInFamilyAreReturned(string familyKey)
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        var items = _lastJson!.RootElement.GetProperty("items").EnumerateArray().ToList();
        Assert.NotEmpty(items);
        Assert.All(items, item => Assert.Equal(familyKey, item.GetProperty("familyKey").GetString()));
    }

    [When(@"I request the recipe list, the concept list, the ingredient list, the equipment list, and the glossary term list anonymously")]
    public async Task WhenIRequestEveryListAnonymously()
    {
        using var client = AcceptanceHooks.Factory.CreateClient();
        foreach (var path in new[] { "/api/v1/recipes", "/api/v1/concepts", "/api/v1/ingredients", "/api/v1/equipment", "/api/v1/glossary/terms" })
        {
            _anonymousResponses.Add(await client.GetAsync(new Uri(path, UriKind.Relative)));
        }
    }

    [Then(@"every anonymous request succeeds")]
    public void ThenEveryAnonymousRequestSucceeds() =>
        Assert.All(_anonymousResponses, response => Assert.Equal(200, (int)response.StatusCode));

    [When(@"I request the age gate for the ""(.*)"" surface")]
    public async Task WhenIRequestTheAgeGate(string surface)
    {
        using var client = AcceptanceHooks.Factory.CreateClient();
        _lastResponse = await client.GetAsync(new Uri($"/api/v1/compliance/age-gate?surface={Uri.EscapeDataString(surface)}", UriKind.Relative));
        await CaptureJsonAsync();
    }

    [Then(@"the age gate responds successfully")]
    public void ThenTheAgeGateRespondsSuccessfully() => Assert.Equal(200, (int)_lastResponse.StatusCode);

    [Then(@"the age gate response includes a legal drinking age")]
    public void ThenAgeGateIncludesLegalDrinkingAge() =>
        Assert.True(_lastJson!.RootElement.GetProperty("legalDrinkingAge").GetInt32() > 0);

    [When(@"I request the SEO page for the Mai Tai recipe")]
    public async Task WhenIRequestTheSeoPageForMaiTai()
    {
        using var client = AcceptanceHooks.Factory.CreateClient();
        _lastResponse = await client.GetAsync(new Uri($"/pages/recipes/{SeedIds.MaiTaiRecipe}", UriKind.Relative));
        _lastResponseBody = await _lastResponse.Content.ReadAsStringAsync();
    }

    [Then(@"the SEO page responds successfully as ""(.*)""")]
    public void ThenTheSeoPageRespondsSuccessfullyAs(string expectedContentType)
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        Assert.Contains(expectedContentType, _lastResponse.Content.Headers.ContentType?.MediaType ?? string.Empty, StringComparison.OrdinalIgnoreCase);
    }

    [Then(@"the SEO page contains the recipe name ""(.*)""")]
    public void ThenTheSeoPageContainsRecipeName(string name) =>
        Assert.Contains(name, _lastResponseBody, StringComparison.Ordinal);

    [Then(@"the SEO page contains a meta description")]
    public void ThenTheSeoPageContainsMetaDescription() =>
        Assert.Contains("<meta name=\"description\"", _lastResponseBody, StringComparison.Ordinal);

    [When(@"I request the responsible-consumption message for the ""(.*)"" surface")]
    public async Task WhenIRequestTheResponsibleConsumptionMessage(string surface)
    {
        using var client = AcceptanceHooks.Factory.CreateClient();
        _lastResponse = await client.GetAsync(new Uri($"/api/v1/compliance/messaging?surface={Uri.EscapeDataString(surface)}", UriKind.Relative));
        await CaptureJsonAsync();
    }

    [Then(@"the messaging response includes a message content key")]
    public void ThenMessagingIncludesContentKey()
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        Assert.False(string.IsNullOrWhiteSpace(_lastJson!.RootElement.GetProperty("messageContentKey").GetString()));
    }

    [When(@"I request the support resources")]
    public async Task WhenIRequestSupportResources()
    {
        using var client = AcceptanceHooks.Factory.CreateClient();
        _lastResponse = await client.GetAsync(new Uri("/api/v1/compliance/support-resources", UriKind.Relative));
        await CaptureJsonAsync();
    }

    [Then(@"the support resources response includes at least one resource")]
    public void ThenSupportResourcesIncludesAtLeastOne()
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        Assert.True(_lastJson!.RootElement.GetProperty("items").GetArrayLength() > 0);
    }

    private async Task RequestRecipeAsync(Guid id)
    {
        using var client = AcceptanceHooks.Factory.CreateClient();
        _lastResponse = await client.GetAsync(new Uri($"/api/v1/recipes/{id}", UriKind.Relative));
        await CaptureJsonAsync();
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
