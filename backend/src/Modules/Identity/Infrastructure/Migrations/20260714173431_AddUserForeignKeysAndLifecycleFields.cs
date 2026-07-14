using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SpecPour.Modules.Identity.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddUserForeignKeysAndLifecycleFields : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTimeOffset>(
                name: "DeactivatedAt",
                schema: "identity",
                table: "AspNetUsers",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<DateTimeOffset>(
                name: "DeactivationWarningSentAt",
                schema: "identity",
                table: "AspNetUsers",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_MfaBackupCodes_AspNetUsers_UserId",
                schema: "identity",
                table: "MfaBackupCodes",
                column: "UserId",
                principalSchema: "identity",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_MfaEnrollments_AspNetUsers_UserId",
                schema: "identity",
                table: "MfaEnrollments",
                column: "UserId",
                principalSchema: "identity",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_SessionDevices_AspNetUsers_UserId",
                schema: "identity",
                table: "SessionDevices",
                column: "UserId",
                principalSchema: "identity",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_MfaBackupCodes_AspNetUsers_UserId",
                schema: "identity",
                table: "MfaBackupCodes");

            migrationBuilder.DropForeignKey(
                name: "FK_MfaEnrollments_AspNetUsers_UserId",
                schema: "identity",
                table: "MfaEnrollments");

            migrationBuilder.DropForeignKey(
                name: "FK_SessionDevices_AspNetUsers_UserId",
                schema: "identity",
                table: "SessionDevices");

            migrationBuilder.DropColumn(
                name: "DeactivatedAt",
                schema: "identity",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "DeactivationWarningSentAt",
                schema: "identity",
                table: "AspNetUsers");
        }
    }
}
