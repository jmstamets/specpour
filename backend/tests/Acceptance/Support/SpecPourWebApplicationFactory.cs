using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Time;

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

    public SpecPourWebApplicationFactory(string connectionString)
    {
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

            // T155: the outbox dispatcher's production default (5s polling) would make
            // the rename-refresh acceptance scenario slow/flaky to poll against — fast
            // enough here that a short bounded poll in the step definition is enough,
            // production behavior (and the ADR-0002-documented eventual-consistency
            // window) is unaffected since this only applies to the test host.
            services.Configure<OutboxDispatcherOptions>(options =>
                options.PollingInterval = TimeSpan.FromMilliseconds(200));
        });
    }
}
