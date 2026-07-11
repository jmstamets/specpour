namespace SpecPour.Modules.Media.Domain;

/// <summary>
/// data-model.md MediaAttachment: generic media-attachment structure (FR-023). The
/// binary itself lives only in object storage (constitution: no binaries in DB or
/// local disk) — this row is metadata plus the object-storage key.
/// </summary>
public sealed class MediaAttachment
{
    public required Guid Id { get; init; }

    public required Guid OwnerId { get; init; }

    /// <summary>The attached-to entity type (e.g. "Recipe", "Ingredient", "Equipment", "Article").</summary>
    public required string SubjectType { get; init; }

    public required Guid SubjectId { get; init; }

    public required MediaKind Kind { get; init; }

    /// <summary>The object-storage key (bucket-relative); never a full URL — URLs are generated on demand via IObjectStoragePort.</summary>
    public required string ObjectStorageKey { get; init; }

    public required string ContentType { get; init; }

    public required long Size { get; init; }

    /// <summary>Gallery display order among sibling attachments on the same subject.</summary>
    public required int Position { get; set; }

    public required DateTimeOffset CreatedAt { get; init; }
}
