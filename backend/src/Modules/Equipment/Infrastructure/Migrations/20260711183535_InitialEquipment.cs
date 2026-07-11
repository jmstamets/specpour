using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NpgsqlTypes;
using SpecPour.BuildingBlocks.Search;

#nullable disable

namespace SpecPour.Modules.Equipment.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class InitialEquipment : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "equipment");

            // Must exist before the Equipment table's SearchVector generated column
            // (below) references it — idempotent, harmless if another module's
            // migration already created it.
            migrationBuilder.EnsureImmutableToTsVectorFunction();

            migrationBuilder.CreateTable(
                name: "Equipment",
                schema: "equipment",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    OwnerType = table.Column<int>(type: "integer", nullable: false),
                    OwnerId = table.Column<Guid>(type: "uuid", nullable: true),
                    LibraryScope = table.Column<int>(type: "integer", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Category = table.Column<string>(type: "text", nullable: false),
                    Cost = table.Column<decimal>(type: "numeric", nullable: true),
                    Description = table.Column<string>(type: "text", nullable: true),
                    UsageGuidance = table.Column<string>(type: "text", nullable: true),
                    TypicalApplications = table.Column<string[]>(type: "text[]", nullable: false),
                    Visibility = table.Column<int>(type: "integer", nullable: false),
                    SearchVector = table.Column<NpgsqlTsVector>(type: "tsvector", nullable: true, computedColumnSql: "specpour_immutable_to_tsvector_english(coalesce(\"Name\", ''))", stored: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Equipment", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Equipment_Name",
                schema: "equipment",
                table: "Equipment",
                column: "Name");

            migrationBuilder.CreateIndex(
                name: "IX_Equipment_OwnerId",
                schema: "equipment",
                table: "Equipment",
                column: "OwnerId");

            // GIN index over the generated SearchVector column (FR-049), plus a
            // trigram index on Name for fuzzy name matching.
            migrationBuilder.Sql("""CREATE INDEX "IX_Equipment_SearchVector" ON equipment."Equipment" USING GIN ("SearchVector");""");
            migrationBuilder.AddTrigramIndex("equipment", "Equipment", "Name");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Equipment",
                schema: "equipment");
        }
    }
}
