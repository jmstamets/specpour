using System.Threading.RateLimiting;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Time;
using SpecPour.Modules.Identity.Application.Lifecycle;
using SpecPour.Modules.Notifications.Contracts;
using SpecPour.Modules.Notifications.Infrastructure;

namespace SpecPour.Tests.Acceptance.Support;

/// <summary>
/// T026's composed host: the real <c>SpecPour.Api</c> Program, every module wired
/// exactly as production does (<c>ModuleRegistry.All</c>), pointed at a
/// Testcontainers-managed PostgreSQL instead of docker-compose's. Only two things
/// differ from production: the connection string, and <see cref="IClock"/> being
/// swapped for a scenario-controllable <see cref="TestClock"/>.
/// </summary>
public sealed class SpecPourWebApplicationFactory : WebApplicationFactory<Program>
{
    public TestClock Clock { get; } = new();

    private readonly bool _enableRateLimiting;

    /// <param name="connectionString">Postgres connection string (Testcontainers-managed).</param>
    /// <param name="enableRateLimiting">
    /// Defaults to <see langword="false"/>: the shared <see cref="AcceptanceHooks.Factory"/>
    /// instance runs every feature file's scenarios in one process against one
    /// "unknown"/loopback IP partition, so the anonymous limiter (100/min,
    /// AnonymousRateLimiterExtensions) would spuriously 429 unrelated scenarios once
    /// the suite's combined anonymous request volume crosses that budget — a
    /// test-environment artifact, not a real limit breach. <see cref="RateLimitingTests"/>
    /// passes <see langword="true"/> on its own separately-constructed instance
    /// specifically to observe the real 429 behavior in isolation.
    /// </param>
    public SpecPourWebApplicationFactory(string connectionString, bool enableRateLimiting = false)
    {
        _enableRateLimiting = enableRateLimiting;
        // Program.cs reads ConnectionStrings:Postgres synchronously via
        // builder.Configuration before WebApplicationFactory's ConfigureAppConfiguration
        // layer is composed onto the host — an in-memory config source added there
        // arrives too late for that line to see. Environment variables don't have
        // this timing problem (WebApplicationBuilder.CreateBuilder wires
        // AddEnvironmentVariables() first, before any of Program.cs's own code runs),
        // so this sets the same env var convention every other tool in this repo uses.
        Environment.SetEnvironmentVariable("ConnectionStrings__Postgres", connectionString);

        // MediaModule requires object-storage config to be present to construct its
        // adapter (T021), even though no acceptance scenario yet exercises an actual
        // upload — no Testcontainers MinIO here, T026's own scope is "real
        // PostgreSQL" specifically. Placeholder values are enough for the module to
        // wire up; a real upload-flow scenario (T062+) will need to promote this to
        // a real Testcontainers MinIO instance.
        Environment.SetEnvironmentVariable("ObjectStorage__Endpoint", "http://localhost:9000");
        Environment.SetEnvironmentVariable("ObjectStorage__AccessKey", "acceptance-test");
        Environment.SetEnvironmentVariable("ObjectStorage__SecretKey", "acceptance-test");
        Environment.SetEnvironmentVariable("ObjectStorage__BucketName", "specpour-media-test");
    }

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.ConfigureTestServices(services =>
        {
            services.RemoveAll<IClock>();
            services.AddSingleton<IClock>(Clock);

            // ADR-0005 (T177): OpenIddict reads time via .NET's own TimeProvider
            // (OpenIddictServerOptions.TimeProvider), not this app's IClock — confirmed
            // via its XML docs ("if this property is not explicitly set, ... TimeProvider.
            // System is used"). Wiring it to the SAME TestClock means one Clock.Advance
            // call moves both our own logic (the 90-day absolute-cap check) and
            // OpenIddict's internal token-expiry / refresh-token-reuse-leeway timing —
            // without this, a scenario advancing Clock would silently NOT affect
            // OpenIddict's reuse-detection window, since it would still be reading the
            // real wall clock underneath.
            //
            // Deliberately NOT a global `services.AddSingleton<TimeProvider>(...)`:
            // confirmed by direct reproduction that ASP.NET Core's cookie authentication
            // handler ALSO resolves an ambient DI-registered TimeProvider, so a global
            // registration made the pre-existing T052 deactivation-warning scenario's
            // 336-day clock jump silently expire the test's cookie session too (a real,
            // if test-only, side effect this change would otherwise have introduced) —
            // scoping the custom TimeProvider directly onto OpenIddictServerOptions only
            // (a closure over Clock, no DI mediation needed) keeps cookie-auth on the
            // real wall clock, unaffected.
            services.AddOptions<OpenIddict.Server.OpenIddictServerOptions>()
                .PostConfigure(options => options.TimeProvider = new TestTimeProvider(Clock));

            // T146: the shared acceptance host has no reachable SMTP server (no
            // Testcontainers smtp4dev here — SmtpEmailChannelAdapterContractTests
            // owns that verification in isolation) — swap back to the logging
            // adapter so recovery/MFA-email scenarios (T050) don't fail on a
            // connection error unrelated to what they're testing.
            services.RemoveAll<IEmailChannelAdapter>();
            services.AddScoped<IEmailChannelAdapter, LoggingEmailChannelAdapter>();

            // T155: the outbox dispatcher's production default (5s polling) would make
            // the rename-refresh acceptance scenario slow/flaky to poll against — fast
            // enough here that a short bounded poll in the step definition is enough,
            // production behavior (and the ADR-0002-documented eventual-consistency
            // window) is unaffected since this only applies to the test host.
            services.Configure<OutboxDispatcherOptions>(options =>
                options.PollingInterval = TimeSpan.FromMilliseconds(200));

            // T052: same rationale as the outbox override above — the production
            // default (hourly) would make the deactivation-warning/grace-period-expiry
            // acceptance scenarios impractically slow to poll against.
            services.Configure<LifecycleOptions>(options =>
                options.PollingInterval = TimeSpan.FromMilliseconds(200));

            // T051 gap review, 2026-07-14: the anonymous rate limiter (100/min per IP,
            // AnonymousRateLimiterExtensions) correctly-but-unhelpfully 429s legitimate
            // traffic once run against the WHOLE acceptance suite in one process — every
            // TestServer request shares one "unknown"/loopback IP partition, so running
            // every feature file's scenarios together in a short window comfortably
            // exceeds 100 anonymous requests (each PKCE dance alone hits /connect/token
            // pre-bearer-auth, counted as anonymous). Disabled here (the shared-host
            // default, enableRateLimiting: false) — same "test-only override of a
            // production concern" pattern as IClock/IEmailChannelAdapter/the outbox
            // polling interval above, not a change to the real limiter's production
            // config. RateLimitingTests.cs opts back in (enableRateLimiting: true) on
            // its own separately-constructed instance to exercise real 429 behavior.
            if (!_enableRateLimiting)
            {
                services.Configure<RateLimiterOptions>(options =>
                    options.GlobalLimiter = PartitionedRateLimiter.Create<HttpContext, string>(
                        _ => RateLimitPartition.GetNoLimiter("acceptance-tests")));
            }
        });
    }
}
