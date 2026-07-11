using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace SpecPour.Api.Health;

/// <summary>
/// /health/live and /health/ready (research R16). Liveness never touches a dependency
/// — it answers "is the process up", nothing more. Readiness checks PostgreSQL, the
/// one dependency every module needs, so a container that can't reach its database
/// is pulled out of rotation without being killed.
/// </summary>
public static class HealthCheckExtensions
{
    private const string ReadyTag = "ready";

    public static IServiceCollection AddSpecPourHealthChecks(this IServiceCollection services, string connectionString) =>
        services.AddHealthChecks()
            .AddNpgSql(connectionString, name: "postgres", tags: [ReadyTag])
            .Services;

    public static WebApplication MapSpecPourHealthChecks(this WebApplication app)
    {
        app.MapHealthChecks("/health/live", new HealthCheckOptions
        {
            Predicate = _ => false,
        });

        app.MapHealthChecks("/health/ready", new HealthCheckOptions
        {
            Predicate = check => check.Tags.Contains(ReadyTag),
        });

        return app;
    }
}
