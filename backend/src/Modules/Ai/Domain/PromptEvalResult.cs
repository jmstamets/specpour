namespace SpecPour.Modules.Ai.Domain;

/// <summary>
/// T068/T147: one evaluation run's results against a specific <see cref="PromptVersion"/>
/// — SC-008's accuracy harness records here so accuracy is tracked per prompt
/// version/provider pair over time, not just asserted once.
/// </summary>
public sealed class PromptEvalResult
{
    public required Guid Id { get; init; }

    public required Guid PromptVersionId { get; init; }

    public required DateTimeOffset EvaluatedAt { get; init; }

    public required int TotalCases { get; init; }

    public required int CorrectCases { get; init; }

    public string? Notes { get; set; }
}
