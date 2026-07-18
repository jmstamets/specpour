namespace SpecPour.Modules.Venues.Contracts;

/// <summary>
/// Cross-module read port (constitution Principle III) letting Catalog verify a
/// caller actually owns a venue before authoring a bar-library recipe scoped to it
/// (T058, FR-058) — without depending on Venues' Domain/Infrastructure directly.
/// </summary>
public interface IVenueOwnershipPort
{
    Task<bool> IsOwnedByAsync(Guid venueId, Guid userId, CancellationToken cancellationToken);

    /// <summary>Every venue the caller owns — drives listing "my bar library" recipes across all of them.</summary>
    Task<IReadOnlyList<Guid>> GetOwnedVenueIdsAsync(Guid userId, CancellationToken cancellationToken);
}
