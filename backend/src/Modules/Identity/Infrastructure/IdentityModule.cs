using AspNet.Security.OAuth.Apple;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authentication.MicrosoftAccount;
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
using SpecPour.BuildingBlocks.Events;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Identity.Application.Lifecycle;
using SpecPour.Modules.Identity.Application.Ports;
using SpecPour.Modules.Identity.Infrastructure.ExternalProviders;
using SpecPour.Modules.Identity.Infrastructure.Lifecycle;
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

    /// <summary>
    /// T050: the interim cookie scheme LoginAsync signs into when a password check
    /// succeeds but MfaEnrollment gates full sign-in — carries only a "who is this"
    /// claim, never grants API access itself. POST /auth/login/mfa reads it, verifies
    /// a TOTP code, then signs the caller into IdentityConstants.ApplicationScheme
    /// (the real session) and signs this one out.
    /// </summary>
    public const string MfaPendingScheme = "SpecPour.MfaPending";

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
        services.AddScoped<IMfaSecretCipher, DataProtectionMfaSecretCipher>();
        services.AddScoped<Contracts.IAgePredicatePort, AgePredicateAdapter>();
        services.AddScoped<AccountDeletionService>();

        // FR-003: "operator-configurable grace period" — config-bound (falls back to
        // LifecycleOptions' in-class defaults, same style as SmtpEmailOptions).
        services.Configure<LifecycleOptions>(configuration.GetSection("Identity:Lifecycle"));
        services.AddHostedService<AccountLifecycleBackgroundService>();

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
        var authenticationBuilder = services.AddAuthentication(options =>
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
            .AddCookie(IdentityConstants.ApplicationScheme)
            // T050: short-lived, purpose-narrow cookie for the password-verified-but-
            // MFA-pending interim state (see MfaPendingScheme's own doc comment).
            .AddCookie(MfaPendingScheme, options => options.ExpireTimeSpan = TimeSpan.FromMinutes(5))
            // T049: ASP.NET Core Identity's own convention for the interim principal
            // between "provider redirected back" and "we decided what to do with this
            // identity" (SignInManager.GetExternalLoginInfoAsync reads it by hardcoded
            // scheme name, same as ApplicationScheme's convention above). AddIdentityCore
            // doesn't auto-register it the way the full AddIdentity() would.
            .AddCookie(IdentityConstants.ExternalScheme, options => options.ExpireTimeSpan = TimeSpan.FromMinutes(15));

        // T049: each provider is registered only if actually configured. Remote OAuth
        // handlers validate their options (non-empty ClientId) EAGERLY, on every
        // request — not just when challenged — because the auth middleware asks every
        // registered scheme whether the current path is its OAuth callback path.
        // Registering all three unconditionally with empty config would 500 every
        // single request in any environment (dev, CI, a self-hosted deploy) that
        // hasn't set up all three providers. A provider genuinely being absent is a
        // legitimate deployment choice, not a misconfiguration to paper over.
        if (!string.IsNullOrWhiteSpace(configuration["ExternalProviders:Google:ClientId"]))
        {
            authenticationBuilder.AddGoogle(options =>
            {
                configuration.GetSection("ExternalProviders:Google").Bind(options);
                options.SignInScheme = IdentityConstants.ExternalScheme;
            });
            services.AddSingleton<IExternalIdentityProviderPort, GoogleExternalIdentityProviderAdapter>();
        }

        if (!string.IsNullOrWhiteSpace(configuration["ExternalProviders:Microsoft:ClientId"]))
        {
            authenticationBuilder.AddMicrosoftAccount(options =>
            {
                configuration.GetSection("ExternalProviders:Microsoft").Bind(options);
                options.SignInScheme = IdentityConstants.ExternalScheme;
            });
            services.AddSingleton<IExternalIdentityProviderPort, MicrosoftExternalIdentityProviderAdapter>();
        }

        if (!string.IsNullOrWhiteSpace(configuration["ExternalProviders:Apple:ClientId"]))
        {
            authenticationBuilder.AddApple(options =>
            {
                configuration.GetSection("ExternalProviders:Apple").Bind(options);
                options.SignInScheme = IdentityConstants.ExternalScheme;
                // Apple's client secret is a JWT the caller signs with their private
                // key, not a static value (R6: let the library do this rather than
                // hand-rolling the signing) — TeamId/KeyId/PrivateKey configure it.
                options.GenerateClientSecret = true;
                var privateKeyPem = configuration["ExternalProviders:Apple:PrivateKey"] ?? string.Empty;
                options.PrivateKey = (_, _) => Task.FromResult<ReadOnlyMemory<char>>(privateKeyPem.AsMemory());
            });
            services.AddSingleton<IExternalIdentityProviderPort, AppleExternalIdentityProviderAdapter>();
        }

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

                // T051/T052 session-revocation gap (John's ruling, 2026-07-14): access
                // tokens here are self-contained/stateless (no reference-token DB check
                // per request), so TryRevokeAsync on a SessionDevice's authorization only
                // blocks future refresh grants — it cannot kill an already-issued access
                // token. OpenIddict's own default (1 hour) left too wide a live-token
                // window after a user believes they've revoked/deactivated. 10 minutes
                // bounds that exposure while keeping the stateless validation path (no
                // platform-wide per-request DB cost — rejected as the wrong tradeoff for
                // what's a low-severity window). True immediate invalidation for the
                // high-severity cases (deactivation, staff suspension, sign-out-everywhere)
                // is tracked separately as T166, launch-gated alongside T139.
                options.SetAccessTokenLifetime(TimeSpan.FromMinutes(10));

                // ADR-0005 (T177): rolling refresh tokens and sliding expiration are
                // BOTH already on by default in OpenIddict (DisableRollingRefreshTokens/
                // DisableSlidingRefreshTokenExpiration are opt-OUT flags, and neither is
                // called here) — every refresh already rotates the token and resets its
                // expiry window. What was never set is the lifetime itself, silently
                // inheriting OpenIddict's own internal default. Made explicit per John's
                // ruling that a session's lifetime must be a stated decision, not an
                // inherited one: 14 days of sliding inactivity (an actively-used session
                // never surprise-expires). The complementary 90-day ABSOLUTE cap
                // (regardless of activity) has no equivalent OpenIddict setting — sliding
                // expiration alone would let a session live forever — so it's enforced
                // separately in TokenEndpoints.HandleTokenAsync against SessionDevice.
                // CreatedAt.
                options.SetRefreshTokenLifetime(TimeSpan.FromDays(14));

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
        services.AddHostedService<IdentityEventRegistrationHostedService>();
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        TokenEndpoints.Map(endpoints);
        Endpoints.AuthEndpoints.Map(endpoints);
        Endpoints.MfaEndpoints.Map(endpoints);
        Endpoints.RecoveryEndpoints.Map(endpoints);
        Endpoints.ExternalAuthEndpoints.Map(endpoints);
        Endpoints.SessionsEndpoints.Map(endpoints);
        Endpoints.ExportEndpoints.Map(endpoints);
        Endpoints.LifecycleEndpoints.Map(endpoints);
    }
}

/// <summary>
/// Registers this module's outbox-producing event types with the process-wide
/// IEventTypeCatalog (same pattern/rationale as IngredientsEventRegistrationHostedService
/// — must be a hosted service, not inline RegisterServices code, so it runs after the
/// full DI container is built). Missing this meant AccountDeactivated/
/// DeactivationExpiryApproaching/AccountDeleted outbox rows were dispatched to zero
/// handlers forever (OutboxDispatcherBackgroundService.Log.UnknownEventType, message
/// left permanently pending) — found while writing T052's grace-period acceptance
/// scenario, whose warning-notification assertion never completed within its poll
/// window until this was added.
/// </summary>
public sealed class IdentityEventRegistrationHostedService(IEventTypeCatalog eventTypeCatalog)
    : Microsoft.Extensions.Hosting.IHostedService
{
    public Task StartAsync(CancellationToken cancellationToken)
    {
        eventTypeCatalog.Register<Contracts.Events.AccountDeactivated>();
        eventTypeCatalog.Register<Contracts.Events.DeactivationExpiryApproaching>();
        eventTypeCatalog.Register<Contracts.Events.AccountDeleted>();
        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
