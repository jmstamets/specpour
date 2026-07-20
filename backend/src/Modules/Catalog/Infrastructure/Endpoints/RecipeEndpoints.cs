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
using SpecPour.BuildingBlocks.Time;
using SpecPour.Modules.Catalog.Application.DerivedData;
using SpecPour.Modules.Catalog.Domain;
using SpecPour.Modules.Catalog.Infrastructure.Search;
using SpecPour.Modules.Venues.Contracts;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Catalog.Infrastructure.Endpoints;

/// <summary>
/// GET /api/v1/recipes, GET /api/v1/recipes/{id} (T037, contracts/openapi/paths/catalog.yaml).
/// Guest-accessible (FR-004b) — only <see cref="ContentVisibility.Public"/> recipes
/// are returned to a guest/non-owner.
///
/// POST/PUT/DELETE /api/v1/recipes (T058, FR-018): bearer-only author CRUD with
/// library scoping (personal|bar) and privacy enforcement (FR-008b) — a bar-scoped
/// recipe's owner is the venue (single-user-owned per FR-058), verified via
/// <see cref="IVenueOwnershipPort"/> rather than a hard cross-schema FK (ADR-0001).
/// Authored recipes always start <see cref="ContentVisibility.Private"/> — publishing
/// (with its consent cascade over referenced private ingredients, see spec.md's
/// clarification) is a distinct, not-yet-built flow, never silently exposed here.
/// </summary>
public static class RecipeEndpoints
{
    private const int DefaultLimit = 20;

    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        var bearerOnly = new AuthorizeAttribute
        {
            AuthenticationSchemes = OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme,
        };

        group.MapGet("/recipes", ListAsync);
        group.MapGet("/recipes/{id:guid}", GetAsync);
        group.MapPost("/recipes", CreateAsync).RequireAuthorization(bearerOnly);
        group.MapPut("/recipes/{id:guid}", UpdateAsync).RequireAuthorization(bearerOnly);
        group.MapDelete("/recipes/{id:guid}", DeleteAsync).RequireAuthorization(bearerOnly);
    }

    private static async Task<Results<Ok<RecipePageResponse>, ProblemHttpResult>> ListAsync(
        string? family,
        string? category,
        string? tag,
        string? flavorProfile,
        string? equipment,
        string? glassware,
        string? ice,
        string? uses,
        string? allergenExclude,
        string? makeable,
        string? source,
        string? scope,
        string? cursor,
        int? limit,
        ClaimsPrincipal user,
        CatalogDbContext db,
        Ingredients.Contracts.IIngredientLookupPort ingredientLookup,
        Contracts.IRecipeLookupPort recipeLookup,
        IVenueOwnershipPort venueOwnership,
        Inventory.Contracts.IMakeabilityPort makeabilityPort,
        CancellationToken cancellationToken)
    {
        var pageSize = Math.Clamp(limit ?? DefaultLimit, 1, 100);
        var offset = CursorPagination.Decode(cursor);

        // T148/FR-050: makeable-from-inventory facet — bearer-only (needs the
        // caller's own inventory). Computed BEFORE the base query is chosen (not as
        // a post-filter like equipment/glassware/uses below) because
        // IMakeabilityPort's own visible-recipe set already spans public ∪ the
        // caller's own personal/bar recipes — a caller's own authored recipe can be
        // makeable/near-miss too, and the default (no `scope`) base query below is
        // public-only, which would silently exclude it if this ran as a pure
        // post-filter. Includes near-misses (one-away, naming the missing/
        // substitutable line) alongside fully-makeable recipes — both count as
        // "matching" for this facet, distinguished per-item by IsNearMiss.
        Dictionary<Guid, Inventory.Contracts.MakeableRecipeInfo>? makeableById = null;
        Dictionary<Guid, Inventory.Contracts.NearMissRecipeInfo>? nearMissById = null;
        HashSet<Guid>? makeableMatchedIds = null;
        if (string.Equals(makeable, "true", StringComparison.OrdinalIgnoreCase))
        {
            if (user.Identity?.IsAuthenticated != true)
            {
                return TypedResults.Problem(title: "Sign-in required", statusCode: StatusCodes.Status401Unauthorized);
            }

            var makeability = await makeabilityPort.ComputeAsync(CurrentUserId(user), cancellationToken);
            makeableById = makeability.Makeable.ToDictionary(m => m.RecipeId);
            nearMissById = makeability.NearMiss.ToDictionary(m => m.RecipeId);
            makeableMatchedIds = [.. makeableById.Keys.Concat(nearMissById.Keys)];
        }

        IQueryable<Recipe> query;
        if (scope is not null)
        {
            // T058, FR-050 "my library" facet: distinct from the guest-facing "source"
            // facet below — personal/bar scope always requires an authenticated caller
            // and always shows THEIR OWN recipes regardless of Visibility (a private
            // draft is still theirs to see in their own library listing).
            if (user.Identity?.IsAuthenticated != true)
            {
                return TypedResults.Problem(title: "Sign-in required", statusCode: StatusCodes.Status401Unauthorized);
            }

            var userId = CurrentUserId(user);
            if (string.Equals(scope, "personal", StringComparison.OrdinalIgnoreCase))
            {
                query = db.Recipes.Where(r => r.OwnerType == OwnerType.User && r.OwnerId == userId && r.LibraryScope == LibraryScope.Personal);
            }
            else if (string.Equals(scope, "bar", StringComparison.OrdinalIgnoreCase))
            {
                var ownedVenueIds = await venueOwnership.GetOwnedVenueIdsAsync(userId, cancellationToken);
                query = db.Recipes.Where(r =>
                    r.OwnerType == OwnerType.Venue && r.LibraryScope == LibraryScope.Bar &&
                    r.OwnerId != null && ownedVenueIds.Contains(r.OwnerId.Value));
            }
            else
            {
                return TypedResults.Ok(new RecipePageResponse([], null));
            }
        }
        else if (source is not null && !string.Equals(source, "core", StringComparison.OrdinalIgnoreCase))
        {
            // "source" facet (core library / my library / public, FR-050): the "my
            // library" case is handled by `scope` above; any other non-"core" value
            // matches nothing rather than silently ignoring the filter.
            return TypedResults.Ok(new RecipePageResponse([], null));
        }
        else if (makeableMatchedIds is not null)
        {
            // No explicit scope/source: use the makeable facet's own visible-recipe
            // set (public ∪ the caller's own personal/bar recipes) as the base,
            // rather than the public-only default, so the caller's own authored
            // recipes can appear here too.
            query = db.Recipes.Where(r => makeableMatchedIds.Contains(r.Id));
        }
        else
        {
            query = db.Recipes.Where(r => r.Visibility == ContentVisibility.Public);
        }

        // Composes with any of the branches above (e.g. `scope=personal&makeable=true`
        // narrows to the caller's own makeable/near-miss personal recipes); a no-op
        // when the branch above already used makeableMatchedIds as its own base.
        if (makeableMatchedIds is not null)
        {
            query = query.Where(r => makeableMatchedIds.Contains(r.Id));
        }

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

        IReadOnlyDictionary<Guid, Ingredients.Contracts.IngredientSummary> makeabilityIngredientNames = new Dictionary<Guid, Ingredients.Contracts.IngredientSummary>();
        if (makeableById is not null && nearMissById is not null)
        {
            var involvedIds = page
                .SelectMany(r => (makeableById.TryGetValue(r.Id, out var m) ? m.Lines : nearMissById.TryGetValue(r.Id, out var n) ? n.Lines : [])
                    .SelectMany(l => new[] { l.RequirementIngredientId, l.SatisfiedByIngredientId })
                    .Where(id => id.HasValue)
                    .Select(id => id!.Value))
                .Distinct()
                .ToList();
            makeabilityIngredientNames = await ingredientLookup.GetSummariesAsync(involvedIds, cancellationToken);
        }

        var items = page.Select(r => new RecipeSummaryResponse(
            r.Id,
            r.PrimaryName,
            r.FamilyId is { } familyId && familyKeysById.TryGetValue(familyId, out var familyKey) ? familyKey : null,
            ToMakeabilitySummary(r.Id, makeableById, nearMissById, makeabilityIngredientNames)))
            .ToList();

        return TypedResults.Ok(new RecipePageResponse(items, nextCursor));
    }

    private static MakeabilitySummaryResponse? ToMakeabilitySummary(
        Guid recipeId,
        Dictionary<Guid, Inventory.Contracts.MakeableRecipeInfo>? makeableById,
        Dictionary<Guid, Inventory.Contracts.NearMissRecipeInfo>? nearMissById,
        IReadOnlyDictionary<Guid, Ingredients.Contracts.IngredientSummary> names)
    {
        if (makeableById is null || nearMissById is null)
        {
            return null;
        }

        if (makeableById.TryGetValue(recipeId, out var makeableRecipe))
        {
            return new MakeabilitySummaryResponse(false, makeableRecipe.MatchQuality, [.. makeableRecipe.Lines.Select(l => ToLineSummary(l, names))]);
        }

        var nearMissRecipe = nearMissById[recipeId];
        return new MakeabilitySummaryResponse(true, null, [.. nearMissRecipe.Lines.Select(l => ToLineSummary(l, names))]);
    }

    private static MakeabilityLineSummaryResponse ToLineSummary(Inventory.Contracts.MakeabilityLineInfo line, IReadOnlyDictionary<Guid, Ingredients.Contracts.IngredientSummary> names) => new(
        line.RequirementIngredientId,
        names.TryGetValue(line.RequirementIngredientId, out var reqSummary) ? reqSummary.Name : null,
        line.MatchQuality,
        line.SatisfiedByIngredientId,
        line.SatisfiedByIngredientId is { } id && names.TryGetValue(id, out var heldSummary) ? heldSummary.Name : null);

    private static async Task<Results<Ok<RecipeDetailResponse>, NotFound>> GetAsync(
        Guid id,
        ClaimsPrincipal user,
        CatalogDbContext db,
        IRecipeDerivedDataCalculator calculator,
        Ingredients.Contracts.IIngredientLookupPort ingredientLookup,
        Equipment.Contracts.IEquipmentLookupPort equipmentLookup,
        IVenueOwnershipPort venueOwnership,
        CancellationToken cancellationToken)
    {
        var recipe = await db.Recipes.FirstOrDefaultAsync(r => r.Id == id, cancellationToken);
        if (recipe is null)
        {
            return TypedResults.NotFound();
        }

        if (recipe.Visibility != ContentVisibility.Public && !await IsOwnerAsync(recipe, user, venueOwnership, cancellationToken))
        {
            // 404, not 403: a private recipe's existence isn't disclosed to a
            // non-owner (same no-enumeration reasoning as recovery/login elsewhere
            // in this codebase) — matches spec.md scenario 4.
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

    private static async Task<Results<Created<RecipeAuthorResponse>, ProblemHttpResult>> CreateAsync(
        CreateRecipeRequest request,
        ClaimsPrincipal user,
        CatalogDbContext db,
        IUuidGenerator uuidGenerator,
        IClock clock,
        Ingredients.Contracts.IIngredientLookupPort ingredientLookup,
        IVenueOwnershipPort venueOwnership,
        RecipeSearchDocumentRefresher searchRefresher,
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
                return TypedResults.Problem(title: "venueId required", detail: "A bar-scoped recipe must reference a venueId.", statusCode: StatusCodes.Status400BadRequest);
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

        if (!TryParseIngredientLines(request.IngredientLines, out var lines, out var lineError))
        {
            return TypedResults.Problem(title: "Invalid ingredient line", detail: lineError, statusCode: StatusCodes.Status400BadRequest);
        }

        if (await FindUnknownIngredientIdAsync(lines, ingredientLookup, cancellationToken) is { } unknownIngredientId)
        {
            return TypedResults.Problem(title: "Unknown ingredient", detail: $"No such ingredient: {unknownIngredientId}.", statusCode: StatusCodes.Status400BadRequest);
        }

        var categoryIds = (request.CategoryIds ?? []).Distinct().ToList();
        if (categoryIds.Count > 0 && await db.Categories.CountAsync(c => categoryIds.Contains(c.Id), cancellationToken) != categoryIds.Count)
        {
            return TypedResults.Problem(title: "Unknown category", statusCode: StatusCodes.Status400BadRequest);
        }

        var now = clock.UtcNow;
        var recipe = new Recipe
        {
            Id = uuidGenerator.NewId(),

            // T058: Method is purely internal ABV-dilution plumbing (T036) — no read
            // endpoint ever renders it and no acceptance scenario asks the author to
            // supply it, so this is a neutral, documented default rather than an
            // exposed field, not a corner cut on anything actually specified.
            Method = SpecPour.Modules.Measurements.Contracts.MixMethod.Built,
            OwnerType = ownerType,
            OwnerId = ownerId,
            LibraryScope = libraryScope,
            PrimaryName = request.PrimaryName,
            AlternateNames = request.AlternateNames ?? [],
            Instructions = request.Instructions ?? [],
            IceSpec = string.Empty,

            // T058: authored content always starts private (FR-008b) — publishing
            // (with its consent cascade over referenced private ingredients, per
            // spec.md's clarification) is a distinct, not-yet-built flow.
            Visibility = ContentVisibility.Private,
            CreatedAt = now,
            UpdatedAt = now,
        };

        db.Recipes.Add(recipe);
        AddIngredientLines(db, recipe.Id, lines, uuidGenerator);
        foreach (var categoryId in categoryIds)
        {
            db.RecipeCategories.Add(new RecipeCategory { RecipeId = recipe.Id, CategoryId = categoryId });
        }

        await AddTagsAsync(db, recipe.Id, request.Tags, uuidGenerator, cancellationToken);

        await db.SaveChangesAsync(cancellationToken);
        await searchRefresher.RefreshAsync(recipe.Id, cancellationToken);
        await db.SaveChangesAsync(cancellationToken);

        var response = await BuildAuthorResponseAsync(recipe, db, ingredientLookup, cancellationToken);
        return TypedResults.Created($"/api/v1/recipes/{recipe.Id}", response);
    }

    private static async Task<Results<Ok<RecipeAuthorResponse>, NotFound, ProblemHttpResult>> UpdateAsync(
        Guid id,
        UpdateRecipeRequest request,
        ClaimsPrincipal user,
        CatalogDbContext db,
        IUuidGenerator uuidGenerator,
        IClock clock,
        Ingredients.Contracts.IIngredientLookupPort ingredientLookup,
        IVenueOwnershipPort venueOwnership,
        RecipeSearchDocumentRefresher searchRefresher,
        CancellationToken cancellationToken)
    {
        var recipe = await db.Recipes.FirstOrDefaultAsync(r => r.Id == id, cancellationToken);
        if (recipe is null || !await IsOwnerAsync(recipe, user, venueOwnership, cancellationToken))
        {
            return TypedResults.NotFound();
        }

        if (!TryParseIngredientLines(request.IngredientLines, out var lines, out var lineError))
        {
            return TypedResults.Problem(title: "Invalid ingredient line", detail: lineError, statusCode: StatusCodes.Status400BadRequest);
        }

        if (await FindUnknownIngredientIdAsync(lines, ingredientLookup, cancellationToken) is { } unknownIngredientId)
        {
            return TypedResults.Problem(title: "Unknown ingredient", detail: $"No such ingredient: {unknownIngredientId}.", statusCode: StatusCodes.Status400BadRequest);
        }

        var categoryIds = (request.CategoryIds ?? []).Distinct().ToList();
        if (categoryIds.Count > 0 && await db.Categories.CountAsync(c => categoryIds.Contains(c.Id), cancellationToken) != categoryIds.Count)
        {
            return TypedResults.Problem(title: "Unknown category", statusCode: StatusCodes.Status400BadRequest);
        }

        recipe.PrimaryName = request.PrimaryName;
        recipe.AlternateNames = request.AlternateNames ?? [];
        recipe.Instructions = request.Instructions ?? [];
        recipe.UpdatedAt = clock.UtcNow;

        db.RecipeIngredientLines.RemoveRange(await db.RecipeIngredientLines.Where(l => l.RecipeId == id).ToListAsync(cancellationToken));
        AddIngredientLines(db, id, lines, uuidGenerator);

        db.RecipeCategories.RemoveRange(await db.RecipeCategories.Where(rc => rc.RecipeId == id).ToListAsync(cancellationToken));
        foreach (var categoryId in categoryIds)
        {
            db.RecipeCategories.Add(new RecipeCategory { RecipeId = id, CategoryId = categoryId });
        }

        db.RecipeTags.RemoveRange(await db.RecipeTags.Where(rt => rt.RecipeId == id).ToListAsync(cancellationToken));
        await AddTagsAsync(db, id, request.Tags, uuidGenerator, cancellationToken);

        await db.SaveChangesAsync(cancellationToken);
        await searchRefresher.RefreshAsync(id, cancellationToken);
        await db.SaveChangesAsync(cancellationToken);

        var response = await BuildAuthorResponseAsync(recipe, db, ingredientLookup, cancellationToken);
        return TypedResults.Ok(response);
    }

    private static async Task<Results<NoContent, NotFound>> DeleteAsync(
        Guid id, ClaimsPrincipal user, CatalogDbContext db, IVenueOwnershipPort venueOwnership, CancellationToken cancellationToken)
    {
        var recipe = await db.Recipes.FirstOrDefaultAsync(r => r.Id == id, cancellationToken);
        if (recipe is null || !await IsOwnerAsync(recipe, user, venueOwnership, cancellationToken))
        {
            return TypedResults.NotFound();
        }

        // RecipeIngredientLine/RecipeCategory/RecipeTag/RecipeGlassware/RecipeEquipment
        // all cascade-delete on RecipeId (CatalogDbContext.OnModelCreating).
        db.Recipes.Remove(recipe);
        await db.SaveChangesAsync(cancellationToken);
        return TypedResults.NoContent();
    }

    private static async Task<bool> IsOwnerAsync(Recipe recipe, ClaimsPrincipal user, IVenueOwnershipPort venueOwnership, CancellationToken cancellationToken)
    {
        if (user.Identity?.IsAuthenticated != true)
        {
            return false;
        }

        var userId = CurrentUserId(user);
        return recipe.OwnerType switch
        {
            OwnerType.User => recipe.OwnerId == userId,
            OwnerType.Venue => recipe.OwnerId is { } venueId && await venueOwnership.IsOwnedByAsync(venueId, userId, cancellationToken),
            _ => false,
        };
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

    private static bool TryParseIngredientLines(
        IReadOnlyList<CreateRecipeIngredientLineRequest>? requestLines,
        out List<ParsedIngredientLine> lines,
        out string? error)
    {
        lines = [];
        error = null;
        foreach (var line in requestLines ?? [])
        {
            if (!Enum.TryParse<IngredientScalingRule>(line.ScalingRule, ignoreCase: true, out var scalingRule))
            {
                error = $"Unknown scalingRule: {line.ScalingRule}";
                lines = [];
                return false;
            }

            lines.Add(new ParsedIngredientLine(line.IngredientId, line.Quantity, line.Unit, line.Purpose, scalingRule));
        }

        return true;
    }

    private static async Task<Guid?> FindUnknownIngredientIdAsync(
        List<ParsedIngredientLine> lines, Ingredients.Contracts.IIngredientLookupPort ingredientLookup, CancellationToken cancellationToken)
    {
        if (lines.Count == 0)
        {
            return null;
        }

        var referencedIds = lines.Select(l => l.IngredientId).Distinct().ToList();
        var summaries = await ingredientLookup.GetSummariesAsync(referencedIds, cancellationToken);
        var missing = referencedIds.Where(i => !summaries.ContainsKey(i)).ToList();
        return missing.Count > 0 ? missing[0] : null;
    }

    private static void AddIngredientLines(CatalogDbContext db, Guid recipeId, List<ParsedIngredientLine> lines, IUuidGenerator uuidGenerator)
    {
        var position = 1;
        foreach (var line in lines)
        {
            db.RecipeIngredientLines.Add(new RecipeIngredientLine
            {
                Id = uuidGenerator.NewId(),
                RecipeId = recipeId,
                Position = position++,
                IngredientId = line.IngredientId,
                Quantity = line.Quantity,
                Unit = line.Unit,
                Purpose = line.Purpose,
                ScalingRule = line.ScalingRule,
            });
        }
    }

    private static async Task AddTagsAsync(CatalogDbContext db, Guid recipeId, IReadOnlyList<string>? tagTexts, IUuidGenerator uuidGenerator, CancellationToken cancellationToken)
    {
        foreach (var tagText in (tagTexts ?? []).Where(t => !string.IsNullOrWhiteSpace(t)).Distinct(StringComparer.OrdinalIgnoreCase))
        {
            var key = tagText.Trim().ToLowerInvariant();
            var tag = await db.Tags.FirstOrDefaultAsync(t => t.Key == key, cancellationToken);
            if (tag is null)
            {
                tag = new Tag { Id = uuidGenerator.NewId(), Key = key, DisplayText = tagText.Trim() };
                db.Tags.Add(tag);
            }

            db.RecipeTags.Add(new RecipeTag { RecipeId = recipeId, TagId = tag.Id });
        }
    }

    private static async Task<RecipeAuthorResponse> BuildAuthorResponseAsync(
        Recipe recipe, CatalogDbContext db, Ingredients.Contracts.IIngredientLookupPort ingredientLookup, CancellationToken cancellationToken)
    {
        var lines = await db.RecipeIngredientLines.Where(l => l.RecipeId == recipe.Id).OrderBy(l => l.Position).ToListAsync(cancellationToken);
        var summaries = await ingredientLookup.GetSummariesAsync([.. lines.Select(l => l.IngredientId).Distinct()], cancellationToken);
        var ingredientLines = lines.Select(l => new RecipeIngredientLineResponse(
            l.Position,
            l.IngredientId,
            summaries.TryGetValue(l.IngredientId, out var summary) ? summary.Name : null,
            l.Quantity,
            l.Unit,
            l.Purpose,
            l.ScalingRule.ToString())).ToList();

        var categoryIds = await db.RecipeCategories.Where(rc => rc.RecipeId == recipe.Id).Select(rc => rc.CategoryId).ToListAsync(cancellationToken);
        var tagKeys = await db.RecipeTags.Where(rt => rt.RecipeId == recipe.Id)
            .Join(db.Tags, rt => rt.TagId, t => t.Id, (rt, t) => t.Key)
            .ToListAsync(cancellationToken);

        return new RecipeAuthorResponse(
            recipe.Id,
            recipe.PrimaryName,
            recipe.AlternateNames,
            recipe.LibraryScope.ToString().ToLowerInvariant(),
            recipe.OwnerType == OwnerType.Venue ? recipe.OwnerId : null,
            recipe.Instructions,
            ingredientLines,
            categoryIds,
            tagKeys,
            recipe.Visibility.ToString().ToLowerInvariant(),
            recipe.CreatedAt,
            recipe.UpdatedAt);
    }

    private static Guid CurrentUserId(ClaimsPrincipal user) => Guid.Parse(user.GetClaim(Claims.Subject)!);

    private sealed record ParsedIngredientLine(Guid IngredientId, decimal Quantity, string Unit, string? Purpose, IngredientScalingRule ScalingRule);
}

public sealed record RecipePageResponse(IReadOnlyList<RecipeSummaryResponse> Items, string? NextCursor);

public sealed record RecipeSummaryResponse(Guid Id, string PrimaryName, string? FamilyKey, MakeabilitySummaryResponse? Makeability = null);

/// <summary>T148: present exactly when `?makeable=true` was applied. <see cref="MatchQuality"/> is a derived summary of <see cref="Lines"/> (null for near-miss entries — a near-miss has no single aggregate quality, per the same ratification GET /inventory/makeable follows).</summary>
public sealed record MakeabilitySummaryResponse(bool IsNearMiss, string? MatchQuality, IReadOnlyList<MakeabilityLineSummaryResponse> Lines);

public sealed record MakeabilityLineSummaryResponse(Guid RequirementIngredientId, string? RequirementIngredientName, string MatchQuality, Guid? SatisfiedByIngredientId, string? SatisfiedByIngredientName);

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

public sealed record CreateRecipeIngredientLineRequest(Guid IngredientId, decimal Quantity, string Unit, string? Purpose, string ScalingRule);

public sealed record CreateRecipeRequest(
    string PrimaryName,
    IReadOnlyList<string>? AlternateNames,
    string LibraryScope,
    Guid? VenueId,
    IReadOnlyList<string>? Instructions,
    IReadOnlyList<CreateRecipeIngredientLineRequest>? IngredientLines,
    IReadOnlyList<Guid>? CategoryIds,
    IReadOnlyList<string>? Tags);

public sealed record UpdateRecipeRequest(
    string PrimaryName,
    IReadOnlyList<string>? AlternateNames,
    IReadOnlyList<string>? Instructions,
    IReadOnlyList<CreateRecipeIngredientLineRequest>? IngredientLines,
    IReadOnlyList<Guid>? CategoryIds,
    IReadOnlyList<string>? Tags);

public sealed record RecipeAuthorResponse(
    Guid Id,
    string PrimaryName,
    IReadOnlyList<string> AlternateNames,
    string LibraryScope,
    Guid? VenueId,
    IReadOnlyList<string> Instructions,
    IReadOnlyList<RecipeIngredientLineResponse> IngredientLines,
    IReadOnlyList<Guid> CategoryIds,
    IReadOnlyList<string> Tags,
    string Visibility,
    DateTimeOffset CreatedAt,
    DateTimeOffset UpdatedAt);
