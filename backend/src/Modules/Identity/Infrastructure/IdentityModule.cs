using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption;
using Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Identity.Application.Ports;
using SpecPour.Modules.Identity.Infrastructure.OpenIddict;
using static OpenIddict.Abstractions.OpenIddictConstants;

namespace SpecPour.Modules.Identity.Infrastructure;

/// <summary>
/// Composition root for the identity module (T016 core store, T017 OpenIddict).
/// Registration/sign-in/MFA/session/lifecycle application logic lands in T047-T053;
/// this module wires the persistence, credential, and token-issuance plumbing they'll
/// sit on top of.
/// </summary>
public sealed class IdentityModule : IModule
{
    public string Name => "Identity";
    public string? SchemaName => ModuleSchemas.Identity;

    public void RegisterServices(IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetSpecPourConnectionString();

        services.AddDbContext<IdentityDbContext>(options => options.UseNpgsql(connectionString));
        services.AddSpecPourOutboxWriter(Name);

        // R6a: dedicated, rotated key ring (persisted in this module's own schema, not
        // shared with any other module's Data Protection usage) using AES-256-GCM.
        // ValidationAlgorithm is ignored by the Data Protection system for GCM ciphers
        // (GCM is self-authenticating) but the configuration API requires a value.
        services.AddDataProtection()
            .SetApplicationName("SpecPour.Identity")
            .PersistKeysToDbContext<IdentityDbContext>()
            .UseCryptographicAlgorithms(new AuthenticatedEncryptorConfiguration
            {
                EncryptionAlgorithm = EncryptionAlgorithm.AES_256_GCM,
                ValidationAlgorithm = ValidationAlgorithm.HMACSHA256,
            });

        services.AddScoped<IDateOfBirthCipher, DataProtectionDateOfBirthCipher>();

        services.AddIdentityCore<ApplicationUser>(options =>
            {
                options.User.RequireUniqueEmail = true;
                options.SignIn.RequireConfirmedEmail = true;
                options.Password.RequiredLength = 12;
            })
            .AddEntityFrameworkStores<IdentityDbContext>()
            .AddDefaultTokenProviders();

        // Cookie auth backs the interactive /connect/authorize step (the caller must
        // already be signed in via a cookie session before a code can be issued — see
        // TokenEndpoints.HandleAuthorizeAsync); a login endpoint that establishes that
        // cookie session lands in T047/T051.
        services.AddAuthentication(options => options.DefaultScheme = CookieAuthenticationDefaults.AuthenticationScheme)
            .AddCookie();

        services.AddOpenIddict()
            .AddCore(options => options.UseEntityFrameworkCore().UseDbContext<IdentityDbContext>())
            .AddServer(options =>
            {
                options.SetAuthorizationEndpointUris("/connect/authorize")
                    .SetTokenEndpointUris("/connect/token");

                options.AllowAuthorizationCodeFlow()
                    .RequireProofKeyForCodeExchange()
                    .AllowRefreshTokenFlow();

                options.RegisterScopes(Scopes.OpenId, Scopes.Email, Scopes.Profile, Scopes.OfflineAccess);

                // Ephemeral dev keys: containers have no durable certificate store.
                // Production deployments must configure real signing/encryption
                // certificates via AddSigningCertificate()/AddEncryptionCertificate()
                // (tracked as a T141 ADR follow-up) before this ever runs outside dev.
                options.AddEphemeralEncryptionKey().AddEphemeralSigningKey();

                options.UseAspNetCore()
                    .EnableAuthorizationEndpointPassthrough()
                    .EnableTokenEndpointPassthrough();

                // OpenIddict requires HTTPS transport by default. Production terminates
                // TLS at the ingress/load balancer (constitution: cloud-agnostic Docker
                // deployment), so Kestrel itself only ever sees plain HTTP there too —
                // this is not a dev-only relaxation, it reflects the real deployment
                // topology. Restoring the check requires wiring forwarded-headers
                // trust for the actual proxy, tracked under T139's hardening pass.
                options.UseAspNetCore().DisableTransportSecurityRequirement();
            })
            .AddValidation(options =>
            {
                options.UseLocalServer();
                options.UseAspNetCore();
            });

        services.AddHostedService<OpenIddictClientSeedingHostedService>();
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        TokenEndpoints.Map(endpoints);

        // Registration, sign-in, MFA, session, and lifecycle endpoints land in T047-T054.
    }
}
