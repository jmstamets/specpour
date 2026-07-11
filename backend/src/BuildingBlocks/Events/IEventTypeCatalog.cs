namespace SpecPour.BuildingBlocks.Events;

/// <summary>
/// Maps the stable string event-type name stored in the outbox row back to its CLR
/// type, so the background dispatcher (T011) can deserialize a JSON payload without
/// each module hand-rolling its own switch statement. Modules register their event
/// types during <see cref="Modules.IModule.RegisterServices"/>.
/// </summary>
public interface IEventTypeCatalog
{
    void Register<TEvent>() where TEvent : IDomainEvent;

    /// <summary>Returns the CLR type for a stored event-type name, or null if unknown (yet).</summary>
    Type? Resolve(string eventTypeName);
}

public sealed class EventTypeCatalog : IEventTypeCatalog
{
    private readonly Dictionary<string, Type> _typesByName = new(StringComparer.Ordinal);

    public void Register<TEvent>() where TEvent : IDomainEvent =>
        _typesByName[EventTypeName.For<TEvent>()] = typeof(TEvent);

    public Type? Resolve(string eventTypeName) =>
        _typesByName.TryGetValue(eventTypeName, out var type) ? type : null;
}

/// <summary>Stable event-type name derivation shared by publish (write) and dispatch (read) paths.</summary>
public static class EventTypeName
{
    public static string For<TEvent>() where TEvent : IDomainEvent => typeof(TEvent).FullName!;

    public static string For(Type eventType) => eventType.FullName!;
}
