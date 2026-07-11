namespace SpecPour.Modules.Search.Application;

/// <summary>
/// A search request over every registered searchable entity (R8). Facets are a flat
/// key-to-allowed-values map; the concrete facet keys are declared by each story's
/// endpoint task (content facets land T037, makeable-from-inventory T148, rating
/// T149) — this port has no opinion on what facets exist.
/// </summary>
public sealed record SearchQuery(string? Text, IReadOnlyDictionary<string, IReadOnlyList<string>> Facets, string? Cursor, int Limit);

public sealed record SearchPage(IReadOnlyList<SearchResultItem> Items, string? NextCursor);

public sealed record SearchResultItem(string EntityType, Guid EntityId, string Title, string? Snippet, double Score);
