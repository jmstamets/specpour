namespace SpecPour.BuildingBlocks.Identifiers;

/// <summary>
/// Default <see cref="IUuidGenerator"/> backed by the BCL's native UUIDv7 support
/// (RFC 9562, available since .NET 9's <see cref="Guid.CreateVersion7()"/>).
/// </summary>
public sealed class UuidV7Generator : IUuidGenerator
{
    public Guid NewId() => Guid.CreateVersion7();
}
