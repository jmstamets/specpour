using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Library;
using SpecPour.Modules.Catalog.Domain;
using SpecPour.Modules.Catalog.Infrastructure;
using SpecPour.Modules.Equipment.Infrastructure;
using SpecPour.Modules.Glossary.Domain;
using SpecPour.Modules.Glossary.Infrastructure;
using SpecPour.Modules.Ingredients.Domain;
using SpecPour.Modules.Ingredients.Infrastructure;
using SpecPour.Modules.Measurements.Contracts;

namespace SpecPour.Tools.Seeder.Content;

/// <summary>
/// T040: imports the curated launch-content subset (Mai Tai, Daiquiri + Hemingway
/// Daiquiri under a Daiquiri concept page, an egg-white Whiskey Flip) from this
/// directory's JSON files into Catalog/Ingredients/Equipment/Glossary. Every entity
/// gets a deterministic ID (<see cref="DeterministicId"/>, keyed off the JSON
/// file's own "key" string) so re-running the Seeder against an already-seeded
/// database is a no-op per row rather than creating duplicates — the same
/// idempotency property <c>OpenIddictClientSeedingHostedService</c> and the Super
/// Admin bootstrap above already rely on, just via a lookup instead of a fixed
/// constant (there's no reasonable way to hand-pick 30 stable GUIDs across 5
/// content files without them silently drifting out of sync).
/// </summary>
public sealed class CuratedContentImporter(
    CatalogDbContext catalogDb,
    IngredientsDbContext ingredientsDb,
    EquipmentDbContext equipmentDb,
    GlossaryDbContext glossaryDb) : IContentImporter
{
    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);

    public string ContentType => "curated recipes/ingredients/equipment/glossary";

    public async Task ImportAsync(string contentDirectory, CancellationToken cancellationToken)
    {
        var equipmentKeyToId = await ImportEquipmentAsync(contentDirectory, cancellationToken);
        var categoryKeyToId = await ImportIngredientCategoriesAsync(contentDirectory, cancellationToken);
        var ingredientKeyToId = await ImportIngredientsAsync(contentDirectory, categoryKeyToId, cancellationToken);
        await ImportGlossaryTermsAsync(contentDirectory, cancellationToken);
        var recipeKeyToId = await ImportRecipesAsync(contentDirectory, ingredientKeyToId, equipmentKeyToId, cancellationToken);
        await ImportConceptsAsync(contentDirectory, recipeKeyToId, cancellationToken);
    }

    private async Task<Dictionary<string, Guid>> ImportEquipmentAsync(string contentDirectory, CancellationToken cancellationToken)
    {
        var records = await ReadAsync<EquipmentRecord>(contentDirectory, "equipment.json", cancellationToken);
        var keyToId = new Dictionary<string, Guid>();

        foreach (var record in records)
        {
            var id = DeterministicId("equipment", record.Key);
            keyToId[record.Key] = id;

            if (await equipmentDb.Equipment.FindAsync([id], cancellationToken) is not null)
            {
                continue;
            }

            equipmentDb.Equipment.Add(new SpecPour.Modules.Equipment.Domain.Equipment
            {
                Id = id,
                OwnerType = OwnerType.System,
                LibraryScope = LibraryScope.Core,
                Name = record.Name,
                Category = record.Category,
                Description = record.Description,
                TypicalApplications = record.TypicalApplications ?? [],
                Visibility = ContentVisibility.Public,
            });
        }

        await equipmentDb.SaveChangesAsync(cancellationToken);
        return keyToId;
    }

    private async Task<Dictionary<string, Guid>> ImportIngredientCategoriesAsync(string contentDirectory, CancellationToken cancellationToken)
    {
        var records = await ReadAsync<IngredientCategoryRecord>(contentDirectory, "ingredientCategories.json", cancellationToken);
        var keyToId = new Dictionary<string, Guid>();

        foreach (var record in records)
        {
            var id = DeterministicId("ingredientCategory", record.Key);
            keyToId[record.Key] = id;

            if (await ingredientsDb.IngredientCategories.FindAsync([id], cancellationToken) is not null)
            {
                continue;
            }

            ingredientsDb.IngredientCategories.Add(new IngredientCategory
            {
                Id = id,
                NameKey = record.NameKey,
                Definition = record.Definition,
            });
        }

        await ingredientsDb.SaveChangesAsync(cancellationToken);
        return keyToId;
    }

    private async Task<Dictionary<string, Guid>> ImportIngredientsAsync(
        string contentDirectory, Dictionary<string, Guid> categoryKeyToId, CancellationToken cancellationToken)
    {
        var records = await ReadAsync<IngredientRecord>(contentDirectory, "ingredients.json", cancellationToken);
        var keyToId = new Dictionary<string, Guid>();
        var allergenIdByKey = await ingredientsDb.Allergens.ToDictionaryAsync(a => a.Key, a => a.Id, cancellationToken);
        var newlyAddedByKey = new Dictionary<string, Ingredient>();

        foreach (var record in records)
        {
            var id = DeterministicId("ingredient", record.Key);
            keyToId[record.Key] = id;

            if (await ingredientsDb.Ingredients.FindAsync([id], cancellationToken) is not null)
            {
                continue;
            }

            var ingredient = new Ingredient
            {
                Id = id,
                OwnerType = OwnerType.System,
                LibraryScope = LibraryScope.Core,
                Name = record.Name,
                CategoryId = categoryKeyToId[record.CategoryKey],
                Sources = record.Sources ?? [],
                Description = record.Description,
                AbvPercent = record.AbvPercent,
                Visibility = ContentVisibility.Public,
            };
            ingredientsDb.Ingredients.Add(ingredient);
            newlyAddedByKey[record.Key] = ingredient;

            foreach (var allergenKey in record.AllergenKeys ?? [])
            {
                ingredientsDb.IngredientAllergens.Add(new IngredientAllergen
                {
                    IngredientId = id,
                    AllergenId = allergenIdByKey[allergenKey],
                    Certainty = AllergenCertainty.Certain,
                });
            }
        }

        // T181: resolve hierarchy (FR-012) as a second pass over the same batch —
        // a child can be declared before or after its parent in the JSON array, so
        // ParentId can only be set once every record in this run has an id.
        foreach (var record in records)
        {
            if (record.ParentKey is null || !newlyAddedByKey.TryGetValue(record.Key, out var ingredient))
            {
                continue;
            }

            ingredient.ParentId = keyToId.TryGetValue(record.ParentKey, out var parentId)
                ? parentId
                : throw new InvalidOperationException(
                    $"Ingredient '{record.Key}' declares parentKey '{record.ParentKey}', which was not found in ingredients.json.");
        }

        await ingredientsDb.SaveChangesAsync(cancellationToken);
        return keyToId;
    }

    private async Task ImportGlossaryTermsAsync(string contentDirectory, CancellationToken cancellationToken)
    {
        var records = await ReadAsync<GlossaryTermRecord>(contentDirectory, "glossaryTerms.json", cancellationToken);

        foreach (var record in records)
        {
            var id = DeterministicId("glossaryTerm", record.Key);

            if (await glossaryDb.GlossaryTerms.FindAsync([id], cancellationToken) is not null)
            {
                continue;
            }

            glossaryDb.GlossaryTerms.Add(new GlossaryTerm
            {
                Id = id,
                Term = record.Term,
                Definitions = record.Definitions,
            });
        }

        await glossaryDb.SaveChangesAsync(cancellationToken);
    }

    private async Task<Dictionary<string, Guid>> ImportRecipesAsync(
        string contentDirectory,
        Dictionary<string, Guid> ingredientKeyToId,
        Dictionary<string, Guid> equipmentKeyToId,
        CancellationToken cancellationToken)
    {
        var records = await ReadAsync<RecipeRecord>(contentDirectory, "recipes.json", cancellationToken);
        var keyToId = new Dictionary<string, Guid>();
        var familyIdByKey = await catalogDb.Families.ToDictionaryAsync(f => f.NameKey, f => f.Id, cancellationToken);

        foreach (var record in records)
        {
            var id = DeterministicId("recipe", record.Key);
            keyToId[record.Key] = id;

            if (await catalogDb.Recipes.FindAsync([id], cancellationToken) is not null)
            {
                continue;
            }

            var now = DateTimeOffset.UtcNow;
            catalogDb.Recipes.Add(new Recipe
            {
                Id = id,
                OwnerType = OwnerType.System,
                LibraryScope = LibraryScope.Core,
                PrimaryName = record.PrimaryName,
                AlternateNames = record.AlternateNames ?? [],
                Method = Enum.Parse<MixMethod>(record.Method),
                FamilyId = record.FamilyKey is not null ? familyIdByKey.GetValueOrDefault(record.FamilyKey) : null,
                Instructions = record.Instructions,
                Garnishes = record.Garnishes ?? [],
                IceSpec = record.IceSpec,
                CreatorAttribution = record.CreatorAttribution,
                History = record.History,
                Visibility = ContentVisibility.Public,
                CreatedAt = now,
                UpdatedAt = now,
            });

            var position = 1;
            foreach (var line in record.IngredientLines)
            {
                catalogDb.RecipeIngredientLines.Add(new RecipeIngredientLine
                {
                    Id = DeterministicId("recipeIngredientLine", $"{record.Key}:{position}"),
                    RecipeId = id,
                    Position = position++,
                    IngredientId = ingredientKeyToId[line.IngredientKey],
                    Quantity = line.Quantity,
                    Unit = line.Unit,
                    Purpose = line.Purpose,
                    ScalingRule = Enum.Parse<IngredientScalingRule>(line.ScalingRule),
                });
            }

            foreach (var glasswareKey in record.GlasswareKeys ?? [])
            {
                catalogDb.RecipeGlassware.Add(new RecipeGlassware { RecipeId = id, EquipmentId = equipmentKeyToId[glasswareKey] });
            }

            foreach (var equipmentKey in record.EquipmentKeys ?? [])
            {
                catalogDb.RecipeEquipment.Add(new RecipeEquipment { RecipeId = id, EquipmentId = equipmentKeyToId[equipmentKey] });
            }
        }

        await catalogDb.SaveChangesAsync(cancellationToken);
        return keyToId;
    }

    private async Task ImportConceptsAsync(string contentDirectory, Dictionary<string, Guid> recipeKeyToId, CancellationToken cancellationToken)
    {
        var records = await ReadAsync<ConceptRecord>(contentDirectory, "concepts.json", cancellationToken);

        foreach (var record in records)
        {
            var id = DeterministicId("concept", record.Key);

            if (await catalogDb.ConceptPages.FindAsync([id], cancellationToken) is not null)
            {
                continue;
            }

            catalogDb.ConceptPages.Add(new ConceptPage { Id = id, Name = record.Name, Description = record.Description });

            foreach (var variant in record.Variants)
            {
                catalogDb.ConceptVariantLinks.Add(new ConceptVariantLink
                {
                    Id = DeterministicId("conceptVariant", $"{record.Key}:{variant.RecipeKey}"),
                    ConceptId = id,
                    RecipeId = recipeKeyToId[variant.RecipeKey],
                    DifferentiatorText = variant.DifferentiatorText,
                    State = ConceptVariantState.Approved,
                });
            }
        }

        await catalogDb.SaveChangesAsync(cancellationToken);
    }

    private static async Task<IReadOnlyList<T>> ReadAsync<T>(string contentDirectory, string fileName, CancellationToken cancellationToken)
    {
        var path = Path.Combine(contentDirectory, fileName);
        await using var stream = File.OpenRead(path);
        return await JsonSerializer.DeserializeAsync<List<T>>(stream, JsonOptions, cancellationToken)
            ?? throw new InvalidOperationException($"{fileName} deserialized to null.");
    }

    /// <summary>A stable GUID derived from a namespaced key string — SHA-256 rather than MD5/SHA-1 purely to avoid tripping "do not use broken crypto" analyzers; this isn't a security use, just deterministic ID derivation.</summary>
    private static Guid DeterministicId(string category, string key)
    {
        var hash = SHA256.HashData(Encoding.UTF8.GetBytes($"specpour-seed:{category}:{key}"));
        return new Guid(hash[..16]);
    }
}

internal sealed record EquipmentRecord(string Key, string Name, string Category, string? Description, IReadOnlyList<string>? TypicalApplications);

internal sealed record IngredientCategoryRecord(string Key, string NameKey, string Definition);

internal sealed record IngredientRecord(
    string Key, string Name, string CategoryKey, decimal? AbvPercent, IReadOnlyList<string>? Sources,
    string? Description, IReadOnlyList<string>? AllergenKeys, string? ParentKey = null);

internal sealed record GlossaryTermRecord(string Key, string Term, IReadOnlyList<string> Definitions);

internal sealed record RecipeRecord(
    string Key, string PrimaryName, IReadOnlyList<string>? AlternateNames, string? FamilyKey, string Method,
    IReadOnlyList<string> Instructions, IReadOnlyList<string>? Garnishes, string IceSpec,
    string? CreatorAttribution, string? History, IReadOnlyList<string>? GlasswareKeys,
    IReadOnlyList<string>? EquipmentKeys, IReadOnlyList<RecipeIngredientLineRecord> IngredientLines);

internal sealed record RecipeIngredientLineRecord(string IngredientKey, decimal Quantity, string Unit, string? Purpose, string ScalingRule);

internal sealed record ConceptRecord(string Key, string Name, string Description, IReadOnlyList<ConceptVariantRecord> Variants);

internal sealed record ConceptVariantRecord(string RecipeKey, string DifferentiatorText);
