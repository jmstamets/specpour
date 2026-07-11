using System.Threading.RateLimiting;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.RateLimiting;

namespace SpecPour.Api.RateLimiting;

/// <summary>
/// Anonymous-traffic rate limiting (FR-004b, research R16): unauthenticated requests
/// are partitioned by client IP and capped; authenticated requests get a much higher
/// ceiling so the limiter is effectively invisible to signed-in users. Rejections come
/// back as RFC 9457 problem+json (429) to match the API's global error convention.
/// </summary>
public static class AnonymousRateLimiterExtensions
{
    public static IServiceCollection AddSpecPourRateLimiting(this IServiceCollection services)
    {
        services.AddRateLimiter(options =>
        {
            options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;

            options.GlobalLimiter = PartitionedRateLimiter.Create<HttpContext, string>(context =>
            {
                var isAuthenticated = context.User.Identity?.IsAuthenticated == true;
                if (isAuthenticated)
                {
                    return RateLimitPartition.GetFixedWindowLimiter("authenticated", _ => new FixedWindowRateLimiterOptions
                    {
                        Window = TimeSpan.FromMinutes(1),
                        PermitLimit = 1000,
                        QueueLimit = 0,
                    });
                }

                var partitionKey = context.Connection.RemoteIpAddress?.ToString() ?? "unknown";
                return RateLimitPartition.GetFixedWindowLimiter(partitionKey, _ => new FixedWindowRateLimiterOptions
                {
                    Window = TimeSpan.FromMinutes(1),
                    PermitLimit = 100,
                    QueueLimit = 0,
                });
            });

            options.OnRejected = async (context, cancellationToken) =>
            {
                var problem = TypedResults.Problem(
                    title: "Too many requests",
                    detail: "Rate limit exceeded for anonymous traffic. Try again shortly.",
                    statusCode: StatusCodes.Status429TooManyRequests);

                await problem.ExecuteAsync(context.HttpContext);
            };
        });

        return services;
    }
}
