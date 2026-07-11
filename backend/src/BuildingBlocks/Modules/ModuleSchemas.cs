namespace SpecPour.BuildingBlocks.Modules;

/// <summary>
/// The 18 module-owned PostgreSQL schema names (data-model.md; Search deliberately owns
/// none — see the T141 ADR). The base migration (T013) creates all of these up front so
/// each module's own forward-only migrations always have their schema pre-created;
/// module DbContexts reference this list rather than hard-coding their schema string.
/// </summary>
public static class ModuleSchemas
{
    public const string Identity = "identity";
    public const string Authorization = "authz";
    public const string Catalog = "catalog";
    public const string Ingredients = "ingredients";
    public const string Equipment = "equipment";
    public const string Glossary = "glossary";
    public const string Community = "community";
    public const string Inventory = "inventory";
    public const string Measurements = "measurements";
    public const string Shopping = "shopping";
    public const string Prep = "prep";
    public const string Collections = "collections";
    public const string TastingLog = "tastinglog";
    public const string Media = "media";
    public const string Notifications = "notifications";
    public const string Compliance = "compliance";
    public const string Venues = "venues";
    public const string Ai = "ai";

    /// <summary>All 18 module schemas, in the order the base migration creates them.</summary>
    public static readonly IReadOnlyList<string> All =
    [
        Identity, Authorization, Catalog, Ingredients, Equipment, Glossary, Community,
        Inventory, Measurements, Shopping, Prep, Collections, TastingLog, Media,
        Notifications, Compliance, Venues, Ai,
    ];
}
