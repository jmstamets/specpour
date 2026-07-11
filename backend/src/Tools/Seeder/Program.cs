using System.Text.Json;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption;
using Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SpecPour.BuildingBlocks.Identifiers;
using SpecPour.Modules.Authorization.Contracts.Audit;
using SpecPour.Modules.Authorization.Domain;
using SpecPour.Modules.Authorization.Infrastructure;
using SpecPour.Modules.Authorization.Infrastructure.Audit;
using SpecPour.Modules.Identity.Application.Ports;
using SpecPour.Modules.Identity.Infrastructure;
using SpecPour.Tools.Seeder;

// Curated launch-content ingestion pipeline (2nd deliverable) and first-Super-Admin
// bootstrap (3rd deliverable). Convention-table seeding (1st deliverable) already
// happens via MigrationRunner (T024's ConventionTable HasData) — reference/config
// data present from the moment the schema exists, not a separate Seeder step.

var configuration = new ConfigurationBuilder()
    .AddJsonFile("appsettings.json", optional: true)
    .AddEnvironmentVariables()
    .Build();

var connectionString = configuration.GetConnectionString("Postgres")
    ?? Environment.GetEnvironmentVariable("ConnectionStrings__Postgres")
    ?? throw new InvalidOperationException(
        "No Postgres connection string configured (ConnectionStrings:Postgres / ConnectionStrings__Postgres).");

Console.WriteLine("SpecPour Seeder");

var services = new ServiceCollection();
services.AddDbContext<IdentityDbContext>(o => o.UseNpgsql(connectionString));
services.AddDbContext<AuthorizationDbContext>(o => o.UseNpgsql(connectionString));
// Must match IdentityModule.RegisterServices exactly (same application name, same
// AES-256-GCM algorithm): whichever process happens to create the first key in the
// shared identity.DataProtectionKeys ring bakes its algorithm into that key
// permanently, so a mismatch here would silently downgrade real encryptions to the
// Data Protection default (AES-256-CBC+HMACSHA256) if the Seeder ever runs first.
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
        options.Password.RequiredLength = 12;
    })
    .AddEntityFrameworkStores<IdentityDbContext>();
services.AddScoped<IAuditWriter, AuditWriter>();
services.AddSingleton<IUuidGenerator, UuidV7Generator>();

await using var provider = services.BuildServiceProvider();
await using (var scope = provider.CreateAsyncScope())
{
    await BootstrapSuperAdminAsync(scope.ServiceProvider, configuration);
}

Console.WriteLine("Curated launch-content ingestion: no importers registered yet (T040 adds the first once Catalog/Ingredients/Equipment/Glossary exist).");
IContentImporter[] contentImporters = [];
var contentDirectory = Path.Combine(AppContext.BaseDirectory, "Content");
foreach (var importer in contentImporters)
{
    Console.WriteLine($"Importing {importer.ContentType}...");
    await importer.ImportAsync(contentDirectory, CancellationToken.None);
}

Console.WriteLine("Seeder complete.");

static async Task BootstrapSuperAdminAsync(IServiceProvider services, IConfiguration configuration)
{
    var email = configuration["Seeder:SuperAdmin:Email"] ?? Environment.GetEnvironmentVariable("SUPERADMIN_EMAIL");
    var password = configuration["Seeder:SuperAdmin:Password"] ?? Environment.GetEnvironmentVariable("SUPERADMIN_PASSWORD");
    var dateOfBirthRaw = configuration["Seeder:SuperAdmin:DateOfBirth"] ?? Environment.GetEnvironmentVariable("SUPERADMIN_DATE_OF_BIRTH");

    if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password) || string.IsNullOrWhiteSpace(dateOfBirthRaw))
    {
        Console.WriteLine("Super Admin bootstrap skipped: SUPERADMIN_EMAIL / SUPERADMIN_PASSWORD / SUPERADMIN_DATE_OF_BIRTH not fully configured.");
        return;
    }

    var userManager = services.GetRequiredService<UserManager<ApplicationUser>>();

    if (await userManager.FindByEmailAsync(email) is not null)
    {
        Console.WriteLine("Super Admin bootstrap skipped: an account with that email already exists.");
        return;
    }

    var cipher = services.GetRequiredService<IDateOfBirthCipher>();
    var uuidGenerator = services.GetRequiredService<IUuidGenerator>();
    var authzDb = services.GetRequiredService<AuthorizationDbContext>();
    var auditWriter = services.GetRequiredService<IAuditWriter>();

    var user = new ApplicationUser
    {
        Id = uuidGenerator.NewId(),
        UserName = email,
        Email = email,
        EmailConfirmed = true, // Deployment-time bootstrap: no email-confirmation flow to run yet.
        DisplayName = "Super Admin",
        EncryptedDateOfBirth = cipher.Encrypt(DateOnly.Parse(dateOfBirthRaw, System.Globalization.CultureInfo.InvariantCulture)),
        Locale = "en-US",
        CreatedAt = DateTimeOffset.UtcNow,
    };

    var createResult = await userManager.CreateAsync(user, password);
    if (!createResult.Succeeded)
    {
        throw new InvalidOperationException(
            $"Failed to create Super Admin account: {string.Join("; ", createResult.Errors.Select(e => e.Description))}");
    }

    var superAdminRole = await authzDb.PlatformRoles.SingleAsync(r => r.RoleKey == PlatformRole.Keys.SuperAdmin);

    // Self-granted: there is no other actor at deployment time. Platform-scope
    // grants normally require Super Admin approval (FR-062) — this is the one
    // exception, since it's how the first Super Admin comes to exist at all.
    authzDb.RoleGrants.Add(new RoleGrant
    {
        Id = uuidGenerator.NewId(),
        UserId = user.Id,
        RoleId = superAdminRole.Id,
        ScopeType = RoleGrantScopeType.Platform,
        ScopeId = null,
        Permissions = RoleGrantPermissions.View | RoleGrantPermissions.Edit | RoleGrantPermissions.Delete | RoleGrantPermissions.Publish,
        GrantedAt = DateTimeOffset.UtcNow,
        GrantedBy = user.Id,
        ApprovalReference = null,
    });
    await authzDb.SaveChangesAsync(CancellationToken.None);

    await auditWriter.WriteAsync(
        new AuditEntry(
            user.Id,
            "platform_bootstrap.super_admin_created",
            "User",
            user.Id,
            BeforeStateJson: null,
            AfterStateJson: JsonSerializer.Serialize(new { email, roleKey = PlatformRole.Keys.SuperAdmin })),
        CancellationToken.None);

    Console.WriteLine($"Super Admin bootstrapped: {email}");
}
