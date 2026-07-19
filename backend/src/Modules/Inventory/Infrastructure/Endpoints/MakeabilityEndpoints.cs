using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using OpenIddict.Abstractions;
using OpenIddict.Validation.AspNetCore;
using SpecPour.BuildingBlocks.Http;
using SpecPour.BuildingBlocks.Library;
using SpecPour.Modules.Catalog.Contracts;
using SpecPour.Modules.Ingredients.Contracts;
using SpecPour.Modules.Inventory.Application.Makeability;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Inventory.Infrastructure.Endpoints;

/// <summary>
/// GET /api/v1/inventory/makeable (T067, FR-031). Bearer-only, checked against the
/// caller's personal inventory only (a venue-inventory variant is not built — no
/// acceptance scenario or task text calls for it yet). See
/// <see cref="MakeabilityCalculator"/> for the actual hierarchy/substitution
/// resolution; this endpoint's own job is fetching the domain data it needs and
/// resolving ingredient names for the response (name-resolution sweep convention).
/// </summary>
public static class MakeabilityEndpoints
{
    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        var bearerOnly = new AuthorizeAttribute
        {
            AuthenticationSchemes = OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme,
        };

        group.MapGet("/inventory/makeable", GetAsync).RequireAuthorization(bearerOnly);
    }

    private static async Task<MakeableResponse> GetAsync(
        ClaimsPrincipal user,
        InventoryDbContext db,
        IRecipeLookupPort recipeLookup,
        IIngredientLookupPort ingredientLookup,
        MakeabilityCalculator calculator,
        CancellationToken cancellationToken)
    {
        var userId = Guid.Parse(user.GetClaim(Claims.Subject)!);

        var inventoryItems = await db.InventoryItems
            .Where(i => i.OwnerType == OwnerType.User && i.OwnerId == userId)
            .Select(i => new { i.Id, i.IngredientId })
            .ToListAsync(cancellationToken);
        var inventoryPairs = inventoryItems.Select(i => (i.Id, i.IngredientId)).ToList();

        var recipes = await recipeLookup.GetRecipesForMakeabilityAsync(userId, cancellationToken);

        var result = await calculator.ComputeAsync(inventoryPairs, recipes, cancellationToken);

        var involvedIngredientIds = result.Makeable.SelectMany(r => r.Lines)
            .Concat(result.NearMiss.SelectMany(r => r.Lines))
            .SelectMany(l => new[] { l.RequirementIngredientId, l.SatisfiedByIngredientId })
            .Where(id => id.HasValue)
            .Select(id => id!.Value)
            .Distinct()
            .ToList();
        var names = await ingredientLookup.GetSummariesAsync(involvedIngredientIds, cancellationToken);

        return new MakeableResponse(
            [.. result.Makeable.Select(r => ToResponse(r, names))],
            [.. result.NearMiss.Select(r => ToResponse(r, names))]);
    }

    private static MakeableRecipeResponse ToResponse(MakeableRecipe recipe, IReadOnlyDictionary<Guid, IngredientSummary> names) =>
        new(recipe.RecipeId, recipe.RecipeName, recipe.MatchQuality, [.. recipe.Lines.Select(l => ToResponse(l, names))]);

    private static NearMissRecipeResponse ToResponse(NearMissRecipe recipe, IReadOnlyDictionary<Guid, IngredientSummary> names) =>
        new(recipe.RecipeId, recipe.RecipeName, [.. recipe.Lines.Select(l => ToResponse(l, names))]);

    private static LineResponse ToResponse(RecipeLineMatch line, IReadOnlyDictionary<Guid, IngredientSummary> names)
    {
        var requirement = new RequirementResponse(
            line.RequirementIngredientId,
            names.TryGetValue(line.RequirementIngredientId, out var reqSummary) ? reqSummary.Name : null,
            line.RequirementQuantity,
            line.RequirementUnit);

        var satisfiedBy = line.SatisfiedByInventoryItemId is { } inventoryItemId && line.SatisfiedByIngredientId is { } ingredientId
            ? new SatisfiedByResponse(inventoryItemId, ingredientId, names.TryGetValue(ingredientId, out var heldSummary) ? heldSummary.Name : null)
            : null;

        return new LineResponse(requirement, line.MatchQuality, satisfiedBy);
    }
}

public sealed record RequirementResponse(Guid IngredientId, string? IngredientName, decimal Quantity, string Unit);

public sealed record SatisfiedByResponse(Guid InventoryItemId, Guid IngredientId, string? IngredientName);

public sealed record LineResponse(RequirementResponse Requirement, string MatchQuality, SatisfiedByResponse? SatisfiedBy);

public sealed record MakeableRecipeResponse(Guid RecipeId, string RecipeName, string MatchQuality, IReadOnlyList<LineResponse> Lines);

public sealed record NearMissRecipeResponse(Guid RecipeId, string RecipeName, IReadOnlyList<LineResponse> Lines);

public sealed record MakeableResponse(IReadOnlyList<MakeableRecipeResponse> Makeable, IReadOnlyList<NearMissRecipeResponse> NearMiss);
