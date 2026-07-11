using Minio;
using Minio.DataModel.Args;
using SpecPour.Modules.Media.Application.Ports;

namespace SpecPour.Modules.Media.Infrastructure;

/// <summary>
/// <see cref="IObjectStoragePort"/> backed by any S3-compatible endpoint — MinIO
/// locally (docker-compose.yml), an S3-compatible layer in production (R11). Uploads
/// and downloads both flow through pre-signed URLs; the API process never proxies
/// binary bytes.
/// </summary>
public sealed class MinioObjectStorageAdapter : IObjectStoragePort, IDisposable
{
    private readonly MinioClient _client;
    private readonly string _bucketName;
    private readonly SemaphoreSlim _bucketEnsureLock = new(1, 1);
    private bool _bucketEnsured;

    public MinioObjectStorageAdapter(MediaStorageOptions options)
    {
        _bucketName = options.BucketName;
        _client = (MinioClient)new MinioClient()
            .WithEndpoint(options.Endpoint)
            .WithCredentials(options.AccessKey, options.SecretKey)
            .WithSSL(options.Secure)
            .Build();
    }

    public async Task<PresignedUploadUrl> CreatePresignedUploadUrlAsync(string objectKey, string contentType, TimeSpan expiry, CancellationToken cancellationToken)
    {
        await EnsureBucketAsync(cancellationToken);

        var args = new PresignedPutObjectArgs()
            .WithBucket(_bucketName)
            .WithObject(objectKey)
            .WithExpiry((int)expiry.TotalSeconds)
            .WithHeaders(new Dictionary<string, string> { ["Content-Type"] = contentType });

        var url = await _client.PresignedPutObjectAsync(args);
        return new PresignedUploadUrl(new Uri(url), objectKey, DateTimeOffset.UtcNow.Add(expiry));
    }

    public async Task<Uri> CreatePresignedDownloadUrlAsync(string objectKey, TimeSpan expiry, CancellationToken cancellationToken)
    {
        await EnsureBucketAsync(cancellationToken);

        var args = new PresignedGetObjectArgs()
            .WithBucket(_bucketName)
            .WithObject(objectKey)
            .WithExpiry((int)expiry.TotalSeconds);

        var url = await _client.PresignedGetObjectAsync(args);
        return new Uri(url);
    }

    public async Task DeleteAsync(string objectKey, CancellationToken cancellationToken)
    {
        await EnsureBucketAsync(cancellationToken);

        var args = new RemoveObjectArgs()
            .WithBucket(_bucketName)
            .WithObject(objectKey);

        await _client.RemoveObjectAsync(args, cancellationToken);
    }

    private async Task EnsureBucketAsync(CancellationToken cancellationToken)
    {
        if (_bucketEnsured)
        {
            return;
        }

        await _bucketEnsureLock.WaitAsync(cancellationToken);
        try
        {
            if (_bucketEnsured)
            {
                return;
            }

            var existsArgs = new BucketExistsArgs().WithBucket(_bucketName);
            if (!await _client.BucketExistsAsync(existsArgs, cancellationToken))
            {
                var makeArgs = new MakeBucketArgs().WithBucket(_bucketName);
                await _client.MakeBucketAsync(makeArgs, cancellationToken);
            }

            _bucketEnsured = true;
        }
        finally
        {
            _bucketEnsureLock.Release();
        }
    }

    public void Dispose()
    {
        _client.Dispose();
        _bucketEnsureLock.Dispose();
    }
}

/// <summary>Deployment-configured S3-compatible endpoint settings (docker-compose.yml's ObjectStorage__* env vars).</summary>
public sealed class MediaStorageOptions
{
    public required string Endpoint { get; init; }
    public required string AccessKey { get; init; }
    public required string SecretKey { get; init; }
    public required string BucketName { get; init; }
    public bool Secure { get; init; }
}
