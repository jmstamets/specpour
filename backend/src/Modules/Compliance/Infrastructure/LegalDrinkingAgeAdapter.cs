using Microsoft.EntityFrameworkCore;
using SpecPour.Modules.Compliance.Application.Ports;
using SpecPour.Modules.Compliance.Contracts;
using SpecPour.Modules.Compliance.Domain;

namespace SpecPour.Modules.Compliance.Infrastructure;

/// <summary>
/// T155-pattern contract-sweep addition: implements the cross-module legal-drinking-age
/// port. This is the same jurisdiction-resolution logic AgeGateEndpoint used inline
/// before this extraction — moved here so Identity's registration endpoint (T047) can
/// reuse it exactly, rather than re-deriving jurisdiction rules independently.
/// </summary>
public sealed class LegalDrinkingAgeAdapter(ComplianceDbContext db, IGeoIpPort geoIp) : ILegalDrinkingAgePort
{
    public async Task<LegalDrinkingAgeRule> ResolveFromIpAsync(System.Net.IPAddress? remoteIp, CancellationToken cancellationToken)
    {
        var jurisdictionCode = remoteIp is not null
            ? await geoIp.ResolveJurisdictionAsync(remoteIp, cancellationToken)
            : null;

        var strictestRuleApplied = jurisdictionCode is null;
        var (resolvedCode, legalDrinkingAge) = await ResolveRuleAsync(jurisdictionCode ?? JurisdictionRule.DefaultCode, cancellationToken);

        return new LegalDrinkingAgeRule(resolvedCode, legalDrinkingAge, strictestRuleApplied || resolvedCode == JurisdictionRule.DefaultCode);
    }

    public async Task<int> GetLegalDrinkingAgeAsync(string jurisdictionCode, CancellationToken cancellationToken)
    {
        var (_, legalDrinkingAge) = await ResolveRuleAsync(jurisdictionCode, cancellationToken);
        return legalDrinkingAge;
    }

    private async Task<(string JurisdictionCode, int LegalDrinkingAge)> ResolveRuleAsync(string jurisdictionCode, CancellationToken cancellationToken)
    {
        var rule = await db.JurisdictionRules.FindAsync([jurisdictionCode], cancellationToken)
            ?? await db.JurisdictionRules.FindAsync([JurisdictionRule.DefaultCode], cancellationToken)
            ?? throw new InvalidOperationException("No default JurisdictionRule row is seeded.");

        return (rule.JurisdictionCode, rule.LegalDrinkingAge);
    }
}
