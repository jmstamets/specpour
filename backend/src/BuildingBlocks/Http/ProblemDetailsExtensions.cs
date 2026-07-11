using Microsoft.Extensions.DependencyInjection;

namespace SpecPour.BuildingBlocks.Http;

/// <summary>
/// Registers the global RFC 9457 problem+json convention (contracts/openapi/openapi.yaml
/// ProblemDetails schema): every non-2xx response carries type/title/status/detail/
/// instance plus a correlationId extension sourced from <see cref="CorrelationIdMiddleware"/>.
/// </summary>
public static class ProblemDetailsExtensions
{
    public static IServiceCollection AddSpecPourProblemDetails(this IServiceCollection services)
    {
        services.AddProblemDetails(options =>
        {
            options.CustomizeProblemDetails = context =>
            {
                context.ProblemDetails.Extensions["correlationId"] =
                    context.HttpContext.Items.TryGetValue(CorrelationId.HttpContextItemKey, out var id)
                        ? id?.ToString()
                        : context.HttpContext.TraceIdentifier;
            };
        });

        return services;
    }
}
