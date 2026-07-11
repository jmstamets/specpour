using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SpecPour.Modules.Compliance.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class InitialCompliance : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "compliance");

            migrationBuilder.CreateTable(
                name: "JurisdictionRules",
                schema: "compliance",
                columns: table => new
                {
                    JurisdictionCode = table.Column<string>(type: "text", nullable: false),
                    LegalDrinkingAge = table.Column<int>(type: "integer", nullable: false),
                    Source = table.Column<string>(type: "text", nullable: false),
                    EffectiveAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_JurisdictionRules", x => x.JurisdictionCode);
                });

            migrationBuilder.CreateTable(
                name: "SurfaceGateConfigs",
                schema: "compliance",
                columns: table => new
                {
                    SurfaceKey = table.Column<string>(type: "text", nullable: false),
                    Strictness = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SurfaceGateConfigs", x => x.SurfaceKey);
                });

            migrationBuilder.InsertData(
                schema: "compliance",
                table: "JurisdictionRules",
                columns: new[] { "JurisdictionCode", "EffectiveAt", "LegalDrinkingAge", "Source" },
                values: new object[] { "default", new DateTimeOffset(new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new TimeSpan(0, 0, 0, 0, 0)), 21, "Operator-configured strictest-rule default pending per-jurisdiction legal review" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "JurisdictionRules",
                schema: "compliance");

            migrationBuilder.DropTable(
                name: "SurfaceGateConfigs",
                schema: "compliance");
        }
    }
}
