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

            // T047/ADR-0003: the web client's cookie-based sign-in flow (register/
            // login set a cookie; /connect/authorize redeems it) is a cross-origin
            // request from the app's own origin to the API's — without
            // AllowCredentials, the browser would silently drop the Set-Cookie
            // response and never send it back, breaking the whole flow with no
            // visible error (found before it ever reached a real browser).
            // Compatible with WithOrigins/SetIsOriginAllowed above; CORS forbids
            // AllowCredentials only alongside a wildcard AllowAnyOrigin, unused here.
            policy.AllowAnyHeader().AllowAnyMethod().AllowCredentials();
        }));

        return services;
    }

    private static bool IsLocalhostOrigin(string origin) =>
        Uri.TryCreate(origin, UriKind.Absolute, out var uri)
        && uri.Host is "localhost" or "127.0.0.1" or "::1";
}
