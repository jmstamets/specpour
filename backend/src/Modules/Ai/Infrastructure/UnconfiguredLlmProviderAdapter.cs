using SpecPour.Modules.Ai.Contracts;

namespace SpecPour.Modules.Ai.Infrastructure;

/// <summary>
/// Interim <see cref="ILlmProviderAdapter"/> (T068): throws rather than fabricating
/// a response. Unlike recognition, no feature has defined what a safe caller-visible
/// degrade means for a text-completion failure yet (no consumer exists as of T069),
/// so failing loudly here is correct until a real consumer specifies that behavior
/// for itself — matching the constitution's fail-closed posture.
/// </summary>
public sealed class UnconfiguredLlmProviderAdapter : ILlmProviderAdapter
{
    public Task<string> CompleteAsync(PromptVersionInfo promptVersion, string input, CancellationToken cancellationToken) =>
        throw new NotSupportedException($"No LLM provider is configured for '{promptVersion.FeatureKey}' v{promptVersion.Version}.");
}
