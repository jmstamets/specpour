namespace SpecPour.Modules.Search.Application;

/// <summary>
/// A search request over every registered searchable entity (R8). Facets are a flat
/// key-to-allowed-values map; the concrete facet keys are declared by each story's
/// endpoint task (content facets land T037, makeable-from-inventory T148, rating
/// T149) — this port has no opinion on what facets exist.
///
/// <see cref="EntityIdFilter"/> (T148): an optional per-entity-type ID allowlist,
/// keyed by <c>SearchResultItem.EntityType</c>. Search stays entity-agnostic (T141
/// ADR) — it doesn't know WHY a facet (uses/makeable/etc.) restricted a caller to
/// these IDs, only that it must. Applied INSIDE the adapter's own SQL, before
/// pagination — this is what fixes T155's documented post-filter-after-pagination
/// limitation (a page could come back with fewer than <see cref="Limit"/> items when
/// a facet removed matches after the adapter had already paginated). A present key
/// with an EMPTY id list means "no matches for this entity type," not "no filter."
/// </summary>
public sealed record SearchQuery(
    string? Text,
    IReadOnlyDictionary<string, IReadOnlyList<string>> Facets,
    string? Cursor,
    int Limit,
    IReadOnlyDictionary<string, IReadOnlyList<Guid>>? EntityIdFilter = null);

public sealed record SearchPage(IReadOnlyList<SearchResultItem> Items, string? NextCursor);

public sealed record SearchResultItem(string EntityType, Guid EntityId, string Title, string? Snippet, double Score);
