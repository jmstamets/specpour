using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ModelBinding;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using OpenIddict.Abstractions;
using OpenIddict.Validation.AspNetCore;
using SpecPour.BuildingBlocks.Http;
using SpecPour.BuildingBlocks.Identifiers;
using SpecPour.BuildingBlocks.Time;
using SpecPour.Modules.Authorization.Contracts.Audit;
using SpecPour.Modules.Identity.Application.Mfa;
using SpecPour.Modules.Identity.Application.Ports;
using SpecPour.Modules.Identity.Domain;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Identity.Infrastructure.Endpoints;

/// <summary>
/// GET/POST/DELETE /api/v1/me/mfa (T050, contracts/api-v1-surface.md). Bearer-only —
/// like every other /me/* endpoint, this is called after the PKCE exchange (ADR-0003),
/// never against the interim cookie session. POST is two-phase in a single endpoint to
/// match the literal 3-verb surface: an empty/no-code body starts enrollment (issues a
/// new secret), a body carrying a code confirms the most recently issued one.
/// </summary>
public static class MfaEndpoints
{
    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        var bearerOnly = new AuthorizeAttribute
        {
            AuthenticationSchemes = OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme,
        };

        group.MapGet("/me/mfa", GetStatusAsync).RequireAuthorization(bearerOnly);
        group.MapPost("/me/mfa", EnrollOrConfirmAsync).RequireAuthorization(bearerOnly);
        group.MapDelete("/me/mfa", DisableAsync).RequireAuthorization(bearerOnly);
        group.MapPost("/me/mfa/backup-codes", RegenerateBackupCodesAsync).RequireAuthorization(bearerOnly);
    }

    private static async Task<Ok<MfaStatusResponse>> GetStatusAsync(
        ClaimsPrincipal user, IdentityDbContext db, CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        var enrollment = await db.MfaEnrollments
            .SingleOrDefaultAsync(m => m.UserId == userId && m.EnabledAt != null, cancellationToken);

        return TypedResults.Ok(new MfaStatusResponse(enrollment is not null, enrollment?.Method));
    }

    private static async Task<Results<Ok<MfaEnrollmentResponse>, ProblemHttpResult>> EnrollOrConfirmAsync(
        // F1 (2026-07-15): the body is genuinely optional — an empty POST starts
        // enrollment, a body with a code confirms it. The OpenAPI already declares
        // requestBody optional (no `required: true`), so a non-nullable parameter here
        // contradicted the contract and made the minimal-API pipeline reject the
        // no-body start call in a real browser ("Implicit body inferred ... but no body
        // was provided") — the generated Dart client sends no body for a no-arg POST,
        // where the C# acceptance test happened to send `{}`, which is why suites were
        // green while the browser was dead. EmptyBodyBehavior.Allow honors the contract.
        [FromBody(EmptyBodyBehavior = EmptyBodyBehavior.Allow)] EnrollMfaRequest? request,
        ClaimsPrincipal user,
        UserManager<ApplicationUser> userManager,
        IdentityDbContext db,
        IMfaSecretCipher cipher,
        IPasswordHasher<ApplicationUser> hasher,
        IAuditWriter auditWriter,
        IUuidGenerator uuidGenerator,
        IClock clock,
        CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);

        if (string.IsNullOrWhiteSpace(request?.Code))
        {
            // Phase 1: start enrollment. A fresh secret always replaces any prior
            // unconfirmed one — the client just re-scans the new QR code.
            var pending = await db.MfaEnrollments
                .Where(m => m.UserId == userId && m.EnabledAt == null)
                .ToListAsync(cancellationToken);
            db.MfaEnrollments.RemoveRange(pending);

            var account = await userManager.FindByIdAsync(userId.ToString());
            var secret = TotpCodeGenerator.GenerateSecret();

            db.MfaEnrollments.Add(new MfaEnrollment
            {
                Id = uuidGenerator.NewId(),
                UserId = userId,
                Method = "totp",
                EncryptedSecret = cipher.Encrypt(userId, secret),
            });
            await db.SaveChangesAsync(cancellationToken);

            var otpAuthUri = TotpCodeGenerator.BuildOtpAuthUri(secret, account!.Email!);
            return TypedResults.Ok(new MfaEnrollmentResponse(Enabled: false, secret, otpAuthUri));
        }

        // Phase 2: confirm the most recently issued (unconfirmed) secret.
        var enrollment = await db.MfaEnrollments
            .SingleOrDefaultAsync(m => m.UserId == userId && m.EnabledAt == null, cancellationToken);
        if (enrollment is null)
        {
            return TypedResults.Problem(
                title: "No pending MFA enrollment",
                detail: "Start enrollment with POST /me/mfa before confirming a code.",
                statusCode: StatusCodes.Status400BadRequest);
        }

        // request is non-null here: the empty-code branch above already returned.
        if (!TotpCodeGenerator.VerifyCode(cipher.Decrypt(userId, enrollment.EncryptedSecret), request!.Code))
        {
            return TypedResults.Problem(title: "Invalid code", statusCode: StatusCodes.Status401Unauthorized);
        }

        enrollment.EnabledAt = clock.UtcNow;

        // T163: the initial backup-code set is issued the moment MFA actually
        // becomes enabled — shown exactly once, here, same as the TOTP secret is
        // shown exactly once on the start-enrollment response.
        var confirmedUser = await userManager.FindByIdAsync(userId.ToString());
        var backupCodes = BackupCodeStore.Regenerate(confirmedUser!, db, [], hasher, uuidGenerator, clock);

        await db.SaveChangesAsync(cancellationToken);

        // T162 security audit: enabling MFA is an account-security state change —
        // low-volume and exactly what an operator investigating a takeover wants in
        // the audit trail. Per-login secret decrypts are deliberately NOT audited
        // (see AuthEndpoints.LoginMfaAsync); this and the disable below are the
        // state-transition events worth recording.
        await auditWriter.WriteAsync(
            new AuditEntry(userId, "identity.mfa_enabled", "MfaEnrollment", enrollment.Id),
            cancellationToken);
        await auditWriter.WriteAsync(
            new AuditEntry(userId, "identity.mfa_backup_codes_generated", "User", userId),
            cancellationToken);

        return TypedResults.Ok(new MfaEnrollmentResponse(Enabled: true, Secret: null, OtpAuthUri: null, backupCodes));
    }

    /// <summary>
    /// T163: regenerates the backup-code set on demand (e.g. the user used most of
    /// them, or suspects the printed/saved copy was exposed). Invalidates every prior
    /// code, used or not. Requires MFA to already be enabled — there is nothing to
    /// recover into otherwise.
    /// </summary>
    private static async Task<Results<Ok<BackupCodesResponse>, ProblemHttpResult>> RegenerateBackupCodesAsync(
        ClaimsPrincipal user,
        UserManager<ApplicationUser> userManager,
        IdentityDbContext db,
        IPasswordHasher<ApplicationUser> hasher,
        IAuditWriter auditWriter,
        IUuidGenerator uuidGenerator,
        IClock clock,
        CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        var enrollment = await db.MfaEnrollments
            .SingleOrDefaultAsync(m => m.UserId == userId && m.EnabledAt != null, cancellationToken);
        if (enrollment is null)
        {
            return TypedResults.Problem(
                title: "MFA is not enabled",
                detail: "Enable MFA (POST /me/mfa) before generating backup codes.",
                statusCode: StatusCodes.Status400BadRequest);
        }

        var account = await userManager.FindByIdAsync(userId.ToString());
        var existing = await db.MfaBackupCodes.Where(c => c.UserId == userId).ToListAsync(cancellationToken);
        var codes = BackupCodeStore.Regenerate(account!, db, existing, hasher, uuidGenerator, clock);
        await db.SaveChangesAsync(cancellationToken);

        await auditWriter.WriteAsync(
            new AuditEntry(userId, "identity.mfa_backup_codes_generated", "User", userId),
            cancellationToken);

        return TypedResults.Ok(new BackupCodesResponse(codes));
    }

    private static async Task<NoContent> DisableAsync(
        ClaimsPrincipal user,
        IdentityDbContext db,
        IAuditWriter auditWriter,
        CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        var enrollments = await db.MfaEnrollments.Where(m => m.UserId == userId).ToListAsync(cancellationToken);
        db.MfaEnrollments.RemoveRange(enrollments);

        // Backup codes are meaningless without an active enrollment (T163) — clear
        // them alongside disabling, same as the enrollment row itself.
        var backupCodes = await db.MfaBackupCodes.Where(c => c.UserId == userId).ToListAsync(cancellationToken);
        db.MfaBackupCodes.RemoveRange(backupCodes);

        await db.SaveChangesAsync(cancellationToken);

        // Audit only a real state change — the idempotent "was never enabled" 204
        // altered nothing, so recording it would just be noise (T162).
        if (enrollments.Any(e => e.EnabledAt != null))
        {
            await auditWriter.WriteAsync(
                new AuditEntry(userId, "identity.mfa_disabled", "User", userId),
                cancellationToken);
        }

        return TypedResults.NoContent();
    }

    private static Guid CurrentUserId(ClaimsPrincipal user) => Guid.Parse(user.GetClaim(Claims.Subject)!);
}

public sealed record EnrollMfaRequest(string? Code);

public sealed record MfaStatusResponse(bool Enabled, string? Method);

/// <summary>
/// Secret/OtpAuthUri are populated only on the start-enrollment response; BackupCodes
/// only on the confirm response that actually enables MFA — none of the three is
/// ever shown again afterward (T050/T163).
/// </summary>
public sealed record MfaEnrollmentResponse(bool Enabled, string? Secret, string? OtpAuthUri, IReadOnlyList<string>? BackupCodes = null);

/// <summary>The plaintext codes — shown exactly once, in this response, never retrievable again.</summary>
public sealed record BackupCodesResponse(IReadOnlyList<string> BackupCodes);
