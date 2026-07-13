using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Routing;
using SpecPour.BuildingBlocks.Http;
using SpecPour.BuildingBlocks.Identifiers;
using SpecPour.BuildingBlocks.Time;
using SpecPour.Modules.Compliance.Contracts;
using SpecPour.Modules.Identity.Application;
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

        var user = new ApplicationUser
        {
            Id = uuidGenerator.NewId(),
            UserName = request.Email,
            Email = request.Email,
            // T160 (deferred, gap review 2026-07-13): no email-verification flow is
            // built yet, but SignIn.RequireConfirmedEmail=true would otherwise permanently
            // lock every new account out of sign-in with no way to unblock it. Auto-confirm
            // for V1, same as the Super Admin bootstrap already does — revisit when T160 lands.
            EmailConfirmed = true,
            DisplayName = request.DisplayName,
            EncryptedDateOfBirth = cipher.Encrypt(request.DateOfBirth),
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

    private static async Task<Results<Ok<AuthAccountResponse>, ProblemHttpResult>> LoginAsync(
        LoginRequest request,
        SignInManager<ApplicationUser> signInManager,
        UserManager<ApplicationUser> userManager,
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

        var result = await signInManager.PasswordSignInAsync(user, request.Password, isPersistent: true, lockoutOnFailure: true);
        if (!result.Succeeded)
        {
            return TypedResults.Problem(
                title: "Sign-in failed",
                detail: "Invalid email or password.",
                statusCode: StatusCodes.Status401Unauthorized);
        }

        return TypedResults.Ok(new AuthAccountResponse(user.Id, user.Email!, user.DisplayName));
    }

    private static UnitPreference ParseUnitPreference(string? value) =>
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

public sealed record AuthAccountResponse(Guid UserId, string Email, string DisplayName);
