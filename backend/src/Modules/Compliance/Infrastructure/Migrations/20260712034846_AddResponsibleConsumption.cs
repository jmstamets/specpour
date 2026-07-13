using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace SpecPour.Modules.Compliance.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddResponsibleConsumption : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "ResponsibleConsumptionMessages",
                schema: "compliance",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    JurisdictionCode = table.Column<string>(type: "text", nullable: false),
                    SurfaceClass = table.Column<string>(type: "text", nullable: false),
                    PlacementDescriptor = table.Column<string>(type: "text", nullable: false),
                    MessageContentKey = table.Column<string>(type: "text", nullable: false),
                    EffectiveAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ResponsibleConsumptionMessages", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "SupportResources",
                schema: "compliance",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    JurisdictionCode = table.Column<string>(type: "text", nullable: false),
                    ResourceName = table.Column<string>(type: "text", nullable: false),
                    Link = table.Column<string>(type: "text", nullable: false),
                    DisplayOrder = table.Column<int>(type: "integer", nullable: false),
                    EffectiveAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SupportResources", x => x.Id);
                });

            migrationBuilder.InsertData(
                schema: "compliance",
                table: "ResponsibleConsumptionMessages",
                columns: new[] { "Id", "EffectiveAt", "JurisdictionCode", "MessageContentKey", "PlacementDescriptor", "SurfaceClass" },
                values: new object[,]
                {
                    { new Guid("00000000-0000-0000-0000-000000000401"), new DateTimeOffset(new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new TimeSpan(0, 0, 0, 0, 0)), "default", "responsibleUse.message.default", "below-content", "recipe" },
                    { new Guid("00000000-0000-0000-0000-000000000402"), new DateTimeOffset(new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new TimeSpan(0, 0, 0, 0, 0)), "default", "responsibleUse.message.default", "below-content", "batch_output" },
                    { new Guid("00000000-0000-0000-0000-000000000403"), new DateTimeOffset(new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new TimeSpan(0, 0, 0, 0, 0)), "default", "responsibleUse.message.default", "footer", "footer_about" }
                });

            migrationBuilder.InsertData(
                schema: "compliance",
                table: "SupportResources",
                columns: new[] { "Id", "DisplayOrder", "EffectiveAt", "JurisdictionCode", "Link", "ResourceName" },
                values: new object[] { new Guid("00000000-0000-0000-0000-000000000411"), 1, new DateTimeOffset(new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new TimeSpan(0, 0, 0, 0, 0)), "default", "https://www.who.int/health-topics/alcohol", "International drug and alcohol support directory" });

            migrationBuilder.CreateIndex(
                name: "IX_ResponsibleConsumptionMessages_JurisdictionCode_SurfaceClass",
                schema: "compliance",
                table: "ResponsibleConsumptionMessages",
                columns: new[] { "JurisdictionCode", "SurfaceClass" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_SupportResources_JurisdictionCode_DisplayOrder",
                schema: "compliance",
                table: "SupportResources",
                columns: new[] { "JurisdictionCode", "DisplayOrder" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ResponsibleConsumptionMessages",
                schema: "compliance");

            migrationBuilder.DropTable(
                name: "SupportResources",
                schema: "compliance");
        }
    }
}
