namespace SpecPour.Modules.Ai.Contracts;

/// <summary>
/// T068: raw vision/image-recognition provider abstraction — swappable per
/// <see cref="PromptVersionInfo"/> (constitution's provider-abstraction requirement).
/// A real implementation is expected to ground its recognition against the actual
/// ingredient catalog itself (e.g. retrieval-augmented prompting), returning a real
/// <see cref="VisionRecognitionResult.CandidateIngredientId"/> — not raw OCR text —
/// since catalog-matching strategy is provider/prompt-specific plumbing, not this
/// port's concern. No real provider is wired yet (no credentials in this
/// environment); the default registration is
/// <c>UnconfiguredVisionProviderAdapter</c>, always returning "not recognized" —
/// correct behavior today, not a stub masquerading as complete, same posture as
/// <c>LoggingEmailChannelAdapter</c> before T146 wired real SMTP.
/// </summary>
public interface IVisionProviderAdapter
{
    Task<VisionRecognitionResult> RecognizeAsync(byte[] imageBytes, PromptVersionInfo promptVersion, CancellationToken cancellationToken);
}

public sealed record VisionRecognitionResult(bool Recognized, Guid? CandidateIngredientId, string? CandidateIngredientName, decimal? Confidence);
