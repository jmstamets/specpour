using Microsoft.EntityFrameworkCore;
using SpecPour.Modules.Equipment.Contracts;

namespace SpecPour.Modules.Equipment.Infrastructure;

/// <summary>Contract-sweep addition: implements the cross-module equipment name lookup.</summary>
public sealed class EquipmentLookupAdapter(EquipmentDbContext db) : IEquipmentLookupPort
{
    public async Task<IReadOnlyDictionary<Guid, string>> GetNamesAsync(
        IReadOnlyCollection<Guid> equipmentIds, CancellationToken cancellationToken)
    {
        if (equipmentIds.Count == 0)
        {
            return new Dictionary<Guid, string>();
        }

        return await db.Equipment
            .Where(e => equipmentIds.Contains(e.Id))
            .ToDictionaryAsync(e => e.Id, e => e.Name, cancellationToken);
    }
}
