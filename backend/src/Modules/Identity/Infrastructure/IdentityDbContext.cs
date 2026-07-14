using Microsoft.AspNetCore.DataProtection.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using OpenIddict.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Identity.Domain;

namespace SpecPour.Modules.Identity.Infrastructure;

/// <summary>
/// The identity module's DbContext (data-model.md "identity" schema). Uses
/// <see cref="IdentityUserContext{TUser,TKey}"/> rather than the roles-inclusive
/// <c>IdentityDbContext</c> base — platform roles are a first-class Authorization-module
/// concept (T018's PlatformRole/RoleGrant), not ASP.NET Core Identity roles, so the
/// AspNetRoles/AspNetUserRoles tables would be dead weight here. Also hosts this
/// module's dedicated Data Protection key ring (R6a) and, from T017 onward, OpenIddict's
/// application/authorization/scope/token tables — all module-private infrastructure
/// that has no reason to live in a separate schema or DbContext.
/// </summary>
public sealed class IdentityDbContext(DbContextOptions<IdentityDbContext> options)
    : IdentityUserContext<ApplicationUser, Guid>(options), IDataProtectionKeyContext
{
    public DbSet<DataProtectionKey> DataProtectionKeys => Set<DataProtectionKey>();

    public DbSet<MfaEnrollment> MfaEnrollments => Set<MfaEnrollment>();

    public DbSet<MfaBackupCode> MfaBackupCodes => Set<MfaBackupCode>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.HasDefaultSchema(ModuleSchemas.Identity);

        base.OnModelCreating(builder);

        builder.Entity<MfaEnrollment>(entity =>
        {
            entity.HasKey(m => m.Id);
            // One enrollment per user in V1 (single "totp" method) — a fresh POST
            // /me/mfa replaces the prior row rather than accumulating history.
            entity.HasIndex(m => m.UserId).IsUnique();
        });

        builder.Entity<MfaBackupCode>(entity =>
        {
            entity.HasKey(c => c.Id);
            // Not unique — a user has up to BackupCodeGenerator.CodeCount live rows
            // at once (T163). UsedAt filters an unused set at query time.
            entity.HasIndex(c => c.UserId);
        });

        builder.ConfigureOutbox(ownsTable: false);

        // OpenIddict's application/authorization/scope/token tables (T017): token
        // issuance is identity's responsibility (R6), so these live alongside the
        // user store rather than in a separate schema/DbContext.
        builder.UseOpenIddict();
    }
}
