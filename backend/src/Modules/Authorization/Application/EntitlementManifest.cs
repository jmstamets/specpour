using SpecPour.Modules.Authorization.Domain;

namespace SpecPour.Modules.Authorization.Application;

/// <summary>Shapes client UI only (contracts/openapi/paths/authorization.yaml); every capability/role check is re-enforced server-side.</summary>
public sealed record EntitlementManifest(string Tier, IReadOnlyList<string> Capabilities, IReadOnlyList<RoleGrantSummary> Roles);

public sealed record RoleGrantSummary(string RoleKey, RoleGrantScopeType ScopeType, Guid? ScopeId);
