using NetTopologySuite.Geometries;

namespace SpecPour.Modules.Venues.Domain;

/// <summary>
/// data-model.md Venue (FR-058). Single-user-owned container in V1 (owner_user_id,
/// 1:N — one professional user may own many venues); shaped for future claiming/
/// verification and venue-scoped role grants (FR-004a/FR-060), not built yet.
/// <see cref="Location"/> is stored but unused by any V1 feature (FR-058's own
/// wording) — this module is the first real consumer of the PostGIS extension T013
/// enabled ahead of any actual spatial feature.
/// </summary>
public sealed class Venue
{
    public required Guid Id { get; init; }

    public required Guid OwnerUserId { get; init; }

    public required string Name { get; set; }

    public string? Address { get; set; }

    /// <summary>WGS84 (SRID 4326) point — nullable since coordinates are optional at creation.</summary>
    public Point? Location { get; set; }

    /// <summary>Native Postgres text[] (ADR-0001).</summary>
    public IReadOnlyList<string> ExternalReferences { get; set; } = [];

    public required DateTimeOffset CreatedAt { get; init; }
}
