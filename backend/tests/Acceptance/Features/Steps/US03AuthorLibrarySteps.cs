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
/// T056 (Phase 5 entry): US3 acceptance steps, failing first per constitution
/// Principle I — none of POST /recipes, POST /ingredients, POST /venues, or the
/// personal-library/bar-library read filters exist yet (T058/T059/T061). Every
/// scenario here is expected RED until those land.
///
/// Registration/token acquisition is its own copy here (not shared with
/// US02IdentitySteps), matching this project's established per-file convention —
/// Reqnroll step text is bound globally across the whole project, so reusing an
/// identical Given phrase would collide/ambiguously-bind; a distinct phrase
/// ("a signed-in user" vs. US02's "a registered adult user") avoids that, and each
/// file keeps its own private session state deliberately un-shared.
/// </summary>
[Binding]
public sealed class US03AuthorLibrarySteps
{
    private const string Password = "correct horse battery staple";
    private const string RedirectUri = "http://localhost:5001/connect/spa-callback";
    private static readonly string[] VenueExternalReferences = ["https://example.test/venue"];
    private static readonly string[] StandardInstructions = ["Combine all ingredients.", "Serve."];

    private HttpClient? _sessionClient;
    private HttpResponseMessage _lastResponse = null!;
    private JsonDocument? _lastJson;

    private Guid _curatedIngredientId;
    private Guid _createdRecipeId;
    private string _createdRecipeName = string.Empty;
    private Guid _createdVenueId;
    private Guid _houseMadeIngredientId;

    // Scenario 4 needs two independent signed-in identities live at once.
    private HttpClient? _secondUserSessionClient;
    private HttpResponseMessage _secondUserResponse = null!;

    [Given(@"a signed-in user")]
    public async Task GivenASignedInUser() => _sessionClient = await RegisterAndGetSessionClientAsync();

    [Given(@"a curated ingredient the user can reference in a recipe line")]
    public async Task GivenACuratedIngredientTheUserCanReference()
    {
        using var scope = AcceptanceHooks.Factory.Services.CreateScope();
        var ingredientsDb = scope.ServiceProvider.GetRequiredService<IngredientsDbContext>();

        var category = new IngredientCategory
        {
            Id = Guid.NewGuid(),
            NameKey = $"category.spirit.us03test.{Guid.NewGuid():N}",
            Definition = "Base spirits (US03 test fixture).",
        };
        ingredientsDb.IngredientCategories.Add(category);

        var ingredient = new Ingredient
        {
            Id = Guid.NewGuid(),
            OwnerType = OwnerType.System,
            LibraryScope = LibraryScope.Core,
            Name = "White Rum (US03 test)",
            CategoryId = category.Id,
            Visibility = ContentVisibility.Public,
        };
        ingredientsDb.Ingredients.Add(ingredient);
        await ingredientsDb.SaveChangesAsync();

        _curatedIngredientId = ingredient.Id;
    }

    [When(@"the user creates a recipe with a primary name, alternate names, ingredient lines, instructions, and taxonomy")]
    public async Task WhenTheUserCreatesARecipe()
    {
        _createdRecipeName = $"US03 Test Recipe {Guid.NewGuid():N}";
        await CreateRecipeAsync(_sessionClient!, _createdRecipeName, libraryScope: "personal", venueId: null);
    }

    [Then(@"the recipe is saved and appears in the user's personal library")]
    public async Task ThenTheRecipeIsSavedAndAppearsInThePersonalLibrary()
    {
        Assert.Equal(201, (int)_lastResponse.StatusCode);
        _createdRecipeId = _lastJson!.RootElement.GetProperty("id").GetGuid();

        var listResponse = await _sessionClient!.GetAsync(
            new Uri("/api/v1/recipes?scope=personal", UriKind.Relative));
        Assert.Equal(200, (int)listResponse.StatusCode);
        var body = await listResponse.Content.ReadAsStringAsync();
        using var listJson = JsonDocument.Parse(body);
        var items = listJson.RootElement.GetProperty("items").EnumerateArray();
        Assert.Contains(items, item => item.GetProperty("id").GetGuid() == _createdRecipeId);
    }

    [Then(@"the recipe is not returned by an anonymous browse of the public catalog")]
    public async Task ThenTheRecipeIsNotReturnedByAnAnonymousBrowse()
    {
        using var anonymousClient = AcceptanceHooks.Factory.CreateClient();
        var response = await anonymousClient.GetAsync(new Uri("/api/v1/recipes", UriKind.Relative));
        Assert.Equal(200, (int)response.StatusCode);
        var body = await response.Content.ReadAsStringAsync();
        using var json = JsonDocument.Parse(body);
        var items = json.RootElement.GetProperty("items").EnumerateArray();
        Assert.DoesNotContain(items, item => item.GetProperty("id").GetGuid() == _createdRecipeId);
    }

    [When(@"the user defines ""(.*)"" as a house-made ingredient with a component recipe, yield, shelf life, and storage instructions")]
    public async Task WhenTheUserDefinesAHouseMadeIngredient(string ingredientName)
    {
        // FR-017: a house-made ingredient's yield/shelf-life/storage extension hangs
        // off defining_recipe_id — a real Recipe row describing how to make it, not
        // an inline sub-object (data-model.md). Create that recipe first.
        await CreateRecipeAsync(_sessionClient!, $"{ingredientName} (component recipe)", libraryScope: "personal", venueId: null);
        Assert.Equal(201, (int)_lastResponse.StatusCode);
        var componentRecipeId = _lastJson!.RootElement.GetProperty("id").GetGuid();

        _lastResponse = await _sessionClient!.PostAsJsonAsync(
            new Uri("/api/v1/ingredients", UriKind.Relative),
            new
            {
                name = ingredientName,
                libraryScope = "personal",
                houseMade = new
                {
                    definingRecipeId = componentRecipeId,
                    yieldQuantity = 750,
                    yieldUnit = "ml",
                    shelfLifeDays = 30,
                    storageInstructions = "Refrigerate in a sealed bottle.",
                },
            });
        await CaptureJsonAsync();
    }

    [Then(@"the house-made ingredient is saved in the user's personal library")]
    public void ThenTheHouseMadeIngredientIsSaved()
    {
        Assert.Equal(201, (int)_lastResponse.StatusCode);
        _houseMadeIngredientId = _lastJson!.RootElement.GetProperty("id").GetGuid();
        Assert.True(_lastJson.RootElement.GetProperty("houseMade").GetProperty("definingRecipeId").GetGuid() != Guid.Empty);
    }

    [Then(@"the house-made ingredient can be used as an ingredient line in a new recipe")]
    public async Task ThenTheHouseMadeIngredientCanBeUsedInARecipe()
    {
        await CreateRecipeAsync(
            _sessionClient!,
            $"US03 Recipe using house-made {Guid.NewGuid():N}",
            libraryScope: "personal",
            venueId: null,
            ingredientIdOverride: _houseMadeIngredientId);

        Assert.Equal(201, (int)_lastResponse.StatusCode);
    }

    [When(@"the user creates a venue with a name, address, coordinates, and external references")]
    public async Task WhenTheUserCreatesAVenue()
    {
        _lastResponse = await _sessionClient!.PostAsJsonAsync(
            new Uri("/api/v1/venues", UriKind.Relative),
            new
            {
                name = $"US03 Test Venue {Guid.NewGuid():N}",
                address = "123 Bar Street, Cocktail City",
                latitude = 40.7128,
                longitude = -74.0060,
                externalReferences = VenueExternalReferences,
            });
        await CaptureJsonAsync();
    }

    [Then(@"the venue is saved under the user's ownership")]
    public void ThenTheVenueIsSavedUnderTheUsersOwnership()
    {
        Assert.Equal(201, (int)_lastResponse.StatusCode);
        _createdVenueId = _lastJson!.RootElement.GetProperty("id").GetGuid();
    }

    [Then(@"the user can create a recipe scoped to that venue's bar library")]
    public async Task ThenTheUserCanCreateARecipeScopedToTheVenuesBarLibrary()
    {
        await CreateRecipeAsync(_sessionClient!, $"US03 Bar Recipe {Guid.NewGuid():N}", libraryScope: "bar", venueId: _createdVenueId);
        Assert.Equal(201, (int)_lastResponse.StatusCode);
        Assert.Equal("bar", _lastJson!.RootElement.GetProperty("libraryScope").GetString());
    }

    [Given(@"that user has created a private recipe")]
    public async Task GivenThatUserHasCreatedAPrivateRecipe()
    {
        _createdRecipeName = $"US03 Private Recipe {Guid.NewGuid():N}";
        await CreateRecipeAsync(_sessionClient!, _createdRecipeName, libraryScope: "personal", venueId: null);
        Assert.Equal(201, (int)_lastResponse.StatusCode);
        _createdRecipeId = _lastJson!.RootElement.GetProperty("id").GetGuid();
    }

    [Given(@"a second, different signed-in user")]
    public async Task GivenASecondDifferentSignedInUser() => _secondUserSessionClient = await RegisterAndGetSessionClientAsync();

    [When(@"the second user searches for the first user's private recipe by name")]
    public async Task WhenTheSecondUserSearchesForTheFirstUsersPrivateRecipe()
    {
        _secondUserResponse = await _secondUserSessionClient!.GetAsync(
            new Uri($"/api/v1/search?q={Uri.EscapeDataString(_createdRecipeName)}", UriKind.Relative));
    }

    [Then(@"the private recipe never appears in the second user's search results")]
    public async Task ThenThePrivateRecipeNeverAppearsInTheSecondUsersSearchResults()
    {
        Assert.Equal(200, (int)_secondUserResponse.StatusCode);
        var body = await _secondUserResponse.Content.ReadAsStringAsync();
        using var json = JsonDocument.Parse(body);
        var items = json.RootElement.GetProperty("items").EnumerateArray();
        Assert.DoesNotContain(items, item =>
            item.GetProperty("entityType").GetString() == "recipe" &&
            item.GetProperty("entityId").GetGuid() == _createdRecipeId);
    }

    [When(@"the second user browses the first user's personal library directly")]
    public async Task WhenTheSecondUserBrowsesTheFirstUsersPersonalLibraryDirectly()
    {
        _secondUserResponse = await _secondUserSessionClient!.GetAsync(
            new Uri($"/api/v1/recipes/{_createdRecipeId}", UriKind.Relative));
    }

    [Then(@"the private recipe is not accessible to the second user")]
    public void ThenThePrivateRecipeIsNotAccessibleToTheSecondUser() =>
        Assert.True(
            _secondUserResponse.StatusCode is System.Net.HttpStatusCode.NotFound or System.Net.HttpStatusCode.Forbidden,
            $"Expected 404 or 403 for a private recipe accessed by a non-owner; got {(int)_secondUserResponse.StatusCode}.");

    private async Task CreateRecipeAsync(
        HttpClient client, string primaryName, string libraryScope, Guid? venueId, Guid? ingredientIdOverride = null)
    {
        _lastResponse = await client.PostAsJsonAsync(
            new Uri("/api/v1/recipes", UriKind.Relative),
            new
            {
                primaryName,
                alternateNames = new[] { $"{primaryName} (alt)" },
                libraryScope,
                venueId,
                instructions = StandardInstructions,
                ingredientLines = new[]
                {
                    new
                    {
                        ingredientId = ingredientIdOverride ?? _curatedIngredientId,
                        quantity = 2m,
                        unit = "oz",
                        purpose = (string?)null,
                        scalingRule = "Linear",
                    },
                },
                categoryIds = Array.Empty<Guid>(),
                tags = Array.Empty<string>(),
            });
        await CaptureJsonAsync();
    }

    private static async Task<HttpClient> RegisterAndGetSessionClientAsync()
    {
        var client = AcceptanceHooks.Factory.CreateClient(new WebApplicationFactoryClientOptions { AllowAutoRedirect = false });
        var email = $"us03-{Guid.NewGuid():N}@example.test";

        var registerResponse = await client.PostAsJsonAsync(
            new Uri("/api/v1/auth/register", UriKind.Relative),
            new
            {
                email,
                password = Password,
                displayName = "US3 Test User",
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

    /// <summary>Same authorization-code+PKCE exchange as US02IdentitySteps' own copy (ADR-0003).</summary>
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
