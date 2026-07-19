using Microsoft.EntityFrameworkCore;
using SpecPour.Modules.Venues.Contracts;

namespace SpecPour.Modules.Venues.Infrastructure;

/// <summary>T058's implementation of the cross-module venue ownership port.</summary>
public sealed class VenueOwnershipAdapter(VenuesDbContext db) : IVenueOwnershipPort
{
    public Task<bool> IsOwnedByAsync(Guid venueId, Guid userId, CancellationToken cancellationToken) =>
        db.Venues.AnyAsync(v => v.Id == venueId && v.OwnerUserId == userId, cancellationToken);

    public async Task<IReadOnlyList<Guid>> GetOwnedVenueIdsAsync(Guid userId, CancellationToken cancellationToken) =>
        await db.Venues.Where(v => v.OwnerUserId == userId).Select(v => v.Id).ToListAsync(cancellationToken);
}
