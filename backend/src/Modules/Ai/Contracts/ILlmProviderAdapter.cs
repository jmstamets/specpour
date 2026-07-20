namespace SpecPour.Modules.Ai.Contracts;

/// <summary>
/// T068: raw LLM completion provider abstraction — swappable per
/// <see cref="PromptVersionInfo"/>, same shape as <see cref="IVisionProviderAdapter"/>.
/// Built now (T068's own scope) but unconsumed as of T069 — no current feature calls
/// it yet, matching the established "built, unconsumed" precedent (T021's
/// IObjectStoragePort before recipe-photo work landed). The default registration is
/// <c>UnconfiguredLlmProviderAdapter</c>, which throws rather than fabricating a
/// response — there is no safe "degrade" behavior for a text-completion port the way
/// there is for recognition (no caller-visible fallback UX has been designed for it
/// yet), so failing loudly is correct until a real consumer defines what degrading
/// should mean for its own feature.
/// </summary>
public interface ILlmProviderAdapter
{
    Task<string> CompleteAsync(PromptVersionInfo promptVersion, string input, CancellationToken cancellationToken);
}
