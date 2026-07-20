using Microsoft.Extensions.Logging;
using SpecPour.Modules.Ai.Contracts;

namespace SpecPour.Modules.Ai.Infrastructure;

/// <summary>
/// Interim <see cref="IVisionProviderAdapter"/> (T068): always reports "not
/// recognized" — correct behavior today, not a stub masquerading as complete
/// (same posture as <c>LoggingEmailChannelAdapter</c> before T146). No real vision
/// provider is configured in this environment; a real provider-backed adapter is a
/// separate, credentialed task, replacing this one without any caller-side changes,
/// since both satisfy the same contract.
/// </summary>
public sealed partial class UnconfiguredVisionProviderAdapter(ILogger<UnconfiguredVisionProviderAdapter> logger) : IVisionProviderAdapter
{
    public Task<VisionRecognitionResult> RecognizeAsync(byte[] imageBytes, PromptVersionInfo promptVersion, CancellationToken cancellationToken)
    {
        Log.RecognitionSkipped(logger, promptVersion.FeatureKey, promptVersion.Version);
        return Task.FromResult(new VisionRecognitionResult(false, null, null, null));
    }

    private static partial class Log
    {
        [LoggerMessage(Level = LogLevel.Information, Message = "Vision recognition for {FeatureKey} v{Version} skipped: no real provider configured, degrading to not-recognized.")]
        public static partial void RecognitionSkipped(ILogger logger, string featureKey, string version);
    }
}
