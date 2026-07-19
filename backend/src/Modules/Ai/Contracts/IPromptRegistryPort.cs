namespace SpecPour.Modules.Ai.Contracts;

/// <summary>
/// Cross-module read/write port (constitution Principle III) letting any feature
/// module resolve which prompt version is currently active for it, and record eval
/// results against that version — without depending on Ai's Domain/Infrastructure
/// directly. T068's foundation; T069 (bottle recognition) is its first consumer.
/// </summary>
public interface IPromptRegistryPort
{
    /// <summary>The currently-enabled prompt version for <paramref name="featureKey"/>, or null if none is configured/enabled — callers must treat null as "feature unavailable, degrade" rather than an error.</summary>
    Task<PromptVersionInfo?> GetActiveVersionAsync(string featureKey, CancellationToken cancellationToken);

    /// <summary>Records one evaluation run's results against a prompt version (SC-008/T147's eval harness).</summary>
    Task RecordEvalResultAsync(Guid promptVersionId, int totalCases, int correctCases, string? notes, CancellationToken cancellationToken);
}

public sealed record PromptVersionInfo(Guid Id, string FeatureKey, string Version, string Provider, string Model);
