using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace SpecPour.Modules.Authorization.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class InitialAuthorization : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "authz");

            migrationBuilder.CreateTable(
                name: "CapabilityGrants",
                schema: "authz",
                columns: table => new
                {
                    TierId = table.Column<Guid>(type: "uuid", nullable: false),
                    CapabilityKey = table.Column<string>(type: "text", nullable: false),
                    Granted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CapabilityGrants", x => new { x.TierId, x.CapabilityKey });
                });

            migrationBuilder.CreateTable(
                name: "PlatformRoles",
                schema: "authz",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    RoleKey = table.Column<string>(type: "text", nullable: false),
                    PermissionSet = table.Column<string>(type: "text", nullable: false),
                    Active = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PlatformRoles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "RoleGrants",
                schema: "authz",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    RoleId = table.Column<Guid>(type: "uuid", nullable: false),
                    ScopeType = table.Column<int>(type: "integer", nullable: false),
                    ScopeId = table.Column<Guid>(type: "uuid", nullable: true),
                    Permissions = table.Column<int>(type: "integer", nullable: false),
                    GrantedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    GrantedBy = table.Column<Guid>(type: "uuid", nullable: false),
                    ApprovalReference = table.Column<Guid>(type: "uuid", nullable: true),
                    RevokedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RoleGrants", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Tiers",
                schema: "authz",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Key = table.Column<string>(type: "text", nullable: false),
                    DisplayNameKey = table.Column<string>(type: "text", nullable: false),
                    Active = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tiers", x => x.Id);
                });

            migrationBuilder.InsertData(
                schema: "authz",
                table: "PlatformRoles",
                columns: new[] { "Id", "Active", "PermissionSet", "RoleKey" },
                values: new object[,]
                {
                    { new Guid("00000000-0000-0000-0000-000000000010"), true, "", "super_admin" },
                    { new Guid("00000000-0000-0000-0000-000000000011"), true, "", "curator" },
                    { new Guid("00000000-0000-0000-0000-000000000012"), true, "", "moderator" },
                    { new Guid("00000000-0000-0000-0000-000000000013"), true, "", "support" },
                    { new Guid("00000000-0000-0000-0000-000000000014"), false, "", "billing_admin" }
                });

            migrationBuilder.InsertData(
                schema: "authz",
                table: "Tiers",
                columns: new[] { "Id", "Active", "DisplayNameKey", "Key" },
                values: new object[,]
                {
                    { new Guid("00000000-0000-0000-0000-000000000001"), true, "tier.guest.displayName", "guest" },
                    { new Guid("00000000-0000-0000-0000-000000000002"), true, "tier.default.displayName", "default" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_PlatformRoles_RoleKey",
                schema: "authz",
                table: "PlatformRoles",
                column: "RoleKey",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_RoleGrants_UserId",
                schema: "authz",
                table: "RoleGrants",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Tiers_Key",
                schema: "authz",
                table: "Tiers",
                column: "Key",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CapabilityGrants",
                schema: "authz");

            migrationBuilder.DropTable(
                name: "PlatformRoles",
                schema: "authz");

            migrationBuilder.DropTable(
                name: "RoleGrants",
                schema: "authz");

            migrationBuilder.DropTable(
                name: "Tiers",
                schema: "authz");
        }
    }
}
