namespace SpecPour.Modules.Authorization.Domain;

/// <summary>
/// data-model.md PlatformRole: the staff role catalog as configuration data (FR-061,
/// R18a). Billing Admin is modeled but dormant until paid tiers exist. Changes to this
/// catalog are configuration, never a release.
/// </summary>
public sealed class PlatformRole
{
    public static class Keys
    {
        public const string SuperAdmin = "super_admin";
        public const string Curator = "curator";
        public const string Moderator = "moderator";
        public const string Support = "support";
        public const string BillingAdmin = "billing_admin";
    }

    public required Guid Id { get; init; }

    public required string RoleKey { get; init; }

    /// <summary>Permission keys this role carries (e.g. "curation.publish", "moderation.act").</summary>
    public required IReadOnlyCollection<string> PermissionSet { get; init; }

    public bool Active { get; set; } = true;
}
