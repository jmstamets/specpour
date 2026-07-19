using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using OpenIddict.Abstractions;
using OpenIddict.Validation.AspNetCore;
using SpecPour.BuildingBlocks.Http;
using SpecPour.BuildingBlocks.Identifiers;
using SpecPour.BuildingBlocks.Library;
using SpecPour.Modules.Ingredients.Contracts;
using SpecPour.Modules.Ingredients.Domain;
using SpecPour.Modules.Venues.Contracts;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Ingredients.Infrastructure.Endpoints;

/// <summary>
/// GET /api/v1/ingredients, GET /api/v1/ingredients/{id} (T037, FR-014). Guest-accessible
/// (FR-004b) — only <see cref="ContentVisibility.Public"/> ingredients are returned to
/// a guest/non-owner.
///
/// POST/PUT/DELETE /api/v1/ingredients (T059, FR-012/FR-016/FR-017): bearer-only author
/// CRUD with the house-made extension (defining recipe, yield, shelf life, storage) and
/// circular-reference rejection — the defining recipe must not transitively include the
/// ingredient itself.
/// </summary>
public static class IngredientEndpoints
{
    private const int DefaultLimit = 20;

    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        var bearerOnly = new AuthorizeAttribute
        {
            AuthenticationSchemes = OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme,
        };

        group.MapGet("/ingredients", ListAsync);
        group.MapGet("/ingredients/{id:guid}", GetAsync);
        group.MapGet("/ingredients/{id:guid}/recipes", GetRecipesUsingIngredientAsync);
        group.MapPost("/ingredients", CreateAsync).RequireAuthorization(bearerOnly);
        group.MapPut("/ingredients/{id:guid}", UpdateAsync).RequireAuthorization(bearerOnly);
        group.MapDelete("/ingredients/{id:guid}", DeleteAsync).RequireAuthorization(bearerOnly);
    }

    private static async Task<Results<Ok<IngredientPageResponse>, ProblemHttpResult>> ListAsync(
        string? category, string? scope, string? cursor, int? limit, ClaimsPrincipal user, IngredientsDbContext db, CancellationToken cancellationToken)
    {
        var pageSize = Math.Clamp(limit ?? DefaultLimit, 1, 100);
        var offset = CursorPagination.Decode(cursor);

        IQueryable<Ingredient> query;
        if (scope is not null)
        {
            // T059/T063 (recipe editor's ingredient picker needs the caller's own
            // house-made/personal ingredients, not just curated public ones): "my
            // library" facet, same shape as RecipeEndpoints.ListAsync's `scope`.
            if (user.Identity?.IsAuthenticated != true)
            {
                return TypedResults.Problem(title: "Sign-in required", statusCode: StatusCodes.Status401Unauthorized);
            }

            if (!string.Equals(scope, "personal", StringComparison.OrdinalIgnoreCase))
            {
                return TypedResults.Ok(new IngredientPageResponse([], null));
            }

            var userId = CurrentUserId(user);
            query = db.Ingredients.Where(i => i.OwnerType == OwnerType.User && i.OwnerId == userId && i.LibraryScope == LibraryScope.Personal);
        }
        else
        {
            query = db.Ingredients.Where(i => i.Visibility == ContentVisibility.Public);
        }

        if (category is not null)
        {
            query = query.Where(i => db.IngredientCategories.Any(c => c.Id == i.CategoryId && c.NameKey == category));
        }

        var ingredients = await query.OrderBy(i => i.Name).Skip(offset).Take(pageSize + 1).ToListAsync(cancellationToken);
        var hasMore = ingredients.Count > pageSize;
        var page = hasMore ? ingredients[..pageSize] : ingredients;
        var nextCursor = hasMore ? CursorPagination.Encode(offset + pageSize) : null;

        // Resolve parent-ingredient names (contract sweep) so a hierarchy-aware
        // browse (FR-014) can render "child of X", not a raw GUID. Same-module
        // (parents are ingredients too), batched in one query.
        var parentIds = page.Where(i => i.ParentId.HasValue).Select(i => i.ParentId!.Value).Distinct().ToList();
        var parentNames = await db.Ingredients
            .Where(i => parentIds.Contains(i.Id))
            .ToDictionaryAsync(i => i.Id, i => i.Name, cancellationToken);

        return TypedResults.Ok(new IngredientPageResponse(
            [.. page.Select(i => new IngredientSummaryResponse(
                i.Id,
                i.Name,
                i.ParentId,
                i.ParentId is { } pid ? parentNames.GetValueOrDefault(pid) : null))],
            nextCursor));
    }

    private static async Task<Results<Ok<IngredientDetailResponse>, NotFound>> GetAsync(
        Guid id,
        ClaimsPrincipal user,
        IngredientsDbContext db,
        Catalog.Contracts.IRecipeLookupPort recipeLookup,
        IVenueOwnershipPort venueOwnership,
        CancellationToken cancellationToken)
    {
        var ingredient = await db.Ingredients.FirstOrDefaultAsync(i => i.Id == id, cancellationToken);
        if (ingredient is null)
        {
            return TypedResults.NotFound();
        }

        if (ingredient.Visibility != ContentVisibility.Public && !await IsOwnerAsync(ingredient, user, venueOwnership, cancellationToken))
        {
            return TypedResults.NotFound();
        }

        var allergenKeys = await db.IngredientAllergens.Where(a => a.IngredientId == id)
            .Join(db.Allergens, a => a.AllergenId, al => al.Id, (a, al) => al.Key)
            .ToListAsync(cancellationToken);

        // Resolve the parent-ingredient name (same-module) and the defining-recipe
        // name (cross-module into catalog, for house-made ingredients) — contract
        // sweep, so the detail screen can render these references by name (FR-014/FR-017).
        var parentName = ingredient.ParentId is { } parentId
            ? await db.Ingredients.Where(i => i.Id == parentId).Select(i => i.Name).FirstOrDefaultAsync(cancellationToken)
            : null;

        string? definingRecipeName = null;
        if (ingredient.DefiningRecipeId is { } definingRecipeId)
        {
            var names = await recipeLookup.GetNamesAsync([definingRecipeId], cancellationToken);
            definingRecipeName = names.GetValueOrDefault(definingRecipeId);
        }

        return TypedResults.Ok(new IngredientDetailResponse(
            ingredient.Id,
            ingredient.Name,
            ingredient.ParentId,
            parentName,
            ingredient.Sources,
            ingredient.Description,
            ingredient.AbvPercent,
            allergenKeys,
            ingredient.DefiningRecipeId,
            definingRecipeName,
            ingredient.YieldQuantity,
            ingredient.YieldUnit,
            ingredient.ShelfLife,
            ingredient.StorageInstructions));
    }

    /// <summary>
    /// GET /api/v1/ingredients/{id}/recipes (T155, FR-014a): every ingredient entry
    /// surfaces the recipes that use it, hierarchy-aware — a class-level ingredient
    /// (e.g. "Rum") lists recipes using it or any descendant ("Aged Rum", "White
    /// Rum", ...), mirroring FR-024's equipment-&gt;recipes linking. Unpaginated: a
    /// single ingredient's usage list is small at V1 scale (add pagination if that
    /// changes).
    /// </summary>
    private static async Task<Results<Ok<IngredientRecipesResponse>, NotFound>> GetRecipesUsingIngredientAsync(
        Guid id,
        IngredientsDbContext db,
        IIngredientLookupPort ingredientLookup,
        Catalog.Contracts.IRecipeLookupPort recipeLookup,
        CancellationToken cancellationToken)
    {
        var exists = await db.Ingredients.AnyAsync(i => i.Id == id && i.Visibility == ContentVisibility.Public, cancellationToken);
        if (!exists)
        {
            return TypedResults.NotFound();
        }

        var descendantIds = await ingredientLookup.GetDescendantIdsAsync(id, cancellationToken);
        var recipeIds = await recipeLookup.GetRecipeIdsUsingIngredientsAsync(descendantIds, cancellationToken);
        var recipeNames = await recipeLookup.GetNamesAsync(recipeIds, cancellationToken);

        var items = recipeIds
            .Where(recipeNames.ContainsKey)
            .Select(recipeId => new IngredientRecipeRefResponse(recipeId, recipeNames[recipeId]))
            .OrderBy(r => r.Name, StringComparer.Ordinal)
            .ToList();

        return TypedResults.Ok(new IngredientRecipesResponse(items));
    }

    private static async Task<Results<Created<IngredientAuthorResponse>, ProblemHttpResult>> CreateAsync(
        CreateIngredientRequest request,
        ClaimsPrincipal user,
        IngredientsDbContext db,
        IUuidGenerator uuidGenerator,
        Catalog.Contracts.IRecipeLookupPort recipeLookup,
        IVenueOwnershipPort venueOwnership,
        CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);

        if (!TryParseAuthorLibraryScope(request.LibraryScope, out var libraryScope))
        {
            return TypedResults.Problem(title: "Invalid libraryScope", detail: "libraryScope must be 'personal' or 'bar'.", statusCode: StatusCodes.Status400BadRequest);
        }

        OwnerType ownerType;
        Guid ownerId;
        if (libraryScope == LibraryScope.Bar)
        {
            if (request.VenueId is not { } venueId)
            {
                return TypedResults.Problem(title: "venueId required", detail: "A bar-scoped ingredient must reference a venueId.", statusCode: StatusCodes.Status400BadRequest);
            }

            if (!await venueOwnership.IsOwnedByAsync(venueId, userId, cancellationToken))
            {
                return TypedResults.Problem(title: "Not your venue", statusCode: StatusCodes.Status403Forbidden);
            }

            ownerType = OwnerType.Venue;
            ownerId = venueId;
        }
        else
        {
            ownerType = OwnerType.User;
            ownerId = userId;
        }

        // T059: a create request needn't navigate the curated category taxonomy to
        // author an ingredient — default to a fixed system fallback category
        // (IngredientsDbContextSeedIds.UncategorizedCategory) when none is supplied.
        var categoryId = request.CategoryId ?? IngredientsDbContextSeedIds.UncategorizedCategory;
        if (!await db.IngredientCategories.AnyAsync(c => c.Id == categoryId, cancellationToken))
        {
            return TypedResults.Problem(title: "Unknown category", statusCode: StatusCodes.Status400BadRequest);
        }

        if (request.ParentId is { } parentId && !await db.Ingredients.AnyAsync(i => i.Id == parentId, cancellationToken))
        {
            return TypedResults.Problem(title: "Unknown parent ingredient", statusCode: StatusCodes.Status400BadRequest);
        }

        TimeSpan? shelfLife = null;
        if (request.HouseMade is { } houseMade)
        {
            var names = await recipeLookup.GetNamesAsync([houseMade.DefiningRecipeId], cancellationToken);
            if (!names.ContainsKey(houseMade.DefiningRecipeId))
            {
                return TypedResults.Problem(title: "Unknown defining recipe", statusCode: StatusCodes.Status400BadRequest);
            }

            // A brand-new ingredient can't already appear in its own defining
            // recipe's lines (nothing could have referenced an ID that didn't exist
            // yet) — circular-reference rejection only applies on UPDATE, when an
            // ALREADY-EXISTING ingredient's defining recipe is changed.
            shelfLife = TimeSpan.FromDays(houseMade.ShelfLifeDays);
        }

        var ingredient = new Ingredient
        {
            Id = uuidGenerator.NewId(),
            OwnerType = ownerType,
            OwnerId = ownerId,
            LibraryScope = libraryScope,
            Name = request.Name,
            CategoryId = categoryId,
            ParentId = request.ParentId,
            AbvPercent = request.AbvPercent,
            Sources = request.Sources ?? [],
            Description = request.Description,

            // T059: authored content always starts private (FR-008b) — same
            // publish-is-a-distinct-flow reasoning as RecipeEndpoints.CreateAsync.
            Visibility = ContentVisibility.Private,
            DefiningRecipeId = request.HouseMade?.DefiningRecipeId,
            YieldQuantity = request.HouseMade?.YieldQuantity,
            YieldUnit = request.HouseMade?.YieldUnit,
            ShelfLife = shelfLife,
            StorageInstructions = request.HouseMade?.StorageInstructions,
        };

        db.Ingredients.Add(ingredient);
        await db.SaveChangesAsync(cancellationToken);

        var response = await BuildAuthorResponseAsync(ingredient, recipeLookup, cancellationToken);
        return TypedResults.Created($"/api/v1/ingredients/{ingredient.Id}", response);
    }

    private static async Task<Results<Ok<IngredientAuthorResponse>, NotFound, ProblemHttpResult>> UpdateAsync(
        Guid id,
        UpdateIngredientRequest request,
        ClaimsPrincipal user,
        IngredientsDbContext db,
        Catalog.Contracts.IRecipeLookupPort recipeLookup,
        IVenueOwnershipPort venueOwnership,
        CancellationToken cancellationToken)
    {
        var ingredient = await db.Ingredients.FirstOrDefaultAsync(i => i.Id == id, cancellationToken);
        if (ingredient is null || !await IsOwnerAsync(ingredient, user, venueOwnership, cancellationToken))
        {
            return TypedResults.NotFound();
        }

        var categoryId = request.CategoryId ?? IngredientsDbContextSeedIds.UncategorizedCategory;
        if (!await db.IngredientCategories.AnyAsync(c => c.Id == categoryId, cancellationToken))
        {
            return TypedResults.Problem(title: "Unknown category", statusCode: StatusCodes.Status400BadRequest);
        }

        if (request.ParentId is { } parentId)
        {
            if (parentId == id)
            {
                return TypedResults.Problem(title: "Invalid parent", detail: "An ingredient cannot be its own parent.", statusCode: StatusCodes.Status400BadRequest);
            }

            if (!await db.Ingredients.AnyAsync(i => i.Id == parentId, cancellationToken))
            {
                return TypedResults.Problem(title: "Unknown parent ingredient", statusCode: StatusCodes.Status400BadRequest);
            }
        }

        TimeSpan? shelfLife = null;
        if (request.HouseMade is { } houseMade)
        {
            var names = await recipeLookup.GetNamesAsync([houseMade.DefiningRecipeId], cancellationToken);
            if (!names.ContainsKey(houseMade.DefiningRecipeId))
            {
                return TypedResults.Problem(title: "Unknown defining recipe", statusCode: StatusCodes.Status400BadRequest);
            }

            // FR-017 edge case: the defining recipe must not transitively include
            // this ingredient itself.
            if (await IsCircularHouseMadeReferenceAsync(id, houseMade.DefiningRecipeId, db, recipeLookup, cancellationToken))
            {
                return TypedResults.Problem(
                    title: "Circular house-made reference",
                    detail: "The defining recipe transitively includes this ingredient.",
                    statusCode: StatusCodes.Status400BadRequest);
            }

            shelfLife = TimeSpan.FromDays(houseMade.ShelfLifeDays);
        }

        ingredient.Name = request.Name;
        ingredient.CategoryId = categoryId;
        ingredient.ParentId = request.ParentId;
        ingredient.AbvPercent = request.AbvPercent;
        ingredient.Sources = request.Sources ?? [];
        ingredient.Description = request.Description;
        ingredient.DefiningRecipeId = request.HouseMade?.DefiningRecipeId;
        ingredient.YieldQuantity = request.HouseMade?.YieldQuantity;
        ingredient.YieldUnit = request.HouseMade?.YieldUnit;
        ingredient.ShelfLife = shelfLife;
        ingredient.StorageInstructions = request.HouseMade?.StorageInstructions;

        await db.SaveChangesAsync(cancellationToken);

        var response = await BuildAuthorResponseAsync(ingredient, recipeLookup, cancellationToken);
        return TypedResults.Ok(response);
    }

    private static async Task<Results<NoContent, NotFound>> DeleteAsync(
        Guid id, ClaimsPrincipal user, IngredientsDbContext db, IVenueOwnershipPort venueOwnership, CancellationToken cancellationToken)
    {
        var ingredient = await db.Ingredients.FirstOrDefaultAsync(i => i.Id == id, cancellationToken);
        if (ingredient is null || !await IsOwnerAsync(ingredient, user, venueOwnership, cancellationToken))
        {
            return TypedResults.NotFound();
        }

        db.Ingredients.Remove(ingredient);
        await db.SaveChangesAsync(cancellationToken);
        return TypedResults.NoContent();
    }

    private static async Task<bool> IsOwnerAsync(Ingredient ingredient, ClaimsPrincipal user, IVenueOwnershipPort venueOwnership, CancellationToken cancellationToken)
    {
        if (user.Identity?.IsAuthenticated != true)
        {
            return false;
        }

        var userId = CurrentUserId(user);
        return ingredient.OwnerType switch
        {
            OwnerType.User => ingredient.OwnerId == userId,
            OwnerType.Venue => ingredient.OwnerId is { } venueId && await venueOwnership.IsOwnedByAsync(venueId, userId, cancellationToken),
            _ => false,
        };
    }

    /// <summary>
    /// FR-017's circular-reference edge case: walks from <paramref name="definingRecipeId"/>
    /// through its ingredient lines and, transitively, any house-made ingredient among
    /// them's OWN defining recipe — if <paramref name="ingredientId"/> ever turns up,
    /// this ingredient's own defining recipe would (directly or transitively) require
    /// itself to exist first. Bounded (200 recipes) as a defensive guard against
    /// malformed data producing an unbounded walk, not because a legitimate house-made
    /// chain is expected to approach that depth.
    /// </summary>
    private static async Task<bool> IsCircularHouseMadeReferenceAsync(
        Guid ingredientId, Guid definingRecipeId, IngredientsDbContext db, Catalog.Contracts.IRecipeLookupPort recipeLookup, CancellationToken cancellationToken)
    {
        var visitedRecipes = new HashSet<Guid>();
        var queue = new Queue<Guid>();
        queue.Enqueue(definingRecipeId);

        while (queue.Count > 0 && visitedRecipes.Count < 200)
        {
            var recipeId = queue.Dequeue();
            if (!visitedRecipes.Add(recipeId))
            {
                continue;
            }

            var usedIngredientIds = await recipeLookup.GetIngredientIdsUsedByAsync(recipeId, cancellationToken);
            if (usedIngredientIds.Contains(ingredientId))
            {
                return true;
            }

            foreach (var usedIngredientId in usedIngredientIds)
            {
                var nestedDefiningRecipeId = await db.Ingredients
                    .Where(i => i.Id == usedIngredientId)
                    .Select(i => i.DefiningRecipeId)
                    .FirstOrDefaultAsync(cancellationToken);
                if (nestedDefiningRecipeId is { } nested)
                {
                    queue.Enqueue(nested);
                }
            }
        }

        return false;
    }

    private static bool TryParseAuthorLibraryScope(string value, out LibraryScope libraryScope)
    {
        if (string.Equals(value, "personal", StringComparison.OrdinalIgnoreCase))
        {
            libraryScope = LibraryScope.Personal;
            return true;
        }

        if (string.Equals(value, "bar", StringComparison.OrdinalIgnoreCase))
        {
            libraryScope = LibraryScope.Bar;
            return true;
        }

        libraryScope = default;
        return false;
    }

    private static async Task<IngredientAuthorResponse> BuildAuthorResponseAsync(
        Ingredient ingredient, Catalog.Contracts.IRecipeLookupPort recipeLookup, CancellationToken cancellationToken)
    {
        HouseMadeResponse? houseMade = null;
        if (ingredient.DefiningRecipeId is { } definingRecipeId)
        {
            var names = await recipeLookup.GetNamesAsync([definingRecipeId], cancellationToken);
            houseMade = new HouseMadeResponse(
                definingRecipeId,
                names.GetValueOrDefault(definingRecipeId),
                ingredient.YieldQuantity ?? 0,
                ingredient.YieldUnit ?? string.Empty,
                ingredient.ShelfLife.HasValue ? (int)ingredient.ShelfLife.Value.TotalDays : 0,
                ingredient.StorageInstructions ?? string.Empty);
        }

        return new IngredientAuthorResponse(
            ingredient.Id,
            ingredient.Name,
            ingredient.LibraryScope.ToString().ToLowerInvariant(),
            ingredient.OwnerType == OwnerType.Venue ? ingredient.OwnerId : null,
            ingredient.CategoryId,
            ingredient.ParentId,
            ingredient.AbvPercent,
            ingredient.Sources,
            ingredient.Description,
            ingredient.Visibility.ToString().ToLowerInvariant(),
            houseMade);
    }

    private static Guid CurrentUserId(ClaimsPrincipal user) => Guid.Parse(user.GetClaim(Claims.Subject)!);
}

public sealed record IngredientPageResponse(IReadOnlyList<IngredientSummaryResponse> Items, string? NextCursor);

/// <summary>FR-014a's bidirectional ingredient-&gt;recipes surface (T155).</summary>
public sealed record IngredientRecipesResponse(IReadOnlyList<IngredientRecipeRefResponse> Items);

public sealed record IngredientRecipeRefResponse(Guid Id, string Name);

public sealed record IngredientSummaryResponse(Guid Id, string Name, Guid? ParentId, string? ParentName);

public sealed record IngredientDetailResponse(
    Guid Id,
    string Name,
    Guid? ParentId,
    string? ParentName,
    IReadOnlyList<string> Sources,
    string? Description,
    decimal? AbvPercent,
    IReadOnlyList<string> Allergens,
    Guid? DefiningRecipeId,
    string? DefiningRecipeName,
    decimal? YieldQuantity,
    string? YieldUnit,
    TimeSpan? ShelfLife,
    string? StorageInstructions);

public sealed record CreateHouseMadeRequest(Guid DefiningRecipeId, decimal YieldQuantity, string YieldUnit, int ShelfLifeDays, string StorageInstructions);

public sealed record CreateIngredientRequest(
    string Name,
    string LibraryScope,
    Guid? VenueId,
    Guid? CategoryId,
    Guid? ParentId,
    decimal? AbvPercent,
    IReadOnlyList<string>? Sources,
    string? Description,
    CreateHouseMadeRequest? HouseMade);

public sealed record UpdateIngredientRequest(
    string Name,
    Guid? CategoryId,
    Guid? ParentId,
    decimal? AbvPercent,
    IReadOnlyList<string>? Sources,
    string? Description,
    CreateHouseMadeRequest? HouseMade);

public sealed record HouseMadeResponse(Guid DefiningRecipeId, string? DefiningRecipeName, decimal YieldQuantity, string YieldUnit, int ShelfLifeDays, string StorageInstructions);

public sealed record IngredientAuthorResponse(
    Guid Id,
    string Name,
    string LibraryScope,
    Guid? VenueId,
    Guid CategoryId,
    Guid? ParentId,
    decimal? AbvPercent,
    IReadOnlyList<string> Sources,
    string? Description,
    string Visibility,
    HouseMadeResponse? HouseMade);
