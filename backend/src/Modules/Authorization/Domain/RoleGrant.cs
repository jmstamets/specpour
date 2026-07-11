namespace SpecPour.Modules.Authorization.Domain;

/// <summary>
/// data-model.md RoleGrant: a (user, role, scope) row (constitution Principle VI's
/// role axis). UserId/GrantedBy are cross-module references by ID only (identity owns
/// Users) — no FK, per Principle III. Platform-scope grants require a Super Admin
/// approval reference (FR-062); no signup path can create a grant (FR-063). The
/// approval/grant workflow itself lands with the admin console (T079) — this is the
/// storage shape.
/// </summary>
public sealed class RoleGrant
{
    public required Guid Id { get; init; }

    public required Guid UserId { get; init; }

    public required Guid RoleId { get; init; }

    public required RoleGrantScopeType ScopeType { get; init; }

    /// <summary>Null for platform-scope grants (V1 issues platform-scope grants only, FR-063).</summary>
    public Guid? ScopeId { get; init; }

    public required RoleGrantPermissions Permissions { get; init; }

    public required DateTimeOffset GrantedAt { get; init; }

    public required Guid GrantedBy { get; init; }

    /// <summary>Reference to the Super Admin approval audit entry required for platform-scope grants (FR-062).</summary>
    public Guid? ApprovalReference { get; init; }

    public DateTimeOffset? RevokedAt { get; set; }
}
