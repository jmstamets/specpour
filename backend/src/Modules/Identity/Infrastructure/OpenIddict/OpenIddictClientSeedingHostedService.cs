using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using OpenIddict.Abstractions;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Identity.Infrastructure.OpenIddict;

/// <summary>
/// Idempotently registers the single-page/mobile Flutter client as an OpenIddict public
/// application (no client secret — PKCE-protected, per R6) on every startup, since
/// there is no separate admin UI for client management in V1. Redirect URIs are
/// configuration-driven; the dev defaults are placeholders until the Flutter identity
/// feature (T055) exists to actually redirect anywhere.
/// </summary>
public sealed class OpenIddictClientSeedingHostedService(
    IServiceProvider serviceProvider,
    IConfiguration configuration) : IHostedService
{
    public const string ClientId = "specpour-app";

    public async Task StartAsync(CancellationToken cancellationToken)
    {
        await using var scope = serviceProvider.CreateAsyncScope();
        var applicationManager = scope.ServiceProvider.GetRequiredService<IOpenIddictApplicationManager>();

        if (await applicationManager.FindByClientIdAsync(ClientId, cancellationToken) is not null)
        {
            return;
        }

        var redirectUris = configuration.GetSection("Identity:OAuthClient:RedirectUris").Get<string[]>()
            ?? ["com.specpour.app://callback", "http://localhost:5173/callback"];

        var descriptor = new OpenIddictApplicationDescriptor
        {
            ClientId = ClientId,
            ClientType = ClientTypes.Public,
            ApplicationType = ApplicationTypes.Native,
            DisplayName = "SpecPour App (Android/iOS/Web)",
            Permissions =
            {
                Permissions.Endpoints.Authorization,
                Permissions.Endpoints.Token,
                Permissions.GrantTypes.AuthorizationCode,
                Permissions.GrantTypes.RefreshToken,
                Permissions.ResponseTypes.Code,
                Permissions.Scopes.Email,
                Permissions.Scopes.Profile,
                Permissions.Prefixes.Scope + Scopes.OfflineAccess,
            },
            Requirements = { Requirements.Features.ProofKeyForCodeExchange },
        };

        foreach (var redirectUri in redirectUris)
        {
            descriptor.RedirectUris.Add(new Uri(redirectUri, UriKind.RelativeOrAbsolute));
        }

        await applicationManager.CreateAsync(descriptor, cancellationToken);
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
