using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using OpenIddict.Abstractions;
using SpecPour.Modules.Authorization.Application;
using SpecPour.Modules.Authorization.Application.Ports;
using SpecPour.Modules.Authorization.Domain;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Authorization.Infrastructure;

/// <summary>
/// T018's capability policy layer. V1 has exactly two tiers (guest, default; SC-011
/// lets more ship as configuration rows later) so tier resolution today is simply
/// "authenticated or not" — there is no per-user tier assignment table yet because
/// none is needed until paid tiers exist.
/// </summary>
public sealed class CapabilityPolicy(AuthorizationDbContext db) : ICapabilityPolicy
{
    public async Task<EntitlementManifest> GetEntitlementManifestAsync(ClaimsPrincipal principal, CancellationToken cancellationToken)
    {
        var isAuthenticated = principal.Identity?.IsAuthenticated == true;
        var tierKey = isAuthenticated ? Tier.DefaultKey : Tier.GuestKey;

        var tier = await db.Tiers.SingleAsync(t => t.Key == tierKey, cancellationToken);

        var capabilities = await db.CapabilityGrants
            .Where(c => c.TierId == tier.Id && c.Granted)
            .Select(c => c.CapabilityKey)
            .ToListAsync(cancellationToken);

        var roles = new List<RoleGrantSummary>();
        if (isAuthenticated)
        {
            var userId = GetUserId(principal);
            roles = await (
                from grant in db.RoleGrants
                join role in db.PlatformRoles on grant.RoleId equals role.Id
                where grant.UserId == userId && grant.RevokedAt == null && role.Active
                select new RoleGrantSummary(role.RoleKey, grant.ScopeType, grant.ScopeId))
                .ToListAsync(cancellationToken);
        }

        return new EntitlementManifest(tier.Key, capabilities, roles);
    }

    public async Task<bool> HasCapabilityAsync(ClaimsPrincipal principal, string capabilityKey, CancellationToken cancellationToken)
    {
        var manifest = await GetEntitlementManifestAsync(principal, cancellationToken);
        return manifest.Capabilities.Contains(capabilityKey, StringComparer.Ordinal);
    }

    private static Guid GetUserId(ClaimsPrincipal principal)
    {
        var subject = principal.GetClaim(Claims.Subject)
            ?? throw new InvalidOperationException("Authenticated principal is missing a subject claim.");
        return Guid.Parse(subject);
    }
}
