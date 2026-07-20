using Microsoft.EntityFrameworkCore;
using SpecPour.Modules.Ai.Contracts;
using SpecPour.Modules.Ai.Domain;

namespace SpecPour.Modules.Ai.Infrastructure;

/// <summary>T068's implementation of the cross-module prompt registry port.</summary>
public sealed class PromptRegistryAdapter(AiDbContext db) : IPromptRegistryPort
{
    public async Task<PromptVersionInfo?> GetActiveVersionAsync(string featureKey, CancellationToken cancellationToken)
    {
        var version = await db.PromptVersions
            .Where(p => p.FeatureKey == featureKey && p.Enabled)
            .OrderByDescending(p => p.CreatedAt)
            .FirstOrDefaultAsync(cancellationToken);

        return version is null ? null : new PromptVersionInfo(version.Id, version.FeatureKey, version.Version, version.Provider, version.Model);
    }

    public async Task RecordEvalResultAsync(Guid promptVersionId, int totalCases, int correctCases, string? notes, CancellationToken cancellationToken)
    {
        db.PromptEvalResults.Add(new PromptEvalResult
        {
            Id = Guid.NewGuid(),
            PromptVersionId = promptVersionId,
            EvaluatedAt = DateTimeOffset.UtcNow,
            TotalCases = totalCases,
            CorrectCases = correctCases,
            Notes = notes,
        });
        await db.SaveChangesAsync(cancellationToken);
    }
}
