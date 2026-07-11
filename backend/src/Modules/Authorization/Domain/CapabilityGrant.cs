namespace SpecPour.Modules.Authorization.Domain;

/// <summary>
/// data-model.md CapabilityGrant: (tier, capability) -> granted. Capability keys are
/// declared by the feature that checks them (each story's own endpoint tasks), not by
/// this module — Authorization only stores and evaluates the mapping.
/// </summary>
public sealed class CapabilityGrant
{
    public required Guid TierId { get; init; }

    public required string CapabilityKey { get; init; }

    public bool Granted { get; set; }
}
