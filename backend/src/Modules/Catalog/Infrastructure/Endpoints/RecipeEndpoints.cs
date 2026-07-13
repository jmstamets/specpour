using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Http;
using SpecPour.BuildingBlocks.Library;
using SpecPour.Modules.Catalog.Application.DerivedData;
using SpecPour.Modules.Catalog.Domain;

namespace SpecPour.Modules.Catalog.Infrastructure.Endpoints;

/// <summary>
/// GET /api/v1/recipes, GET /api/v1/recipes/{id} (T037, contracts/openapi/paths/catalog.yaml).
/// Guest-accessible (FR-004b) — only <see cref="ContentVisibility.Public"/> recipes
/// are returned; owner-scoped private-library reads land with the personal-library
/// story (US3), not here.
/// </summary>
public static class RecipeEndpoints
{
    private const int DefaultLimit = 20;

    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        group.MapGet("/recipes", ListAsync);
        group.MapGet("/recipes/{id:guid}", GetAsync);
    }

    private static async Task<RecipePageResponse> ListAsync(
        string? family,
        string? category,
        string? tag,
        string? flavorProfile,
        string? equipment,
        string? glassware,
        string? ice,
        string? uses,
        string? allergenExclude,
        string? source,
        string? cursor,
        int? limit,
        CatalogDbContext db,
        Ingredients.Contracts.IIngredientLookupPort ingredientLookup,
        Contracts.IRecipeLookupPort recipeLookup,
        CancellationToken cancellationToken)
    {
        var pageSize = Math.Clamp(limit ?? DefaultLimit, 1, 100);
        var offset = CursorPagination.Decode(cursor);

        // "source" facet (core library / my library / public, FR-050): V1 has no
        // authenticated-caller context wired into this guest-facing endpoint yet
        // (that lands with the personal-library story, US3), so every result here
        // is implicitly "core" — a non-"core" source value matches nothing rather
        // than silently ignoring the filter.
        if (source is not null && !string.Equals(source, "core", StringComparison.OrdinalIgnoreCase))
        {
            return new RecipePageResponse([], null);
        }

        var query = db.Recipes.Where(r => r.Visibility == ContentVisibility.Public);

        if (family is not null)
        {
            query = query.Where(r => db.Families.Any(f => f.Id == r.FamilyId && f.NameKey == family));
        }

        if (category is not null)
        {
            query = query.Where(r => db.RecipeCategories.Any(rc => rc.RecipeId == r.Id && db.Categories.Any(c => c.Id == rc.CategoryId && c.NameKey == category)));
        }

        if (tag is not null)
        {
            query = query.Where(r => db.RecipeTags.Any(rt => rt.RecipeId == r.Id && db.Tags.Any(t => t.Id == rt.TagId && t.Key == tag)));
        }

        if (flavorProfile is not null)
        {
            query = query.Where(r => db.RecipeFlavorProfiles.Any(rf => rf.RecipeId == r.Id && db.FlavorProfiles.Any(f => f.Id == rf.FlavorProfileId && f.NameKey == flavorProfile)));
        }

        if (ice is not null)
        {
            query = query.Where(r => r.IceSpec == ice);
        }

        var recipes = await query.OrderBy(r => r.PrimaryName).ToListAsync(cancellationToken);

        // Equipment/glassware/allergen-exclude facets cross into other modules'
        // schemas (equipment/ingredients) — applied in-memory after the same-schema
        // filters above rather than as a SQL join, consistent with every other
        // cross-module reference in this codebase never taking a hard FK/join
        // dependency on another module's tables (ADR-0001/constitution Principle III).
        if (equipment is not null && Guid.TryParse(equipment, out var equipmentId))
        {
            var recipeIds = await db.RecipeEquipment.Where(re => re.EquipmentId == equipmentId).Select(re => re.RecipeId).ToListAsync(cancellationToken);
            recipes = [.. recipes.Where(r => recipeIds.Contains(r.Id))];
        }

        if (glassware is not null && Guid.TryParse(glassware, out var glasswareId))
        {
            var recipeIds = await db.RecipeGlassware.Where(rg => rg.EquipmentId == glasswareId).Select(rg => rg.RecipeId).ToListAsync(cancellationToken);
            recipes = [.. recipes.Where(r => recipeIds.Contains(r.Id))];
        }

        // T155/FR-050: hierarchy-aware "uses:<ingredient>" facet — a class-level
        // ingredient (e.g. "Rum") matches recipes using it or any descendant ("Aged
        // Rum", "White Rum", ...). Same in-memory post-filter shape as
        // equipment/glassware above (same reasoning — crosses into ingredients' schema).
        if (uses is not null && Guid.TryParse(uses, out var usesIngredientId))
        {
            var descendantIds = await ingredientLookup.GetDescendantIdsAsync(usesIngredientId, cancellationToken);
            var recipeIds = await recipeLookup.GetRecipeIdsUsingIngredientsAsync(descendantIds, cancellationToken);
            recipes = [.. recipes.Where(r => recipeIds.Contains(r.Id))];
        }

        if (allergenExclude is not null)
        {
            var excluded = new HashSet<string>(allergenExclude.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries), StringComparer.OrdinalIgnoreCase);
            var survivors = new List<Recipe>();
            foreach (var recipe in recipes)
            {
                var lines = await db.RecipeIngredientLines.Where(l => l.RecipeId == recipe.Id).ToListAsync(cancellationToken);
                var summaries = await ingredientLookup.GetSummariesAsync([.. lines.Select(l => l.IngredientId).Distinct()], cancellationToken);
                var allergens = summaries.Values.SelectMany(s => s.AllergenKeys);
                if (!allergens.Any(excluded.Contains))
                {
                    survivors.Add(recipe);
                }
            }

            recipes = survivors;
        }

        var page = recipes.Skip(offset).Take(pageSize + 1).ToList();
        var hasMore = page.Count > pageSize;
        page = hasMore ? page[..pageSize] : page;
        var nextCursor = hasMore ? CursorPagination.Encode(offset + pageSize) : null;

        var familyKeysById = await db.Families.ToDictionaryAsync(f => f.Id, f => f.NameKey, cancellationToken);

        var items = page.Select(r => new RecipeSummaryResponse(
            r.Id,
            r.PrimaryName,
            r.FamilyId is { } familyId && familyKeysById.TryGetValue(familyId, out var familyKey) ? familyKey : null))
            .ToList();

        return new RecipePageResponse(items, nextCursor);
    }

    private static async Task<Results<Ok<RecipeDetailResponse>, NotFound>> GetAsync(
        Guid id,
        CatalogDbContext db,
        IRecipeDerivedDataCalculator calculator,
        Ingredients.Contracts.IIngredientLookupPort ingredientLookup,
        Equipment.Contracts.IEquipmentLookupPort equipmentLookup,
        CancellationToken cancellationToken)
    {
        var recipe = await db.Recipes.FirstOrDefaultAsync(r => r.Id == id && r.Visibility == ContentVisibility.Public, cancellationToken);
        if (recipe is null)
        {
            return TypedResults.NotFound();
        }

        var lines = await db.RecipeIngredientLines.Where(l => l.RecipeId == id).OrderBy(l => l.Position).ToListAsync(cancellationToken);
        var derived = await calculator.CalculateAsync(recipe, lines, cancellationToken);

        var familyKey = recipe.FamilyId.HasValue
            ? await db.Families.Where(f => f.Id == recipe.FamilyId).Select(f => f.NameKey).FirstOrDefaultAsync(cancellationToken)
            : null;

        var categoryKeys = await db.RecipeCategories.Where(rc => rc.RecipeId == id)
            .Join(db.Categories, rc => rc.CategoryId, c => c.Id, (rc, c) => c.NameKey)
            .ToListAsync(cancellationToken);

        var flavorProfileKeys = await db.RecipeFlavorProfiles.Where(rf => rf.RecipeId == id)
            .Join(db.FlavorProfiles, rf => rf.FlavorProfileId, f => f.Id, (rf, f) => f.NameKey)
            .ToListAsync(cancellationToken);

        var tagKeys = await db.RecipeTags.Where(rt => rt.RecipeId == id)
            .Join(db.Tags, rt => rt.TagId, t => t.Id, (rt, t) => t.Key)
            .ToListAsync(cancellationToken);

        var glasswareIds = await db.RecipeGlassware.Where(rg => rg.RecipeId == id).Select(rg => rg.EquipmentId).ToListAsync(cancellationToken);
        var equipmentIds = await db.RecipeEquipment.Where(re => re.RecipeId == id).Select(re => re.EquipmentId).ToListAsync(cancellationToken);

        // Resolve glassware/equipment IDs to names (contract sweep) — a raw GUID
        // can't be rendered as FR-020's "acceptable glasses" / "required equipment"
        // list. Cross-module into the equipment schema via its lookup port.
        var equipmentNames = await equipmentLookup.GetNamesAsync(
            [.. glasswareIds.Concat(equipmentIds).Distinct()], cancellationToken);
        var glassware = glasswareIds
            .Select(e => new EquipmentRefResponse(e, equipmentNames.GetValueOrDefault(e)))
            .ToList();
        var equipment = equipmentIds
            .Select(e => new EquipmentRefResponse(e, equipmentNames.GetValueOrDefault(e)))
            .ToList();

        // A raw ingredientId is meaningless to render — FR-020's "ingredient
        // reference" needs the referenced ingredient's name to actually display
        // an ingredient line. Reuses the same cross-module lookup port the ABV
        // calculator above already needed.
        var ingredientSummaries = await ingredientLookup.GetSummariesAsync(
            [.. lines.Select(l => l.IngredientId).Distinct()], cancellationToken);
        var ingredientLines = lines.Select(l => new RecipeIngredientLineResponse(
            l.Position,
            l.IngredientId,
            ingredientSummaries.TryGetValue(l.IngredientId, out var summary) ? summary.Name : null,
            l.Quantity,
            l.Unit,
            l.Purpose,
            l.ScalingRule.ToString())).ToList();

        return TypedResults.Ok(new RecipeDetailResponse(
            recipe.Id,
            recipe.PrimaryName,
            recipe.AlternateNames,
            familyKey,
            categoryKeys,
            flavorProfileKeys,
            tagKeys,
            ingredientLines,
            recipe.Instructions,
            recipe.Garnishes,
            recipe.IceSpec,
            glassware,
            equipment,
            recipe.CreatorAttribution,
            recipe.History,
            recipe.Notes,
            derived.AbvPercent,
            derived.StandardDrinks,
            derived.Allergens));
    }
}

public sealed record RecipePageResponse(IReadOnlyList<RecipeSummaryResponse> Items, string? NextCursor);

public sealed record RecipeSummaryResponse(Guid Id, string PrimaryName, string? FamilyKey);

public sealed record RecipeIngredientLineResponse(int Position, Guid IngredientId, string? IngredientName, decimal Quantity, string Unit, string? Purpose, string ScalingRule);

/// <summary>A recipe's glassware/equipment reference — the cross-module equipment ID plus its resolved name (contract sweep). Name is null only if the equipment can no longer be resolved.</summary>
public sealed record EquipmentRefResponse(Guid Id, string? Name);

public sealed record RecipeDetailResponse(
    Guid Id,
    string PrimaryName,
    IReadOnlyList<string> AlternateNames,
    string? FamilyKey,
    IReadOnlyList<string> CategoryKeys,
    IReadOnlyList<string> FlavorProfileKeys,
    IReadOnlyList<string> Tags,
    IReadOnlyList<RecipeIngredientLineResponse> IngredientLines,
    IReadOnlyList<string> Instructions,
    IReadOnlyList<string> Garnishes,
    string IceSpec,
    IReadOnlyList<EquipmentRefResponse> Glassware,
    IReadOnlyList<EquipmentRefResponse> Equipment,
    string? CreatorAttribution,
    string? History,
    string? Notes,
    decimal AbvPercent,
    decimal StandardDrinks,
    IReadOnlyList<string> Allergens);
