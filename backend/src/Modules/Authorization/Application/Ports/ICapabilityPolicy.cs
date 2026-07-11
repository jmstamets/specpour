using System.Security.Claims;

namespace SpecPour.Modules.Authorization.Application.Ports;

/// <summary>
/// The capability policy layer (T018, constitution Principle VI): resolves a caller's
/// tier, the capabilities that tier grants, and any active platform-scope role grants.
/// Works uniformly for anonymous callers (guest pseudo-tier floor, FR-004b) — there is
/// no "unauthorized" outcome for this evaluation, only "which capabilities".
/// </summary>
public interface ICapabilityPolicy
{
    Task<EntitlementManifest> GetEntitlementManifestAsync(ClaimsPrincipal principal, CancellationToken cancellationToken);

    /// <summary>Server-side enforcement primitive: does the caller currently hold this capability?</summary>
    Task<bool> HasCapabilityAsync(ClaimsPrincipal principal, string capabilityKey, CancellationToken cancellationToken);
}
