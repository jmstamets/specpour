using System.Diagnostics;
using System.Text.Json.Nodes;

namespace SpecPour.Tests.Contract.Support;

/// <summary>
/// Bundles backend/contracts/openapi/openapi.yaml (multi-file, per-module paths/*.yaml)
/// into one self-contained document, reusing the exact `redocly bundle` command
/// scripts/generate-client.sh already relies on — the same proven mechanism, not a
/// second hand-rolled multi-file $ref resolver that could disagree with the Dart
/// client's view of the contract.
/// </summary>
public static class OpenApiBundle
{
    private static readonly Lazy<Task<JsonNode>> LazyDocument = new(BundleAsync);

    public static Task<JsonNode> LoadAsync() => LazyDocument.Value;

    private static async Task<JsonNode> BundleAsync()
    {
        var repoRoot = LocateRepoRoot();
        var specPath = Path.Combine(repoRoot, "backend", "contracts", "openapi", "openapi.yaml");
        var bundlePath = Path.Combine(Path.GetTempPath(), $"specpour-openapi-bundle-{Guid.NewGuid():N}.json");

        try
        {
            var startInfo = new ProcessStartInfo("npx", $"--yes @redocly/cli bundle \"{specPath}\" -o \"{bundlePath}\" --ext json")
            {
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                WorkingDirectory = repoRoot,
            };

            using var process = Process.Start(startInfo)
                ?? throw new InvalidOperationException("Failed to start redocly bundle process.");

            var stdOut = await process.StandardOutput.ReadToEndAsync();
            var stdErr = await process.StandardError.ReadToEndAsync();
            await process.WaitForExitAsync();

            if (process.ExitCode != 0)
            {
                throw new InvalidOperationException(
                    $"redocly bundle exited with code {process.ExitCode}.\nstdout:\n{stdOut}\nstderr:\n{stdErr}");
            }

            var json = await File.ReadAllTextAsync(bundlePath);
            return JsonNode.Parse(json) ?? throw new InvalidOperationException("Bundled OpenAPI document parsed to null.");
        }
        finally
        {
            File.Delete(bundlePath);
        }
    }

    /// <summary>Same segment-derivation approach as ComposedHostFixture.LocateMigrationRunnerDll, one level further up.</summary>
    private static string LocateRepoRoot()
    {
        var segments = AppContext.BaseDirectory.TrimEnd(Path.DirectorySeparatorChar).Split(Path.DirectorySeparatorChar);
        if (segments.Length < 6 || segments[^3] != "bin" || segments[^4] != "Contract" || segments[^5] != "tests" || segments[^6] != "backend")
        {
            throw new InvalidOperationException(
                $"Unexpected test output layout '{AppContext.BaseDirectory}' — expected .../backend/tests/Contract/bin/<Config>/<TFM>/.");
        }

        return string.Join(Path.DirectorySeparatorChar, segments[..^6]);
    }
}
