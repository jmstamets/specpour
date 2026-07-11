namespace SpecPour.Modules.Compliance.Domain;

/// <summary>data-model.md SurfaceGateConfig: per-surface age-gate configuration (FR-002a).</summary>
public sealed class SurfaceGateConfig
{
    public required string SurfaceKey { get; init; }

    public required GateStrictness Strictness { get; set; }
}
