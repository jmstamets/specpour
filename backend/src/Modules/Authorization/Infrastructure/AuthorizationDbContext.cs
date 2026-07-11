using Microsoft.EntityFrameworkCore;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Modules;
using SpecPour.Modules.Authorization.Domain;
using SpecPour.Modules.Authorization.Domain.Audit;

namespace SpecPour.Modules.Authorization.Infrastructure;

/// <summary>The authorization module's DbContext (data-model.md "authz" schema, T018/T019/T079/T084).</summary>
public sealed class AuthorizationDbContext(DbContextOptions<AuthorizationDbContext> options) : DbContext(options)
{
    /// <summary>Fixed seed IDs (T018) — stable across environments since HasData rows must be deterministic.</summary>
    public static class SeedIds
    {
        public static readonly Guid GuestTier = new("00000000-0000-0000-0000-000000000001");
        public static readonly Guid DefaultTier = new("00000000-0000-0000-0000-000000000002");
        public static readonly Guid SuperAdminRole = new("00000000-0000-0000-0000-000000000010");
        public static readonly Guid CuratorRole = new("00000000-0000-0000-0000-000000000011");
        public static readonly Guid ModeratorRole = new("00000000-0000-0000-0000-000000000012");
        public static readonly Guid SupportRole = new("00000000-0000-0000-0000-000000000013");
        public static readonly Guid BillingAdminRole = new("00000000-0000-0000-0000-000000000014");
    }

    public DbSet<Tier> Tiers => Set<Tier>();
    public DbSet<CapabilityGrant> CapabilityGrants => Set<CapabilityGrant>();
    public DbSet<PlatformRole> PlatformRoles => Set<PlatformRole>();
    public DbSet<RoleGrant> RoleGrants => Set<RoleGrant>();
    public DbSet<AuditLogEntry> AuditLogEntries => Set<AuditLogEntry>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(ModuleSchemas.Authorization);

        modelBuilder.Entity<Tier>(entity =>
        {
            entity.HasKey(t => t.Id);
            entity.HasIndex(t => t.Key).IsUnique();

            // Guest is the configured pseudo-tier floor (FR-004b); "default" is V1's
            // single consumer tier — additional tiers land by adding rows (SC-011),
            // never a release.
            entity.HasData(
                new Tier { Id = SeedIds.GuestTier, Key = Domain.Tier.GuestKey, DisplayNameKey = "tier.guest.displayName", Active = true },
                new Tier { Id = SeedIds.DefaultTier, Key = Domain.Tier.DefaultKey, DisplayNameKey = "tier.default.displayName", Active = true });
        });

        modelBuilder.Entity<CapabilityGrant>(entity =>
        {
            entity.HasKey(c => new { c.TierId, c.CapabilityKey });
            // No rows seeded: capability keys are declared by the feature that checks
            // them (each story's endpoint tasks), not by this foundational module.
        });

        modelBuilder.Entity<PlatformRole>(entity =>
        {
            entity.HasKey(r => r.Id);
            entity.HasIndex(r => r.RoleKey).IsUnique();
            entity.Property(r => r.PermissionSet)
                .HasConversion(
                    v => string.Join(',', v),
                    v => v.Length == 0 ? Array.Empty<string>() : v.Split(',', StringSplitOptions.None))
                .Metadata.SetValueComparer(PermissionSetComparer);

            // R18a: the staff role catalog is configuration data present from day one;
            // Billing Admin is dormant until paid tiers exist. Permission sets here are
            // placeholders — each console task (T079-T084) declares the permission keys
            // it actually checks.
            entity.HasData(
                new PlatformRole { Id = SeedIds.SuperAdminRole, RoleKey = Domain.PlatformRole.Keys.SuperAdmin, PermissionSet = Array.Empty<string>(), Active = true },
                new PlatformRole { Id = SeedIds.CuratorRole, RoleKey = Domain.PlatformRole.Keys.Curator, PermissionSet = Array.Empty<string>(), Active = true },
                new PlatformRole { Id = SeedIds.ModeratorRole, RoleKey = Domain.PlatformRole.Keys.Moderator, PermissionSet = Array.Empty<string>(), Active = true },
                new PlatformRole { Id = SeedIds.SupportRole, RoleKey = Domain.PlatformRole.Keys.Support, PermissionSet = Array.Empty<string>(), Active = true },
                new PlatformRole { Id = SeedIds.BillingAdminRole, RoleKey = Domain.PlatformRole.Keys.BillingAdmin, PermissionSet = Array.Empty<string>(), Active = false });
        });

        modelBuilder.Entity<RoleGrant>(entity =>
        {
            entity.HasKey(g => g.Id);
            entity.HasIndex(g => g.UserId);
        });

        modelBuilder.Entity<AuditLogEntry>(entity =>
        {
            entity.HasKey(a => a.Id);
            entity.HasIndex(a => new { a.TargetEntityType, a.TargetEntityId });
            entity.HasIndex(a => a.OccurredAt);
            // No UPDATE/DELETE mapping is exposed anywhere in the application layer —
            // AuditWriter only ever Adds. True immutability (not just convention) is
            // enforced by BEFORE UPDATE/DELETE triggers added by hand in the
            // InitialAuditLog migration (T019) — see that migration's Up().
        });

        modelBuilder.ConfigureOutbox(ownsTable: false);
    }

    private static readonly Microsoft.EntityFrameworkCore.ChangeTracking.ValueComparer<IReadOnlyCollection<string>> PermissionSetComparer = new(
        (a, b) => (a ?? Array.Empty<string>()).SequenceEqual(b ?? Array.Empty<string>()),
        v => v.Aggregate(0, (hash, s) => HashCode.Combine(hash, s.GetHashCode(StringComparison.Ordinal))),
        v => v.ToArray());
}
