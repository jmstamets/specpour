using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SpecPour.Modules.Authorization.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class PermissionSetAsTextArray : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Postgres refuses an automatic text -> text[] cast (there's no sensible
            // implicit conversion), and every existing row is empty-string seed data
            // anyway (T018's placeholder PermissionSets), so drop and re-add rather
            // than ALTER COLUMN ... TYPE.
            migrationBuilder.DropColumn(
                name: "PermissionSet",
                schema: "authz",
                table: "PlatformRoles");

            migrationBuilder.AddColumn<string[]>(
                name: "PermissionSet",
                schema: "authz",
                table: "PlatformRoles",
                type: "text[]",
                nullable: false,
                defaultValue: new string[0]);

            migrationBuilder.UpdateData(
                schema: "authz",
                table: "PlatformRoles",
                keyColumn: "Id",
                keyValue: new Guid("00000000-0000-0000-0000-000000000010"),
                column: "PermissionSet",
                value: new string[0]);

            migrationBuilder.UpdateData(
                schema: "authz",
                table: "PlatformRoles",
                keyColumn: "Id",
                keyValue: new Guid("00000000-0000-0000-0000-000000000011"),
                column: "PermissionSet",
                value: new string[0]);

            migrationBuilder.UpdateData(
                schema: "authz",
                table: "PlatformRoles",
                keyColumn: "Id",
                keyValue: new Guid("00000000-0000-0000-0000-000000000012"),
                column: "PermissionSet",
                value: new string[0]);

            migrationBuilder.UpdateData(
                schema: "authz",
                table: "PlatformRoles",
                keyColumn: "Id",
                keyValue: new Guid("00000000-0000-0000-0000-000000000013"),
                column: "PermissionSet",
                value: new string[0]);

            migrationBuilder.UpdateData(
                schema: "authz",
                table: "PlatformRoles",
                keyColumn: "Id",
                keyValue: new Guid("00000000-0000-0000-0000-000000000014"),
                column: "PermissionSet",
                value: new string[0]);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PermissionSet",
                schema: "authz",
                table: "PlatformRoles");

            migrationBuilder.AddColumn<string>(
                name: "PermissionSet",
                schema: "authz",
                table: "PlatformRoles",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.UpdateData(
                schema: "authz",
                table: "PlatformRoles",
                keyColumn: "Id",
                keyValue: new Guid("00000000-0000-0000-0000-000000000010"),
                column: "PermissionSet",
                value: "");

            migrationBuilder.UpdateData(
                schema: "authz",
                table: "PlatformRoles",
                keyColumn: "Id",
                keyValue: new Guid("00000000-0000-0000-0000-000000000011"),
                column: "PermissionSet",
                value: "");

            migrationBuilder.UpdateData(
                schema: "authz",
                table: "PlatformRoles",
                keyColumn: "Id",
                keyValue: new Guid("00000000-0000-0000-0000-000000000012"),
                column: "PermissionSet",
                value: "");

            migrationBuilder.UpdateData(
                schema: "authz",
                table: "PlatformRoles",
                keyColumn: "Id",
                keyValue: new Guid("00000000-0000-0000-0000-000000000013"),
                column: "PermissionSet",
                value: "");

            migrationBuilder.UpdateData(
                schema: "authz",
                table: "PlatformRoles",
                keyColumn: "Id",
                keyValue: new Guid("00000000-0000-0000-0000-000000000014"),
                column: "PermissionSet",
                value: "");
        }
    }
}
