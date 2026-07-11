using System.Net;
using MaxMind.Db;
using MaxMind.GeoIP2;
using MaxMind.GeoIP2.Exceptions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using SpecPour.Modules.Compliance.Application.Ports;

namespace SpecPour.Modules.Compliance.Infrastructure;

/// <summary>
/// <see cref="IGeoIpPort"/> backed by a MaxMind GeoLite2/GeoIP2 Country database
/// (R13). The database file is an ops-provided deployment artifact (path via
/// <c>Compliance:GeoIpDatabasePath</c>), not something this repo ships — when it is
/// missing or unconfigured, every lookup resolves to null (unresolved), which is the
/// *correct* behavior here: callers apply the strictest-rule default, never a
/// permissive one, so an absent database fails safe rather than open.
/// </summary>
public sealed partial class MaxMindGeoIpAdapter : IGeoIpPort, IDisposable
{
    private readonly ILogger<MaxMindGeoIpAdapter> _logger;
    private readonly Lazy<DatabaseReader?> _reader;
    private bool _disposed;

    public MaxMindGeoIpAdapter(IConfiguration configuration, ILogger<MaxMindGeoIpAdapter> logger)
    {
        _logger = logger;
        _reader = new Lazy<DatabaseReader?>(() => OpenReader(configuration));
    }

    public Task<string?> ResolveJurisdictionAsync(IPAddress ipAddress, CancellationToken cancellationToken)
    {
        var reader = _reader.Value;
        if (reader is null)
        {
            return Task.FromResult<string?>(null);
        }

        try
        {
            return Task.FromResult(reader.TryCountry(ipAddress, out var response) ? response.Country.IsoCode : null);
        }
        catch (Exception ex) when (ex is AddressNotFoundException or InvalidOperationException)
        {
            Log.LookupFailed(_logger, ipAddress.ToString(), ex);
            return Task.FromResult<string?>(null);
        }
    }

    private DatabaseReader? OpenReader(IConfiguration configuration)
    {
        var path = configuration["Compliance:GeoIpDatabasePath"];
        if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
        {
            Log.DatabaseNotConfigured(_logger, path ?? "(not set)");
            return null;
        }

        return new DatabaseReader(path, FileAccessMode.Memory);
    }

    public void Dispose()
    {
        if (_disposed)
        {
            return;
        }

        if (_reader.IsValueCreated)
        {
            _reader.Value?.Dispose();
        }

        _disposed = true;
    }

    private static partial class Log
    {
        [LoggerMessage(Level = LogLevel.Warning, Message = "GeoIP database not configured or not found at '{Path}'; jurisdiction resolution will always be unresolved (strictest-rule fallback applies).")]
        public static partial void DatabaseNotConfigured(ILogger logger, string path);

        [LoggerMessage(Level = LogLevel.Warning, Message = "GeoIP lookup failed for {IpAddress}")]
        public static partial void LookupFailed(ILogger logger, string ipAddress, Exception exception);
    }
}
