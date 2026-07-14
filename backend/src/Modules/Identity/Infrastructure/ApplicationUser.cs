using Microsoft.AspNetCore.Identity;
using SpecPour.Modules.Identity.Domain;

namespace SpecPour.Modules.Identity.Infrastructure;

/// <summary>
/// The identity module's user aggregate (data-model.md User), built on ASP.NET Core
/// Identity's <see cref="IdentityUser{TKey}"/> (R6: the proven open-source
/// credential-storage base rather than a hand-rolled one). External logins
/// (data-model's ExternalLogin) are Identity's own built-in AspNetUserLogins table —
/// no separate entity needed. SessionDevice and MfaEnrollment (data-model's other 1:N
/// relationships) are not modeled yet; they land with session management (T051) and
/// MFA (T050).
/// </summary>
public sealed class ApplicationUser : IdentityUser<Guid>
{
    public required string DisplayName { get; set; }

    /// <summary>
    /// The sole stored representation of date of birth: AES-256-GCM ciphertext produced
    /// by <see cref="Application.Ports.IDateOfBirthCipher"/> (R6a, FR-002b). Never
    /// exposed as plaintext outside the owner's data-export flow (T053); every decrypt
    /// must be audit-logged by the caller.
    /// </summary>
    public required string EncryptedDateOfBirth { get; set; }

    public UnitPreference UnitPreference { get; set; } = UnitPreference.Milliliters;

    public required string Locale { get; set; }

    public UserLifecycleState LifecycleState { get; set; } = UserLifecycleState.Active;

    public required DateTimeOffset CreatedAt { get; init; }

    /// <summary>T052: set on POST /me/deactivate, cleared on POST /me/reactivate. Drives the grace-period-expiry background job.</summary>
    public DateTimeOffset? DeactivatedAt { get; set; }

    /// <summary>T052: set once the expiry-approaching warning has been sent, so the background job doesn't resend it every poll cycle. Cleared on reactivation.</summary>
    public DateTimeOffset? DeactivationWarningSentAt { get; set; }
}
