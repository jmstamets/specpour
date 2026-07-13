using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption;
using Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Primitives;
using OpenIddict.Validation.AspNetCore;
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

        // T155: the outbox interceptor must be attached here (not merely
        // DI-registered) for OutboxSaveChangesInterceptor to actually run — a
        // gap discovered while wiring T155's ingredient-rename event (the first
        // real outbox producer/consumer in the codebase). Fixed identically
        // across every module for consistency.
        services.AddDbContext<IdentityDbContext>((sp, options) =>
        {
            options.UseNpgsql(connectionString);
            options.AddInterceptors(sp.GetRequiredService<OutboxSaveChangesInterceptor>());
        });
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
        services.AddScoped<Contracts.IAgePredicatePort, AgePredicateAdapter>();

        services.AddIdentityCore<ApplicationUser>(options =>
            {
                options.User.RequireUniqueEmail = true;
                options.SignIn.RequireConfirmedEmail = true;

                // T047: "modern credential handling" (FR-001) follows current NIST
                // 800-63B guidance — length is the meaningful strength signal, not
                // arbitrary composition rules (which push users toward predictable
                // substitutions like "Password1!"). RequiredLength=12 was already set
                // in T017; the other four ASP.NET Core Identity defaults
                // (RequireDigit/RequireLowercase/RequireUppercase/RequireNonAlphanumeric,
                // all true by default) were never explicitly overridden until this
                // task actually exercised the policy — long passphrases like "correct
                // horse battery staple" should be accepted.
                options.Password.RequiredLength = 12;
                options.Password.RequireDigit = false;
                options.Password.RequireLowercase = false;
                options.Password.RequireUppercase = false;
                options.Password.RequireNonAlphanumeric = false;
            })
            .AddEntityFrameworkStores<IdentityDbContext>()
            .AddDefaultTokenProviders()
            // AddIdentityCore alone doesn't register SignInManager<TUser> — T047's
            // register/login endpoints need it to establish the cookie session
            // /connect/authorize depends on.
            .AddSignInManager();

        // Cookie auth backs the interactive /connect/authorize step (the caller must
        // already be signed in via a cookie session before a code can be issued — see
        // TokenEndpoints.HandleAuthorizeAsync). Registered under IdentityConstants.
        // ApplicationScheme ("Identity.Application") rather than the generic
        // CookieAuthenticationDefaults name: SignInManager.SignInAsync (T047's
        // AuthEndpoints) signs in against that scheme by convention, and
        // TokenEndpoints must authenticate against the SAME scheme name or the two
        // halves of "establish a cookie, then redeem it at /connect/authorize" never
        // agree on which cookie they mean.
        //
        // The actual DEFAULT scheme is a policy scheme that picks cookie vs. bearer
        // per-request (standard ASP.NET Core hybrid-auth pattern): endpoints that read
        // httpContext.User without an explicit RequireAuthorization/scheme (e.g.
        // EntitlementsEndpoint's guest-or-authenticated GetEntitlementManifestAsync)
        // would otherwise only ever see the cookie scheme's view — an Authorization:
        // Bearer header would sit unused. Discovered via T045's acceptance test: the
        // first real end-to-end bearer token this codebase ever minted, checked
        // against GET /me/entitlements, resolved as "guest" despite a valid token.
        const string HybridSchemeName = "SpecPour.CookieOrBearer";
        services.AddAuthentication(options =>
            {
                options.DefaultScheme = HybridSchemeName;
                options.DefaultChallengeScheme = HybridSchemeName;
            })
            .AddPolicyScheme(HybridSchemeName, "Cookie or bearer, selected per-request", options =>
            {
                options.ForwardDefaultSelector = context =>
                    context.Request.Headers.TryGetValue("Authorization", out StringValues authorization)
                    && authorization.ToString().StartsWith("Bearer ", StringComparison.OrdinalIgnoreCase)
                        ? OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme
                        : IdentityConstants.ApplicationScheme;
            })
            .AddCookie(IdentityConstants.ApplicationScheme);

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
        Endpoints.AuthEndpoints.Map(endpoints);

        // MFA, session, and lifecycle endpoints land in T049-T054.
    }
}
