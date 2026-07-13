using Reqnroll;
using Testcontainers.PostgreSql;

namespace SpecPour.Tests.Acceptance.Support;

/// <summary>
/// T026's run-level lifecycle: one real PostgreSQL container and one composed host
/// for the entire test run (not per-scenario — starting a container and running
/// every module's migrations per scenario would make the suite prohibitively slow).
/// Scenarios needing isolated data are each feature's own concern (unique emails/IDs),
/// the same tradeoff any Testcontainers-backed acceptance suite makes.
/// </summary>
[Binding]
public static class AcceptanceHooks
{
    private static PostgreSqlContainer? _postgres;

    public static SpecPourWebApplicationFactory Factory { get; private set; } = null!;

    /// <summary>
    /// The shared Testcontainers connection string, exposed so tests that need
    /// their OWN composed host (e.g. the rate-limiting test, which must not spend
    /// the shared host's anonymous rate-limit budget and skew other scenarios)
    /// can point a fresh factory at the same already-migrated database.
    /// </summary>
    public static string ConnectionString =>
        _postgres?.GetConnectionString() ?? throw new InvalidOperationException("Testcontainers PostgreSQL not started yet.");

    [BeforeTestRun]
    public static async Task BeforeTestRunAsync()
    {
        // Username/password/database match docker-compose.yml's postgres service
        // exactly. Not arbitrary: T019's audit-log immutability migration hard-codes
        // `REVOKE ... FROM specpour` (the role that owns every table it just
        // created) — a mismatched Testcontainers role name makes that statement
        // fail outright, which is exactly what surfaced this dependency the first
        // time this harness ran a real migration.
        _postgres = new PostgreSqlBuilder("postgis/postgis:17-3.5")
            .WithUsername("specpour")
            .WithPassword("specpour_dev_only")
            .WithDatabase("specpour")
            .Build();
        await _postgres.StartAsync();

        await RunMigrationsAsync(_postgres.GetConnectionString());

        Factory = new SpecPourWebApplicationFactory(_postgres.GetConnectionString());
        // Force the host to start now rather than lazily on the first request, so a
        // startup failure (e.g. a missing migration) fails the whole run immediately
        // instead of surfacing as a confusing failure in an unrelated first scenario.
        _ = Factory.Server;
    }

    [AfterTestRun]
    public static async Task AfterTestRunAsync()
    {
        Factory.Dispose();

        if (_postgres is not null)
        {
            await _postgres.DisposeAsync();
        }
    }

    private static async Task RunMigrationsAsync(string connectionString)
    {
        var migrationRunnerDll = LocateMigrationRunnerDll();

        var startInfo = new System.Diagnostics.ProcessStartInfo("dotnet", $"\"{migrationRunnerDll}\"")
        {
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
        };
        startInfo.EnvironmentVariables["ConnectionStrings__Postgres"] = connectionString;

        using var process = System.Diagnostics.Process.Start(startInfo)
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

    /// <summary>
    /// Derives MigrationRunner's build output path from this project's own
    /// (.../backend/tests/Acceptance/bin/&lt;Config&gt;/&lt;TFM&gt;/), reusing the
    /// same configuration/TFM segments rather than assuming "Debug"/a fixed TFM.
    /// Requires the solution to have been built (dotnet build/test SpecPour.slnx) —
    /// same assumption every other cross-project step in this repo already makes.
    /// </summary>
    private static string LocateMigrationRunnerDll()
    {
        var segments = AppContext.BaseDirectory.TrimEnd(Path.DirectorySeparatorChar).Split(Path.DirectorySeparatorChar);
        if (segments.Length < 5 || segments[^3] != "bin" || segments[^4] != "Acceptance" || segments[^5] != "tests")
        {
            throw new InvalidOperationException(
                $"Unexpected test output layout '{AppContext.BaseDirectory}' — expected .../tests/Acceptance/bin/<Config>/<TFM>/.");
        }

        var tfm = segments[^1];
        var config = segments[^2];
        var backendRoot = string.Join(Path.DirectorySeparatorChar, segments[..^5]);

        var dllPath = Path.Combine(backendRoot, "src", "Tools", "MigrationRunner", "bin", config, tfm, "SpecPour.Tools.MigrationRunner.dll");
        if (!File.Exists(dllPath))
        {
            throw new FileNotFoundException(
                $"MigrationRunner.dll not found at '{dllPath}' — build the whole solution (dotnet build SpecPour.slnx) before running acceptance tests.",
                dllPath);
        }

        return dllPath;
    }
}
