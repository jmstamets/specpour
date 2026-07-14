namespace SpecPour.Modules.Identity.Domain;

/// <summary>
/// T051, data-model.md SessionDevice: one row per OpenIddict authorization (the
/// "refresh-token family" — AuthorizationId is OpenIddict's own internal
/// authorization identifier, read via ClaimsPrincipal.GetAuthorizationId()).
/// Revoking a session means revoking the underlying OpenIddict authorization
/// (IOpenIddictAuthorizationManager.TryRevokeAsync) — OpenIddict itself then refuses
/// any further refresh_token grant against it, so no separate token-revocation
/// bookkeeping is needed here; this entity only adds the human-facing metadata
/// OpenIddict's own authorization/token tables don't carry.
/// </summary>
public sealed class SessionDevice
{
    public required Guid Id { get; init; }

    public required Guid UserId { get; init; }

    /// <summary>OpenIddict's internal authorization id (string — OpenIddict's own key type), not a SpecPour UUID.</summary>
    public required string AuthorizationId { get; init; }

    /// <summary>Raw User-Agent header captured at token issuance — best-effort, not a parsed device/OS model.</summary>
    public required string DeviceDescription { get; init; }

    public required DateTimeOffset CreatedAt { get; init; }

    public required DateTimeOffset LastSeenAt { get; set; }

    public DateTimeOffset? RevokedAt { get; set; }
}
