namespace SpecPour.BuildingBlocks.Events;

/// <summary>
/// Scoped (per-request/per-unit-of-work) implementation of <see cref="IDomainEventDispatcher"/>.
/// Register as Scoped alongside each module's DbContext so both resolve from the same
/// service-provider scope, which is what lets the interceptor find buffered events.
/// </summary>
public sealed class EventBuffer : IDomainEventDispatcher
{
    private readonly List<IDomainEvent> _pending = [];

    public void Raise(IDomainEvent domainEvent) => _pending.Add(domainEvent);

    /// <summary>Returns and clears all buffered events. Called by the SaveChanges interceptor.</summary>
    public IReadOnlyList<IDomainEvent> DrainPending()
    {
        if (_pending.Count == 0)
        {
            return [];
        }

        var drained = _pending.ToArray();
        _pending.Clear();
        return drained;
    }
}
