using System.Collections.Concurrent;
using SpecPour.Modules.Search.Contracts;

namespace SpecPour.Modules.Search.Infrastructure;

/// <summary>Singleton in-memory registry — populated once at startup by each content module, then read-only for the process lifetime.</summary>
public sealed class SearchableEntityRegistry : ISearchableEntityRegistry
{
    private readonly ConcurrentBag<SearchableEntityDescriptor> _descriptors = [];

    public void Register(SearchableEntityDescriptor descriptor) => _descriptors.Add(descriptor);

    public IReadOnlyList<SearchableEntityDescriptor> All => [.. _descriptors];
}
