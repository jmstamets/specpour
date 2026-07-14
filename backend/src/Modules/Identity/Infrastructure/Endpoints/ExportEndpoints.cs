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
using SpecPour.Modules.Authorization.Contracts.Audit;
using SpecPour.Modules.Identity.Application.Ports;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Identity.Infrastructure.Endpoints;

/// <summary>
/// GET /api/v1/me/export, DELETE /api/v1/me (T053, contracts/api-v1-surface.md).
/// Bearer-only. GET /me/export is the SOLE surface anywhere in the platform that
/// returns the raw date of birth (FR-002b/SC-017 — the sensitive-PII invariant
/// contract test's allowlist names this exact schema, "MeExport"). DELETE /me hard-
/// deletes via AccountDeletionService, shared with T052's grace-period-expiry job.
/// </summary>
public static class ExportEndpoints
{
    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        var bearerOnly = new AuthorizeAttribute
        {
            AuthenticationSchemes = OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme,
        };

        group.MapGet("/me/export", ExportAsync).RequireAuthorization(bearerOnly);
        group.MapDelete("/me", DeleteAsync).RequireAuthorization(bearerOnly);
    }

    private static async Task<Ok<MeExportResponse>> ExportAsync(
        ClaimsPrincipal user,
        UserManager<ApplicationUser> userManager,
        IdentityDbContext db,
        IDateOfBirthCipher cipher,
        IAuditWriter auditWriter,
        CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        var account = await userManager.FindByIdAsync(userId.ToString())
            ?? throw new InvalidOperationException("The bearer token's subject no longer maps to a user account.");

        var dateOfBirth = cipher.Decrypt(userId, account.EncryptedDateOfBirth);

        // FR-002b: every raw-DOB decrypt is audit-logged, this export included —
        // same convention as AgePredicateAdapter's predicate decrypts.
        await auditWriter.WriteAsync(
            new AuditEntry(userId, "identity.dob_exported", "User", userId),
            cancellationToken);

        var mfaEnabled = await db.MfaEnrollments.AnyAsync(m => m.UserId == userId && m.EnabledAt != null, cancellationToken);
        var sessions = await db.SessionDevices
            .Where(s => s.UserId == userId && s.RevokedAt == null)
            .Select(s => new SessionResponse(s.Id, s.DeviceDescription, s.CreatedAt, s.LastSeenAt))
            .ToListAsync(cancellationToken);
        var externalLogins = await userManager.GetLoginsAsync(account);

        return TypedResults.Ok(new MeExportResponse(
            account.Id,
            account.Email!,
            account.DisplayName,
            dateOfBirth,
            account.UnitPreference.ToString(),
            account.Locale,
            account.CreatedAt,
            mfaEnabled,
            sessions,
            [.. externalLogins.Select(l => l.LoginProvider)]));
    }

    private static async Task<NoContent> DeleteAsync(
        ClaimsPrincipal user,
        AccountDeletionService deletionService,
        CancellationToken cancellationToken)
    {
        var userId = CurrentUserId(user);
        await deletionService.DeleteAsync(userId, cancellationToken);

        return TypedResults.NoContent();
    }

    private static Guid CurrentUserId(ClaimsPrincipal user) => Guid.Parse(user.GetClaim(Claims.Subject)!);
}

/// <summary>
/// The sole raw-DOB response surface in the platform (FR-002b/SC-017) — this schema
/// name is explicitly allowlisted in SensitivePiiInvariantTests.
/// </summary>
public sealed record MeExportResponse(
    Guid UserId,
    string Email,
    string DisplayName,
    DateOnly DateOfBirth,
    string UnitPreference,
    string Locale,
    DateTimeOffset CreatedAt,
    bool MfaEnabled,
    IReadOnlyList<SessionResponse> Sessions,
    IReadOnlyList<string> ExternalLoginProviders);
