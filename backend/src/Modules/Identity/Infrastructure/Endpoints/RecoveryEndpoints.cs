using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Routing;
using Microsoft.AspNetCore.WebUtilities;
using SpecPour.BuildingBlocks.Http;
using SpecPour.Modules.Notifications.Contracts;

namespace SpecPour.Modules.Identity.Infrastructure.Endpoints;

/// <summary>
/// POST /api/v1/auth/recovery (+confirm) (T050, contracts/api-v1-surface.md). Anonymous.
/// Uses ASP.NET Core Identity's own password-reset token (UserManager.
/// Generate/ResetPasswordTokenAsync) — a time-limited, purpose-bound Data Protection
/// token unrelated to the custom MfaEnrollment/TOTP machinery, so no new token
/// abstraction is needed here. The request step always returns 202 regardless of
/// whether the email matches an account, to avoid account enumeration (same rationale
/// as LoginAsync's generic 401).
/// </summary>
public static class RecoveryEndpoints
{
    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        group.MapPost("/auth/recovery", RequestAsync);
        group.MapPost("/auth/recovery/confirm", ConfirmAsync);
    }

    private static async Task<Accepted> RequestAsync(
        RecoveryRequest request,
        UserManager<ApplicationUser> userManager,
        IEmailChannelAdapter emailChannel,
        CancellationToken cancellationToken)
    {
        var user = await userManager.FindByEmailAsync(request.Email);
        if (user is not null)
        {
            var token = await userManager.GeneratePasswordResetTokenAsync(user);
            // WebEncoders: the token is URL-unsafe raw bytes by default (contains '+',
            // '/', '='); the confirm step must decode with the matching WebEncoders
            // call before handing it back to ResetPasswordAsync.
            var encodedToken = WebEncoders.Base64UrlEncode(System.Text.Encoding.UTF8.GetBytes(token));

            await emailChannel.SendAsync(
                new EmailMessage(
                    ToAddress: user.Email!,
                    Subject: "SpecPour account recovery",
                    BodyText: $"Use this code to reset your password: {encodedToken}\n\nIf you didn't request this, you can ignore this email."),
                cancellationToken);
        }

        return TypedResults.Accepted((string?)null);
    }

    private static async Task<Results<Ok, ProblemHttpResult>> ConfirmAsync(
        RecoveryConfirmRequest request,
        UserManager<ApplicationUser> userManager,
        CancellationToken cancellationToken)
    {
        var user = await userManager.FindByEmailAsync(request.Email);
        if (user is null)
        {
            return TypedResults.Problem(title: "Recovery failed", statusCode: StatusCodes.Status400BadRequest);
        }

        string token;
        try
        {
            token = System.Text.Encoding.UTF8.GetString(WebEncoders.Base64UrlDecode(request.Token));
        }
        catch (FormatException)
        {
            return TypedResults.Problem(title: "Recovery failed", detail: "Invalid token.", statusCode: StatusCodes.Status400BadRequest);
        }

        var result = await userManager.ResetPasswordAsync(user, token, request.NewPassword);
        if (!result.Succeeded)
        {
            return TypedResults.Problem(
                title: "Recovery failed",
                detail: string.Join("; ", result.Errors.Select(e => e.Description)),
                statusCode: StatusCodes.Status400BadRequest);
        }

        return TypedResults.Ok();
    }
}

public sealed record RecoveryRequest(string Email);

public sealed record RecoveryConfirmRequest(string Email, string Token, string NewPassword);
