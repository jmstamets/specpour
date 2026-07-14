using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Identity;
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
        EnrollMfaRequest request,
        ClaimsPrincipal user,
        UserManager<ApplicationUser> userManager,
        IdentityDbContext db,
        IMfaSecretCipher cipher,
        IAuditWriter auditWriter,
        IUuidGenerator uuidGenerator,
        IClock clock,
        CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);

        if (string.IsNullOrWhiteSpace(request.Code))
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

        if (!TotpCodeGenerator.VerifyCode(cipher.Decrypt(userId, enrollment.EncryptedSecret), request.Code))
        {
            return TypedResults.Problem(title: "Invalid code", statusCode: StatusCodes.Status401Unauthorized);
        }

        enrollment.EnabledAt = clock.UtcNow;
        await db.SaveChangesAsync(cancellationToken);

        // T162 security audit: enabling MFA is an account-security state change —
        // low-volume and exactly what an operator investigating a takeover wants in
        // the audit trail. Per-login secret decrypts are deliberately NOT audited
        // (see AuthEndpoints.LoginMfaAsync); this and the disable below are the
        // state-transition events worth recording.
        await auditWriter.WriteAsync(
            new AuditEntry(userId, "identity.mfa_enabled", "MfaEnrollment", enrollment.Id),
            cancellationToken);

        return TypedResults.Ok(new MfaEnrollmentResponse(Enabled: true, Secret: null, OtpAuthUri: null));
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

/// <summary>Secret/OtpAuthUri are populated only on the start-enrollment response — never re-shown after confirmation.</summary>
public sealed record MfaEnrollmentResponse(bool Enabled, string? Secret, string? OtpAuthUri);
