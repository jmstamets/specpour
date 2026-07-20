namespace SpecPour.Modules.Inventory.Application.Recognition;

/// <summary>
/// T069: label-photo recognition, wrapping Ai's prompt registry + vision provider
/// (FR-030) — <see cref="LabelRecognitionResult.Recognized"/> is false whenever no
/// active prompt version is configured for "inventory.recognize" OR the underlying
/// provider couldn't identify the bottle; the caller (RecognitionEndpoints) degrades
/// to a pre-filled manual entry form in either case, never an error response.
/// </summary>
public interface ILabelRecognitionPort
{
    Task<LabelRecognitionResult> RecognizeAsync(byte[] photoBytes, CancellationToken cancellationToken);
}

public sealed record LabelRecognitionResult(bool Recognized, Guid? CandidateIngredientId, string? CandidateIngredientName)
{
    public static LabelRecognitionResult NotRecognized() => new(false, null, null);
}
