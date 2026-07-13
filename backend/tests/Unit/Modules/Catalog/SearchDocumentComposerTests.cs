using SpecPour.BuildingBlocks.Library;
using SpecPour.Modules.Catalog.Application.Search;
using SpecPour.Modules.Catalog.Domain;
using SpecPour.Modules.Measurements.Contracts;

namespace SpecPour.Tests.Unit.Modules.Catalog;

/// <summary>T155/ADR-0002: unit coverage for the pure search-document composition rule (amended FR-049).</summary>
public sealed class SearchDocumentComposerTests
{
    private static Recipe MakeRecipe(
        string primaryName,
        IReadOnlyList<string>? alternateNames = null,
        IReadOnlyList<string>? garnishes = null,
        string? history = null,
        string? notes = null)
    {
        var now = DateTimeOffset.UtcNow;
        return new Recipe
        {
            Id = Guid.NewGuid(),
            OwnerType = OwnerType.System,
            LibraryScope = LibraryScope.Core,
            PrimaryName = primaryName,
            AlternateNames = alternateNames ?? [],
            Garnishes = garnishes ?? [],
            History = history,
            Notes = notes,
            Method = MixMethod.Shaken,
            IceSpec = "Crushed",
            Visibility = ContentVisibility.Public,
            CreatedAt = now,
            UpdatedAt = now,
        };
    }

    [Fact]
    public void IncludesIngredientNamesSoSearchingAnIngredientSurfacesTheRecipe()
    {
        var recipe = MakeRecipe("Mai Tai");

        var document = SearchDocumentComposer.Compose(recipe, ["Aged Rum", "Lime Juice"]);

        Assert.Contains("Aged Rum", document);
        Assert.Contains("Mai Tai", document);
    }

    [Fact]
    public void IncludesAlternateNamesGarnishesAndHistory()
    {
        var recipe = MakeRecipe(
            "Mai Tai",
            alternateNames: ["Trader Vic's Mai Tai"],
            garnishes: ["Mint sprig"],
            history: "Created in 1944.");

        var document = SearchDocumentComposer.Compose(recipe, []);

        Assert.Contains("Trader Vic's Mai Tai", document);
        Assert.Contains("Mint sprig", document);
        Assert.Contains("Created in 1944.", document);
    }

    [Fact]
    public void OmitsNullOrEmptyFieldsWithoutStrayWhitespace()
    {
        var recipe = MakeRecipe("Daiquiri");

        var document = SearchDocumentComposer.Compose(recipe, []);

        Assert.Equal("Daiquiri", document);
    }
}
