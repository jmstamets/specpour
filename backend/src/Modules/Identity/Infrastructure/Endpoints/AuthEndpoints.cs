using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Http;
using SpecPour.BuildingBlocks.Identifiers;
using SpecPour.BuildingBlocks.Time;
using SpecPour.Modules.Authorization.Contracts.Audit;
using SpecPour.Modules.Compliance.Contracts;
using SpecPour.Modules.Identity.Application;
using SpecPour.Modules.Identity.Application.Mfa;
using SpecPour.Modules.Identity.Application.Ports;
using SpecPour.Modules.Identity.Domain;

namespace SpecPour.Modules.Identity.Infrastructure.Endpoints;

/// <summary>
/// POST /api/v1/auth/register, POST /api/v1/auth/login (T047,
/// contracts/openapi/paths/identity.yaml). Anonymous, rate-limited by the existing
/// anonymous traffic limiter (Phase 2) — no additional throttling needed here (FR-002c's
/// "rate limiting" requirement is satisfied by that shared middleware). Both endpoints
/// establish the cookie session /connect/authorize depends on (T017); the caller then
/// completes the standard authorization-code+PKCE exchange against /connect/authorize
/// and /connect/token to obtain the actual API access/refresh tokens — this endpoint
/// never mints those directly (see ADR-0003).
/// </summary>
public static class AuthEndpoints
{
    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        group.MapPost("/auth/register", RegisterAsync);
        group.MapPost("/auth/login", LoginAsync);
        group.MapPost("/auth/login/mfa", LoginMfaAsync);
    }

    private static async Task<Results<Created<AuthAccountResponse>, ProblemHttpResult>> RegisterAsync(
        RegisterRequest request,
        HttpContext httpContext,
        UserManager<ApplicationUser> userManager,
        SignInManager<ApplicationUser> signInManager,
        IDateOfBirthCipher cipher,
        ILegalDrinkingAgePort legalDrinkingAge,
        IUuidGenerator uuidGenerator,
        IClock clock,
        CancellationToken cancellationToken)
    {
        // FR-002c: the underage check happens BEFORE anything is persisted — no DOB,
        // no identifying record of the attempt. Jurisdiction resolution is the same
        // coarse-IP logic GET /compliance/age-gate uses (ILegalDrinkingAgePort), so a
        // guest sees the same threshold at the gate that registration will enforce.
        var rule = await legalDrinkingAge.ResolveFromIpAsync(httpContext.Connection.RemoteIpAddress, cancellationToken);
        var today = DateOnly.FromDateTime(clock.UtcNow.UtcDateTime);
        var age = AgeCalculator.CalculateAge(request.DateOfBirth, today);

        if (age < rule.LegalDrinkingAge)
        {
            return TypedResults.Problem(
                title: "Underage registration",
                detail: "Registration requires meeting the applicable legal drinking age.",
                statusCode: StatusCodes.Status403Forbidden);
        }

        // Generated before the object initializer (not user.Id) because T164's AAD
        // binding needs the id to encrypt the DOB with — the object doesn't exist yet
        // inside its own initializer.
        var newUserId = uuidGenerator.NewId();
        var user = new ApplicationUser
        {
            Id = newUserId,
            UserName = request.Email,
            Email = request.Email,
            // T160 (deferred, gap review 2026-07-13): no email-verification flow is
            // built yet, but SignIn.RequireConfirmedEmail=true would otherwise permanently
            // lock every new account out of sign-in with no way to unblock it. Auto-confirm
            // for V1, same as the Super Admin bootstrap already does — revisit when T160 lands.
            EmailConfirmed = true,
            DisplayName = request.DisplayName,
            EncryptedDateOfBirth = cipher.Encrypt(newUserId, request.DateOfBirth),
            UnitPreference = ParseUnitPreference(request.UnitPreference),
            Locale = string.IsNullOrWhiteSpace(request.Locale) ? "en-US" : request.Locale,
            CreatedAt = clock.UtcNow,
        };

        var createResult = await userManager.CreateAsync(user, request.Password);
        if (!createResult.Succeeded)
        {
            return TypedResults.Problem(
                title: "Registration failed",
                detail: string.Join("; ", createResult.Errors.Select(e => e.Description)),
                statusCode: StatusCodes.Status400BadRequest);
        }

        await signInManager.SignInAsync(user, isPersistent: true);

        return TypedResults.Created(
            $"/api/v1/me",
            new AuthAccountResponse(user.Id, user.Email!, user.DisplayName));
    }

    private static async Task<Results<Ok<LoginResponse>, ProblemHttpResult>> LoginAsync(
        LoginRequest request,
        HttpContext httpContext,
        SignInManager<ApplicationUser> signInManager,
        UserManager<ApplicationUser> userManager,
        IdentityDbContext db,
        CancellationToken cancellationToken)
    {
        var user = await userManager.FindByEmailAsync(request.Email);
        if (user is null || user.LifecycleState is UserLifecycleState.Deleted or UserLifecycleState.Suspended)
        {
            // Same generic failure for "no such account" and "suspended/deleted" —
            // distinguishing them would let an attacker enumerate valid emails.
            return TypedResults.Problem(
                title: "Sign-in failed",
                detail: "Invalid email or password.",
                statusCode: StatusCodes.Status401Unauthorized);
        }

        // T050: CheckPasswordSignInAsync (not PasswordSignInAsync) — it validates the
        // password and lockout state without establishing any cookie, so an MFA-enabled
        // account never gets a full session before the code is verified.
        var checkResult = await signInManager.CheckPasswordSignInAsync(user, request.Password, lockoutOnFailure: true);
        if (!checkResult.Succeeded)
        {
            return TypedResults.Problem(
                title: "Sign-in failed",
                detail: "Invalid email or password.",
                statusCode: StatusCodes.Status401Unauthorized);
        }

        return TypedResults.Ok(await SignInOrChallengeMfaAsync(user, httpContext, signInManager, db, cancellationToken));
    }

    /// <summary>
    /// Shared by the password login path above and T049's external-provider callback:
    /// establishes the real session directly, or parks the caller in MfaPendingScheme
    /// and reports requiresMfa=true, depending on whether MfaEnrollment is enabled —
    /// so a user can't bypass their own MFA just by signing in via a social provider.
    /// </summary>
    internal static async Task<LoginResponse> SignInOrChallengeMfaAsync(
        ApplicationUser user,
        HttpContext httpContext,
        SignInManager<ApplicationUser> signInManager,
        IdentityDbContext db,
        CancellationToken cancellationToken)
    {
        var mfaEnabled = await db.MfaEnrollments.AnyAsync(m => m.UserId == user.Id && m.EnabledAt != null, cancellationToken);
        if (mfaEnabled)
        {
            var pendingPrincipal = new ClaimsPrincipal(new ClaimsIdentity(
                [new Claim(ClaimTypes.NameIdentifier, user.Id.ToString())],
                IdentityModule.MfaPendingScheme));
            await httpContext.SignInAsync(IdentityModule.MfaPendingScheme, pendingPrincipal);

            return new LoginResponse(RequiresMfa: true, UserId: null, Email: null, DisplayName: null);
        }

        await signInManager.SignInAsync(user, isPersistent: true);
        return new LoginResponse(RequiresMfa: false, user.Id, user.Email!, user.DisplayName);
    }

    /// <summary>
    /// Completes a sign-in that LoginAsync parked in the MfaPendingScheme cookie
    /// (T050). Accepts either the current TOTP code or, per T163 (FR-001a — password
    /// recovery must not bypass MFA, and MFA loss must not be permanent lockout), a
    /// single-use backup code as a fallback when the TOTP code doesn't verify.
    /// </summary>
    private static async Task<Results<Ok<AuthAccountResponse>, ProblemHttpResult>> LoginMfaAsync(
        LoginMfaRequest request,
        HttpContext httpContext,
        SignInManager<ApplicationUser> signInManager,
        UserManager<ApplicationUser> userManager,
        IdentityDbContext db,
        IMfaSecretCipher cipher,
        IPasswordHasher<ApplicationUser> hasher,
        IAuditWriter auditWriter,
        IClock clock,
        CancellationToken cancellationToken)
    {
        var pendingAuth = await httpContext.AuthenticateAsync(IdentityModule.MfaPendingScheme);
        var pendingUserId = pendingAuth.Principal?.FindFirstValue(ClaimTypes.NameIdentifier);
        if (!pendingAuth.Succeeded || pendingUserId is null)
        {
            return TypedResults.Problem(
                title: "No pending MFA challenge",
                detail: "Sign in with a password first.",
                statusCode: StatusCodes.Status400BadRequest);
        }

        var userId = Guid.Parse(pendingUserId);
        var enrollment = await db.MfaEnrollments.SingleOrDefaultAsync(m => m.UserId == userId && m.EnabledAt != null, cancellationToken);
        var user = enrollment is null ? null : await userManager.FindByIdAsync(userId.ToString());
        if (enrollment is null || user is null)
        {
            return TypedResults.Problem(
                title: "Sign-in failed",
                detail: "Invalid MFA code.",
                statusCode: StatusCodes.Status401Unauthorized);
        }

        // This per-login TOTP decrypt is deliberately NOT audit-logged (T162 security
        // audit): the append-only audit log records administrative/staff actions and
        // account-security state changes (constitution Principle XIV, FR-065), and a
        // row per sign-in would turn it into a login-activity ledger — that visibility
        // belongs to T051's session/device management and OTel, not the admin audit
        // table. The state transitions (enable/disable/backup-code-consumed) ARE
        // audited — the last one because a consumed recovery code is exactly the kind
        // of "was this factor lost" signal an operator investigating a takeover wants.
        var totpValid = TotpCodeGenerator.VerifyCode(cipher.Decrypt(userId, enrollment.EncryptedSecret), request.Code);
        var backupCodeConsumed = !totpValid
            && await BackupCodeStore.TryConsumeAsync(user, request.Code, db, hasher, clock, cancellationToken);

        if (!totpValid && !backupCodeConsumed)
        {
            return TypedResults.Problem(
                title: "Sign-in failed",
                detail: "Invalid MFA code.",
                statusCode: StatusCodes.Status401Unauthorized);
        }

        if (backupCodeConsumed)
        {
            await db.SaveChangesAsync(cancellationToken);
            await auditWriter.WriteAsync(
                new AuditEntry(userId, "identity.mfa_backup_code_consumed", "User", userId),
                cancellationToken);
        }

        await httpContext.SignOutAsync(IdentityModule.MfaPendingScheme);
        await signInManager.SignInAsync(user, isPersistent: true);

        return TypedResults.Ok(new AuthAccountResponse(user.Id, user.Email!, user.DisplayName));
    }

    internal static UnitPreference ParseUnitPreference(string? value) =>
        Enum.TryParse<UnitPreference>(value, ignoreCase: true, out var parsed) ? parsed : UnitPreference.Milliliters;
}

public sealed record RegisterRequest(
    string Email,
    string Password,
    string DisplayName,
    DateOnly DateOfBirth,
    string? UnitPreference,
    string? Locale);

public sealed record LoginRequest(string Email, string Password);

public sealed record LoginMfaRequest(string Code);

/// <summary>
/// User fields are null when RequiresMfa is true (the caller isn't signed in yet) —
/// call POST /auth/login/mfa with a TOTP code to complete sign-in.
/// </summary>
public sealed record LoginResponse(bool RequiresMfa, Guid? UserId, string? Email, string? DisplayName);

public sealed record AuthAccountResponse(Guid UserId, string Email, string DisplayName);
