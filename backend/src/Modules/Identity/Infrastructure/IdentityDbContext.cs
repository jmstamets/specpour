using Microsoft.AspNetCore.DataProtection.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using OpenIddict.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;

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

    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.HasDefaultSchema(ModuleSchemas.Identity);

        base.OnModelCreating(builder);

        builder.ConfigureOutbox(ownsTable: false);

        // OpenIddict's application/authorization/scope/token tables (T017): token
        // issuance is identity's responsibility (R6), so these live alongside the
        // user store rather than in a separate schema/DbContext.
        builder.UseOpenIddict();
    }
}
