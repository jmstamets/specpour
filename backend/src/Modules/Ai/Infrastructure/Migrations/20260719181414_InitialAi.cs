using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SpecPour.Modules.Ai.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class InitialAi : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "ai");

            migrationBuilder.CreateTable(
                name: "PromptEvalResults",
                schema: "ai",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    PromptVersionId = table.Column<Guid>(type: "uuid", nullable: false),
                    EvaluatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    TotalCases = table.Column<int>(type: "integer", nullable: false),
                    CorrectCases = table.Column<int>(type: "integer", nullable: false),
                    Notes = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PromptEvalResults", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "PromptVersions",
                schema: "ai",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    FeatureKey = table.Column<string>(type: "text", nullable: false),
                    Version = table.Column<string>(type: "text", nullable: false),
                    Provider = table.Column<string>(type: "text", nullable: false),
                    Model = table.Column<string>(type: "text", nullable: false),
                    Enabled = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PromptVersions", x => x.Id);
                });

            migrationBuilder.InsertData(
                schema: "ai",
                table: "PromptVersions",
                columns: new[] { "Id", "CreatedAt", "Enabled", "FeatureKey", "Model", "Provider", "Version" },
                values: new object[] { new Guid("a0000000-0000-0000-0000-000000000001"), new DateTimeOffset(new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new TimeSpan(0, 0, 0, 0, 0)), true, "inventory.recognize", "none", "unconfigured", "v1" });

            migrationBuilder.CreateIndex(
                name: "IX_PromptEvalResults_PromptVersionId",
                schema: "ai",
                table: "PromptEvalResults",
                column: "PromptVersionId");

            migrationBuilder.CreateIndex(
                name: "IX_PromptVersions_FeatureKey_Version",
                schema: "ai",
                table: "PromptVersions",
                columns: new[] { "FeatureKey", "Version" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PromptEvalResults",
                schema: "ai");

            migrationBuilder.DropTable(
                name: "PromptVersions",
                schema: "ai");
        }
    }
}
