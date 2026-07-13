using System.Net;

namespace SpecPour.Modules.Compliance.Contracts;

/// <summary>
/// Cross-module read port (constitution Principle III) exposing Compliance's
/// jurisdiction-aware legal-drinking-age resolution (R13/FR-002a) — the same logic
/// backing GET /compliance/age-gate, extracted here so Identity's registration
/// endpoint (T047) can validate a submitted date of birth against the same rule the
/// anonymous age gate uses, without depending on Compliance's Domain/Infrastructure
/// or querying its schema directly.
/// </summary>
public interface ILegalDrinkingAgePort
{
    /// <summary>
    /// Resolves the applicable rule from a caller's IP address (coarse geolocation,
    /// Principle XII — never more precise than "which jurisdiction"). Falls back to
    /// the strictest configured default when <paramref name="remoteIp"/> is null or
    /// the jurisdiction can't be resolved.
    /// </summary>
    Task<LegalDrinkingAgeRule> ResolveFromIpAsync(IPAddress? remoteIp, CancellationToken cancellationToken);

    /// <summary>
    /// Resolves the legal drinking age for an already-known jurisdiction code (e.g.
    /// one recorded on a user's account), falling back to the strictest configured
    /// default when the code has no matching rule.
    /// </summary>
    Task<int> GetLegalDrinkingAgeAsync(string jurisdictionCode, CancellationToken cancellationToken);
}

/// <summary>
/// A resolved jurisdiction rule. <see cref="StrictestRuleApplied"/> is true whenever
/// the caller's actual jurisdiction couldn't be determined and the strictest
/// configured default was used instead (R13 — never silently permissive).
/// </summary>
public sealed record LegalDrinkingAgeRule(string JurisdictionCode, int LegalDrinkingAge, bool StrictestRuleApplied);
