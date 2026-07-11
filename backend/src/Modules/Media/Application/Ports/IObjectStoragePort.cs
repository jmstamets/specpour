namespace SpecPour.Modules.Media.Application.Ports;

/// <summary>
/// S3-compatible object storage port (constitution: all binary media behind an
/// abstraction, never in DB/local disk; no vendor SDK in domain/application code).
/// Uploads flow through pre-signed URLs — the API never proxies binary bytes.
/// </summary>
public interface IObjectStoragePort
{
    Task<PresignedUploadUrl> CreatePresignedUploadUrlAsync(string objectKey, string contentType, TimeSpan expiry, CancellationToken cancellationToken);

    Task<Uri> CreatePresignedDownloadUrlAsync(string objectKey, TimeSpan expiry, CancellationToken cancellationToken);

    Task DeleteAsync(string objectKey, CancellationToken cancellationToken);
}

public sealed record PresignedUploadUrl(Uri UploadUrl, string ObjectKey, DateTimeOffset ExpiresAt);
