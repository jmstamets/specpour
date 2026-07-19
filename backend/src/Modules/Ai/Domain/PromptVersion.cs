namespace SpecPour.Modules.Ai.Domain;

/// <summary>
/// T068: the prompt registry (constitution's prompt-versioning requirement) —
/// version &lt;-&gt; model &lt;-&gt; provider &lt;-&gt; eval results as relational data. The
/// actual prompt TEMPLATE TEXT deliberately lives in code (in-repo, code-reviewed),
/// never here — this row is metadata about a prompt version, not its content.
/// One row per (FeatureKey, Version); <see cref="Enabled"/> is the per-feature
/// toggle T068's task text calls for, and (Provider, Model) is the labeling.
/// </summary>
public sealed class PromptVersion
{
    public required Guid Id { get; init; }

    /// <summary>e.g. "inventory.recognize" — which feature this prompt version serves.</summary>
    public required string FeatureKey { get; init; }

    public required string Version { get; init; }

    public required string Provider { get; init; }

    public required string Model { get; init; }

    public required bool Enabled { get; set; }

    public required DateTimeOffset CreatedAt { get; init; }
}
