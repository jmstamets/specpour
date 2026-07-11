namespace SpecPour.Modules.Authorization.Domain;

/// <summary>
/// data-model.md Tier: a consumer entitlement tier as configuration data, not code
/// (constitution Principle VI, SC-011: new tiers ship by adding rows, never a
/// release). "Guest" is the configured pseudo-tier floor every anonymous caller
/// resolves to (FR-004b).
/// </summary>
public sealed class Tier
{
    public const string GuestKey = "guest";
    public const string DefaultKey = "default";

    public required Guid Id { get; init; }

    public required string Key { get; init; }

    /// <summary>Localizable display-name key (Principle VII) — never a raw display string.</summary>
    public required string DisplayNameKey { get; init; }

    public bool Active { get; set; } = true;
}
