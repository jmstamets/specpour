using System.Net.Http.Json;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.WebUtilities;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Reqnroll;
using SpecPour.BuildingBlocks.Library;
using SpecPour.Modules.Ingredients.Domain;
using SpecPour.Modules.Ingredients.Infrastructure;
using SpecPour.Tests.Acceptance.Support;

namespace SpecPour.Tests.Acceptance.Features.Steps;

/// <summary>
/// T064 (Phase 6 entry): US4 acceptance steps, failing first per constitution
/// Principle I — none of POST/GET/DELETE /inventory/items, POST /inventory/recognize,
/// or GET /inventory/makeable exist yet (T066/T067/T069). Every scenario here is
/// expected RED until those land.
///
/// Registration/token acquisition is its own copy here (not shared with
/// US02IdentitySteps/US03AuthorLibrarySteps), matching this project's established
/// per-file convention — Reqnroll step text binds globally, so a distinct Given
/// phrase ("an inventory-tracking signed-in user") avoids colliding with US03's
/// "a signed-in user"; each file keeps its own private session state deliberately
/// un-shared.
/// </summary>
[Binding]
public sealed class US04InventorySteps
{
    private const string Password = "correct horse battery staple";
    private const string RedirectUri = "http://localhost:5001/connect/spa-callback";
    private static readonly string[] StandardInstructions = ["Combine all ingredients.", "Serve."];

    private HttpClient? _sessionClient;
    private HttpResponseMessage _lastResponse = null!;
    private JsonDocument? _lastJson;

    private Guid _londonDryGinId;
    private Guid _beefeaterId;
    private Guid _secondIngredientId;
    private Guid _inventoryItemId;
    private Guid _recipeId;

    // Scenario 6 needs two independent signed-in identities live at once.
    private HttpClient? _secondUserSessionClient;
    private HttpResponseMessage _secondUserResponse = null!;

    [Given(@"an inventory-tracking signed-in user")]
    public async Task GivenAnInventoryTrackingSignedInUser() => _sessionClient = await RegisterAndGetSessionClientAsync();

    [Given(@"a second, unrelated signed-in user")]
    public async Task GivenASecondUnrelatedSignedInUser() => _secondUserSessionClient = await RegisterAndGetSessionClientAsync();

    [Given(@"a curated ingredient hierarchy of ""(.*)"" \(product\) under ""(.*)"" \(class\)")]
    public async Task GivenACuratedIngredientHierarchy(string productName, string className)
    {
        using var scope = AcceptanceHooks.Factory.Services.CreateScope();
        var ingredientsDb = scope.ServiceProvider.GetRequiredService<IngredientsDbContext>();

        var category = new IngredientCategory
        {
            Id = Guid.NewGuid(),
            NameKey = $"category.spirit.us04test.{Guid.NewGuid():N}",
            Definition = "Base spirits (US04 test fixture).",
        };
        ingredientsDb.IngredientCategories.Add(category);

        var classIngredient = new Ingredient
        {
            Id = Guid.NewGuid(),
            OwnerType = OwnerType.System,
            LibraryScope = LibraryScope.Core,
            Name = $"{className} (US04 test {Guid.NewGuid():N})",
            CategoryId = category.Id,
            Visibility = ContentVisibility.Public,
        };
        ingredientsDb.Ingredients.Add(classIngredient);

        var productIngredient = new Ingredient
        {
            Id = Guid.NewGuid(),
            OwnerType = OwnerType.System,
            LibraryScope = LibraryScope.Core,
            Name = $"{productName} (US04 test {Guid.NewGuid():N})",
            CategoryId = category.Id,
            ParentId = classIngredient.Id,
            Visibility = ContentVisibility.Public,
        };
        ingredientsDb.Ingredients.Add(productIngredient);

        // The recipe's "second ingredient the user does not own" for the near-miss
        // scenarios — a sibling under the same category, no hierarchy relation to
        // the gin line at all, so it can never be hierarchy- or substitution-satisfied.
        var secondIngredient = new Ingredient
        {
            Id = Guid.NewGuid(),
            OwnerType = OwnerType.System,
            LibraryScope = LibraryScope.Core,
            Name = $"Orange Curaçao (US04 test {Guid.NewGuid():N})",
            CategoryId = category.Id,
            Visibility = ContentVisibility.Public,
        };
        ingredientsDb.Ingredients.Add(secondIngredient);

        await ingredientsDb.SaveChangesAsync();

        _londonDryGinId = classIngredient.Id;
        _beefeaterId = productIngredient.Id;
        _secondIngredientId = secondIngredient.Id;
    }

    [When(@"the user adds ""(.*)"" to inventory by manual entry")]
    public async Task WhenTheUserAddsToInventoryByManualEntry(string productName)
    {
        _lastResponse = await _sessionClient!.PostAsJsonAsync(
            new Uri("/api/v1/inventory/items", UriKind.Relative),
            new
            {
                ingredientId = _beefeaterId,
                source = "manual",
            });
        await CaptureJsonAsync();
    }

    [Then(@"the item is saved in the user's inventory")]
    public void ThenTheItemIsSavedInTheUsersInventory()
    {
        Assert.Equal(201, (int)_lastResponse.StatusCode);
        _inventoryItemId = _lastJson!.RootElement.GetProperty("id").GetGuid();
    }

    [When(@"the user submits an unrecognizable bottle photo for recognition")]
    public async Task WhenTheUserSubmitsAnUnrecognizableBottlePhotoForRecognition()
    {
        // No real vision provider is configured in this environment (mirrors the
        // LoggingEmailChannelAdapter fallback pattern) — T069's implementation is
        // expected to treat "no provider" / "no confident match" identically:
        // degrade to a pre-filled manual entry form rather than an error response.
        _lastResponse = await _sessionClient!.PostAsJsonAsync(
            new Uri("/api/v1/inventory/recognize", UriKind.Relative),
            new
            {
                photoUrl = "https://example.test/us04-unrecognizable-bottle.jpg",
            });
        await CaptureJsonAsync();
    }

    [Then(@"the recognition response degrades to a pre-filled manual entry form rather than failing")]
    public void ThenTheRecognitionResponseDegradesToAPreFilledManualEntryForm()
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        Assert.False(_lastJson!.RootElement.GetProperty("recognized").GetBoolean());
        Assert.True(_lastJson.RootElement.TryGetProperty("manualEntryForm", out _));
    }

    [Given(@"the user has ""(.*)"" in inventory")]
    public async Task GivenTheUserHasInInventory(string productName)
    {
        _lastResponse = await _sessionClient!.PostAsJsonAsync(
            new Uri("/api/v1/inventory/items", UriKind.Relative),
            new
            {
                ingredientId = _beefeaterId,
                source = "manual",
            });
        await CaptureJsonAsync();
        Assert.Equal(201, (int)_lastResponse.StatusCode);
        _inventoryItemId = _lastJson!.RootElement.GetProperty("id").GetGuid();
    }

    [Given(@"the user has ""(.*)"" in inventory with quantity (\d+) and bottle size ""(.*)""")]
    public async Task GivenTheUserHasInInventoryWithQuantityAndBottleSize(string productName, int quantity, string bottleSize)
    {
        _lastResponse = await _sessionClient!.PostAsJsonAsync(
            new Uri("/api/v1/inventory/items", UriKind.Relative),
            new
            {
                ingredientId = _beefeaterId,
                source = "manual",
                quantity,
                bottleSize,
            });
        await CaptureJsonAsync();
        Assert.Equal(201, (int)_lastResponse.StatusCode);
        _inventoryItemId = _lastJson!.RootElement.GetProperty("id").GetGuid();
    }

    [Given(@"the user's inventory is empty")]
    public static void GivenTheUsersInventoryIsEmpty()
    {
        // No-op by construction — this scenario never calls "the user has X in
        // inventory" first. Named explicitly so the scenario reads as a deliberate
        // edge case, not a missing setup step.
    }

    [Given(@"the user has a private recipe requiring ""(.*)"" at the class level")]
    public async Task GivenTheUserHasAPrivateRecipeRequiringAtTheClassLevel(string className)
    {
        await CreateRecipeWithIngredientLinesAsync(new[] { _londonDryGinId });
        Assert.Equal(201, (int)_lastResponse.StatusCode);
        _recipeId = _lastJson!.RootElement.GetProperty("id").GetGuid();
    }

    [Given(@"the user has a private recipe requiring ""(.*)"" and a second ingredient the user does not own")]
    public async Task GivenTheUserHasAPrivateRecipeRequiringAndASecondIngredientTheUserDoesNotOwn(string className)
    {
        await CreateRecipeWithIngredientLinesAsync(new[] { _londonDryGinId, _secondIngredientId });
        Assert.Equal(201, (int)_lastResponse.StatusCode);
        _recipeId = _lastJson!.RootElement.GetProperty("id").GetGuid();
    }

    [When(@"the user asks what they can make")]
    public async Task WhenTheUserAsksWhatTheyCanMake()
    {
        _lastResponse = await _sessionClient!.GetAsync(new Uri("/api/v1/inventory/makeable", UriKind.Relative));
        await CaptureJsonAsync();
    }

    [Then(@"the recipe is listed as makeable with match quality ""(.*)""")]
    public void ThenTheRecipeIsListedAsMakeableWithMatchQuality(string matchQuality)
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        var makeable = _lastJson!.RootElement.GetProperty("makeable").EnumerateArray();
        var entry = Assert.Single(makeable, item => item.GetProperty("recipeId").GetGuid() == _recipeId);
        Assert.Equal(matchQuality, entry.GetProperty("matchQuality").GetString());
    }

    [Then(@"the recipe is listed as a near-miss naming the missing ingredient")]
    public void ThenTheRecipeIsListedAsANearMissNamingTheMissingIngredient()
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        var nearMiss = _lastJson!.RootElement.GetProperty("nearMiss").EnumerateArray();
        var entry = Assert.Single(nearMiss, item => item.GetProperty("recipeId").GetGuid() == _recipeId);
        var missing = entry.GetProperty("missingIngredients").EnumerateArray();
        Assert.Contains(missing, m => m.GetProperty("ingredientId").GetGuid() == _secondIngredientId);
    }

    [Then(@"the recipe does not also appear in the fully-makeable list")]
    public void ThenTheRecipeDoesNotAlsoAppearInTheFullyMakeableList()
    {
        var makeable = _lastJson!.RootElement.GetProperty("makeable").EnumerateArray();
        Assert.DoesNotContain(makeable, item => item.GetProperty("recipeId").GetGuid() == _recipeId);
    }

    [Then(@"the recipe does not appear in the fully-makeable list")]
    public void ThenTheRecipeDoesNotAppearInTheFullyMakeableList() => ThenTheRecipeDoesNotAlsoAppearInTheFullyMakeableList();

    [Then(@"the recipe does not appear in the near-miss list")]
    public void ThenTheRecipeDoesNotAppearInTheNearMissList()
    {
        var nearMiss = _lastJson!.RootElement.GetProperty("nearMiss").EnumerateArray();
        Assert.DoesNotContain(nearMiss, item => item.GetProperty("recipeId").GetGuid() == _recipeId);
    }

    [When(@"the user views their inventory")]
    public async Task WhenTheUserViewsTheirInventory()
    {
        _lastResponse = await _sessionClient!.GetAsync(new Uri("/api/v1/inventory/items", UriKind.Relative));
        await CaptureJsonAsync();
    }

    [Then(@"the item displays the tracked quantity and bottle size")]
    public void ThenTheItemDisplaysTheTrackedQuantityAndBottleSize()
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        var items = _lastJson!.RootElement.GetProperty("items").EnumerateArray();
        var item = Assert.Single(items, i => i.GetProperty("id").GetGuid() == _inventoryItemId);
        Assert.Equal(750, item.GetProperty("quantity").GetInt32());
        Assert.Equal("750ml", item.GetProperty("bottleSize").GetString());
    }

    [When(@"the second user requests the first user's inventory item directly")]
    public async Task WhenTheSecondUserRequestsTheFirstUsersInventoryItemDirectly()
    {
        _secondUserResponse = await _secondUserSessionClient!.GetAsync(
            new Uri($"/api/v1/inventory/items/{_inventoryItemId}", UriKind.Relative));
    }

    [Then(@"the item is not accessible to the second user")]
    public void ThenTheItemIsNotAccessibleToTheSecondUser() =>
        // Strictly 404, never 403 — same no-enumeration reasoning as T196's
        // tightening of the recipe-privacy assertion: a 403 would confirm the item
        // exists, an information leak for private content in its own right.
        Assert.Equal(System.Net.HttpStatusCode.NotFound, _secondUserResponse.StatusCode);

    [When(@"the second user attempts to delete the first user's inventory item")]
    public async Task WhenTheSecondUserAttemptsToDeleteTheFirstUsersInventoryItem()
    {
        _secondUserResponse = await _secondUserSessionClient!.DeleteAsync(
            new Uri($"/api/v1/inventory/items/{_inventoryItemId}", UriKind.Relative));
    }

    [Then(@"the deletion is not permitted for the second user")]
    public void ThenTheDeletionIsNotPermittedForTheSecondUser() =>
        Assert.Equal(System.Net.HttpStatusCode.NotFound, _secondUserResponse.StatusCode);

    [When(@"an anonymous guest requests the inventory list")]
    public async Task WhenAnAnonymousGuestRequestsTheInventoryList()
    {
        using var anonymousClient = AcceptanceHooks.Factory.CreateClient();
        _lastResponse = await anonymousClient.GetAsync(new Uri("/api/v1/inventory/items", UriKind.Relative));
    }

    [When(@"an anonymous guest requests what can be made")]
    public async Task WhenAnAnonymousGuestRequestsWhatCanBeMade()
    {
        using var anonymousClient = AcceptanceHooks.Factory.CreateClient();
        _lastResponse = await anonymousClient.GetAsync(new Uri("/api/v1/inventory/makeable", UriKind.Relative));
    }

    [Then(@"the request is rejected as unauthenticated")]
    public void ThenTheRequestIsRejectedAsUnauthenticated() =>
        Assert.Equal(System.Net.HttpStatusCode.Unauthorized, _lastResponse.StatusCode);

    [When(@"the user searches for ""(.*)""")]
    public async Task WhenTheUserSearchesFor(string term)
    {
        _lastResponse = await _sessionClient!.GetAsync(
            new Uri($"/api/v1/search?q={Uri.EscapeDataString(term)}", UriKind.Relative));
        await CaptureJsonAsync();
    }

    [Then(@"the search results do not include an inventory entity type")]
    public void ThenTheSearchResultsDoNotIncludeAnInventoryEntityType()
    {
        Assert.Equal(200, (int)_lastResponse.StatusCode);
        var items = _lastJson!.RootElement.GetProperty("items").EnumerateArray();
        Assert.DoesNotContain(items, item => item.GetProperty("entityType").GetString() == "inventory");
    }

    private async Task CreateRecipeWithIngredientLinesAsync(IReadOnlyList<Guid> ingredientIds)
    {
        _lastResponse = await _sessionClient!.PostAsJsonAsync(
            new Uri("/api/v1/recipes", UriKind.Relative),
            new
            {
                primaryName = $"US04 Test Recipe {Guid.NewGuid():N}",
                alternateNames = Array.Empty<string>(),
                libraryScope = "personal",
                venueId = (Guid?)null,
                instructions = StandardInstructions,
                ingredientLines = ingredientIds.Select(ingredientId => new
                {
                    ingredientId,
                    quantity = 2m,
                    unit = "oz",
                    purpose = (string?)null,
                    scalingRule = "Linear",
                }).ToArray(),
                categoryIds = Array.Empty<Guid>(),
                tags = Array.Empty<string>(),
            });
        await CaptureJsonAsync();
    }

    private static async Task<HttpClient> RegisterAndGetSessionClientAsync()
    {
        var client = AcceptanceHooks.Factory.CreateClient(new WebApplicationFactoryClientOptions { AllowAutoRedirect = false });
        var email = $"us04-{Guid.NewGuid():N}@example.test";

        var registerResponse = await client.PostAsJsonAsync(
            new Uri("/api/v1/auth/register", UriKind.Relative),
            new
            {
                email,
                password = Password,
                displayName = "US4 Test User",
                dateOfBirth = DateOnly.FromDateTime(DateTime.UtcNow.AddYears(-30))
                    .ToString("yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture),
            });
        if (!registerResponse.IsSuccessStatusCode)
        {
            var body = await registerResponse.Content.ReadAsStringAsync();
            throw new InvalidOperationException($"Registration failed ({registerResponse.StatusCode}): {body}");
        }

        var token = await AcquireAccessTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        return client;
    }

    /// <summary>Same authorization-code+PKCE exchange as US02IdentitySteps/US03AuthorLibrarySteps' own copy (ADR-0003).</summary>
    private static async Task<string> AcquireAccessTokenAsync(HttpClient sessionClient)
    {
        var codeVerifier = Convert.ToBase64String(RandomNumberGenerator.GetBytes(32)).TrimEnd('=').Replace('+', '-').Replace('/', '_');
        var codeChallenge = Convert.ToBase64String(SHA256.HashData(Encoding.ASCII.GetBytes(codeVerifier))).TrimEnd('=').Replace('+', '-').Replace('/', '_');

        var authorizeUri = QueryHelpers.AddQueryString("/connect/authorize", new Dictionary<string, string?>
        {
            ["client_id"] = "specpour-app",
            ["response_type"] = "code",
            ["redirect_uri"] = RedirectUri,
            ["scope"] = "openid email profile offline_access",
            ["code_challenge"] = codeChallenge,
            ["code_challenge_method"] = "S256",
            ["state"] = Guid.NewGuid().ToString("N"),
        });

        var authorizeResponse = await sessionClient.GetAsync(new Uri(authorizeUri, UriKind.Relative));
        var location = authorizeResponse.Headers.Location
            ?? throw new InvalidOperationException($"/connect/authorize did not redirect (status {authorizeResponse.StatusCode}).");
        var code = QueryHelpers.ParseQuery(location.Query)["code"].ToString();
        if (string.IsNullOrEmpty(code))
        {
            throw new InvalidOperationException($"No authorization code in redirect: {location}");
        }

        var tokenResponse = await sessionClient.PostAsync(
            new Uri("/connect/token", UriKind.Relative),
            new FormUrlEncodedContent(new Dictionary<string, string>
            {
                ["grant_type"] = "authorization_code",
                ["code"] = code,
                ["redirect_uri"] = RedirectUri,
                ["client_id"] = "specpour-app",
                ["code_verifier"] = codeVerifier,
            }));

        var tokenBody = await tokenResponse.Content.ReadAsStringAsync();
        if (!tokenResponse.IsSuccessStatusCode)
        {
            throw new InvalidOperationException($"/connect/token failed ({tokenResponse.StatusCode}): {tokenBody}");
        }

        using var tokenJson = JsonDocument.Parse(tokenBody);
        return tokenJson.RootElement.GetProperty("access_token").GetString()!;
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
