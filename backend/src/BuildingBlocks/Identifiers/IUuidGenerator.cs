namespace SpecPour.BuildingBlocks.Identifiers;

/// <summary>
/// Abstraction over UUIDv7 generation so application-layer code stays testable
/// (deterministic IDs in unit tests) without depending on the BCL entry point directly.
/// </summary>
public interface IUuidGenerator
{
    /// <summary>Returns a new time-ordered UUIDv7, suitable for future POS mapping (FR-059).</summary>
    Guid NewId();
}
