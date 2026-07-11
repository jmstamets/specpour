using System.Net;

namespace SpecPour.Modules.Compliance.Application.Ports;

/// <summary>
/// Coarse IP-based jurisdiction resolution (R13, Principle XII: no device location,
/// no retention of raw coordinates — this port never sees or stores anything more
/// precise than "which jurisdiction"). Returns null when the jurisdiction cannot be
/// resolved (private/unknown IP ranges, lookup failure, no database configured);
/// callers apply the strictest-rule default in that case, never a permissive one.
/// </summary>
public interface IGeoIpPort
{
    Task<string?> ResolveJurisdictionAsync(IPAddress ipAddress, CancellationToken cancellationToken);
}
