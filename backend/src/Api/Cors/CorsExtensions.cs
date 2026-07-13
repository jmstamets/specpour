using Microsoft.Extensions.Configuration;

namespace SpecPour.Api.Cors;

/// <summary>
/// CORS for the Flutter web client, which runs as a separate origin from the API
/// (R1 platform-parity: one API, multiple app surfaces). Origins are
/// configuration-driven (`Cors:AllowedOrigins`, e.g. the deployed web host) so
/// production is locked to known origins; when none are configured the policy
/// falls back to allowing any *localhost* origin — safe for local dev and the
/// MVP-checkpoint web-build walkthrough (any port the build is served on), never
/// a wildcard to the public internet.
/// </summary>
public static class CorsExtensions
{
    public const string PolicyName = "SpecPourWebClient";

    public static IServiceCollection AddSpecPourCors(this IServiceCollection services, IConfiguration configuration)
    {
        var configuredOrigins = configuration.GetSection("Cors:AllowedOrigins").Get<string[]>();

        services.AddCors(options => options.AddPolicy(PolicyName, policy =>
        {
            if (configuredOrigins is { Length: > 0 })
            {
                policy.WithOrigins(configuredOrigins);
            }
            else
            {
                // Dev/walkthrough default: any localhost origin, regardless of port.
                policy.SetIsOriginAllowed(IsLocalhostOrigin);
            }

            policy.AllowAnyHeader().AllowAnyMethod();
        }));

        return services;
    }

    private static bool IsLocalhostOrigin(string origin) =>
        Uri.TryCreate(origin, UriKind.Absolute, out var uri)
        && uri.Host is "localhost" or "127.0.0.1" or "::1";
}
