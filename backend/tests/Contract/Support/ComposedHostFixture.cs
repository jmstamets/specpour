using System.Diagnostics;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using SpecPour.Modules.Notifications.Contracts;
using SpecPour.Modules.Notifications.Infrastructure;
using Testcontainers.PostgreSql;

namespace SpecPour.Tests.Contract.Support;

/// <summary>
/// T027's composed host: the same "real Api Program + Testcontainers PostgreSQL"
/// shape as Acceptance's SpecPourWebApplicationFactory (T026), reimplemented here
/// rather than shared across the two test assemblies — kept independently runnable
/// per plan.md's Acceptance/Contract split, at the cost of some duplication.
/// One instance is shared across every contract test in the assembly (xUnit
/// collection fixture) so the container/migrations only pay their startup cost once.
/// </summary>
// CA1001 doesn't recognize xUnit's IAsyncLifetime as a disposal contract — DisposeAsync
// below does dispose every owned field; there is no synchronous IDisposable to add
// here without either double-disposing or blocking on async cleanup.
#pragma warning disable CA1001

public sealed class ComposedHostFixture : IAsyncLifetime
{
    private PostgreSqlContainer? _postgres;
    private WebApplicationFactory<Program>? _factory;

    public HttpClient Client { get; private set; } = null!;

    /// <summary>
    /// A new client against the same composed host, with its own (empty) cookie
    /// jar — for tests that need to exercise "not yet signed in" against a host
    /// that other tests may have already established a cookie session on via the
    /// shared <see cref="Client"/>.
    /// </summary>
    public HttpClient CreateFreshClient() => _factory!.CreateClient();

    public async Task InitializeAsync()
    {
        _postgres = new PostgreSqlBuilder("postgis/postgis:17-3.5")
            .WithUsername("specpour")
            .WithPassword("specpour_dev_only")
            .WithDatabase("specpour")
            .Build();
        await _postgres.StartAsync();

        await RunMigrationsAsync(_postgres.GetConnectionString());

        Environment.SetEnvironmentVariable("ConnectionStrings__Postgres", _postgres.GetConnectionString());
        Environment.SetEnvironmentVariable("ObjectStorage__Endpoint", "http://localhost:9000");
        Environment.SetEnvironmentVariable("ObjectStorage__AccessKey", "contract-test");
        Environment.SetEnvironmentVariable("ObjectStorage__SecretKey", "contract-test");
        Environment.SetEnvironmentVariable("ObjectStorage__BucketName", "specpour-media-test");

        // T146: no reachable SMTP server here (no Testcontainers smtp4dev — that's
        // SmtpEmailChannelAdapterContractTests' own isolated concern) — swap back to
        // the logging adapter so nothing in this shared host fails on a connection
        // error unrelated to what it's testing.
        _factory = new WebApplicationFactory<Program>().WithWebHostBuilder(builder =>
            builder.ConfigureTestServices(services =>
            {
                services.RemoveAll<IEmailChannelAdapter>();
                services.AddScoped<IEmailChannelAdapter, LoggingEmailChannelAdapter>();
            }));
        Client = _factory.CreateClient();
    }

    public async Task DisposeAsync()
    {
        Client.Dispose();
        _factory?.Dispose();

        if (_postgres is not null)
        {
            await _postgres.DisposeAsync();
        }
    }

    private static async Task RunMigrationsAsync(string connectionString)
    {
        var migrationRunnerDll = LocateMigrationRunnerDll();

        var startInfo = new ProcessStartInfo("dotnet", $"\"{migrationRunnerDll}\"")
        {
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
        };
        startInfo.EnvironmentVariables["ConnectionStrings__Postgres"] = connectionString;

        using var process = Process.Start(startInfo)
            ?? throw new InvalidOperationException("Failed to start MigrationRunner process.");

        var stdOut = await process.StandardOutput.ReadToEndAsync();
        var stdErr = await process.StandardError.ReadToEndAsync();
        await process.WaitForExitAsync();

        if (process.ExitCode != 0)
        {
            throw new InvalidOperationException(
                $"MigrationRunner exited with code {process.ExitCode}.\nstdout:\n{stdOut}\nstderr:\n{stdErr}");
        }
    }

    /// <summary>See AcceptanceHooks.LocateMigrationRunnerDll for the same derivation, applied to Contract's own output layout.</summary>
    private static string LocateMigrationRunnerDll()
    {
        var segments = AppContext.BaseDirectory.TrimEnd(Path.DirectorySeparatorChar).Split(Path.DirectorySeparatorChar);
        if (segments.Length < 5 || segments[^3] != "bin" || segments[^4] != "Contract" || segments[^5] != "tests")
        {
            throw new InvalidOperationException(
                $"Unexpected test output layout '{AppContext.BaseDirectory}' — expected .../tests/Contract/bin/<Config>/<TFM>/.");
        }

        var tfm = segments[^1];
        var config = segments[^2];
        var backendRoot = string.Join(Path.DirectorySeparatorChar, segments[..^5]);

        var dllPath = Path.Combine(backendRoot, "src", "Tools", "MigrationRunner", "bin", config, tfm, "SpecPour.Tools.MigrationRunner.dll");
        if (!File.Exists(dllPath))
        {
            throw new FileNotFoundException(
                $"MigrationRunner.dll not found at '{dllPath}' — build the whole solution (dotnet build SpecPour.slnx) before running contract tests.",
                dllPath);
        }

        return dllPath;
    }
}

#pragma warning restore CA1001

// CA1711 wants types to not end in "Collection", but that's xUnit's own established
// naming convention for [CollectionDefinition] marker classes (cf. its docs' own
// "DatabaseCollection" example) — suppressed intentionally, not renamed.
#pragma warning disable CA1711

[CollectionDefinition(Name)]
public sealed class ComposedHostCollection : ICollectionFixture<ComposedHostFixture>
{
    public const string Name = "Composed host";
}

#pragma warning restore CA1711
