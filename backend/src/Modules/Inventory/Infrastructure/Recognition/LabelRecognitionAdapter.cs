using SpecPour.Modules.Ai.Contracts;
using SpecPour.Modules.Inventory.Application.Recognition;

namespace SpecPour.Modules.Inventory.Infrastructure.Recognition;

/// <summary>T069's implementation of <see cref="ILabelRecognitionPort"/>.</summary>
public sealed class LabelRecognitionAdapter(IPromptRegistryPort promptRegistry, IVisionProviderAdapter visionProvider) : ILabelRecognitionPort
{
    private const string FeatureKey = "inventory.recognize";

    public async Task<LabelRecognitionResult> RecognizeAsync(byte[] photoBytes, CancellationToken cancellationToken)
    {
        var promptVersion = await promptRegistry.GetActiveVersionAsync(FeatureKey, cancellationToken);
        if (promptVersion is null)
        {
            return LabelRecognitionResult.NotRecognized();
        }

        var result = await visionProvider.RecognizeAsync(photoBytes, promptVersion, cancellationToken);
        return result.Recognized && result.CandidateIngredientId is { } ingredientId
            ? new LabelRecognitionResult(true, ingredientId, result.CandidateIngredientName)
            : LabelRecognitionResult.NotRecognized();
    }
}
