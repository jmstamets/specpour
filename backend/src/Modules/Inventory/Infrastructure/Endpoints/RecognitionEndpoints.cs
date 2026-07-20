using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Routing;
using OpenIddict.Validation.AspNetCore;
using SpecPour.BuildingBlocks.Http;
using SpecPour.Modules.Inventory.Application.Recognition;

namespace SpecPour.Modules.Inventory.Infrastructure.Endpoints;

/// <summary>
/// POST /api/v1/inventory/recognize (T069, FR-030). Bearer-only. Always 200 —
/// recognition failure/unavailability is a normal, expected outcome (degrade to a
/// pre-filled manual entry form), never an error response.
/// </summary>
public static class RecognitionEndpoints
{
    public static void Map(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapApiV1Group();
        var bearerOnly = new AuthorizeAttribute
        {
            AuthenticationSchemes = OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme,
        };

        group.MapPost("/inventory/recognize", RecognizeAsync).RequireAuthorization(bearerOnly);
    }

    private static async Task<Ok<RecognitionResponse>> RecognizeAsync(
        RecognizeRequest request, ILabelRecognitionPort recognitionPort, CancellationToken cancellationToken)
    {
        // T069: this environment carries no real vision-provider transport (no
        // credentials) — photoUrl is accepted (matching the acceptance-test payload
        // shape FR-030 implies) but not yet fetched/decoded into real bytes; that
        // wiring belongs with the real provider integration, a separate, credentialed
        // task (mirrors T146's real-SMTP follow-up to the interim email adapter).
        var result = await recognitionPort.RecognizeAsync([], cancellationToken);

        var manualEntryForm = new ManualEntryFormResponse(result.CandidateIngredientId, result.CandidateIngredientName);
        return TypedResults.Ok(new RecognitionResponse(result.Recognized, result.CandidateIngredientId, manualEntryForm));
    }
}

public sealed record RecognizeRequest(string? PhotoUrl);

public sealed record ManualEntryFormResponse(Guid? PrefilledIngredientId, string? PrefilledIngredientName);

public sealed record RecognitionResponse(bool Recognized, Guid? CandidateIngredientId, ManualEntryFormResponse ManualEntryForm);
