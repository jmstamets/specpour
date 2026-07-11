using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace SpecPour.Modules.Measurements.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class InitialMeasurements : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "measurements");

            migrationBuilder.CreateTable(
                name: "ConventionTables",
                schema: "measurements",
                columns: table => new
                {
                    Version = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    EffectiveAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    Effective = table.Column<bool>(type: "boolean", nullable: false),
                    Notes = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ConventionTables", x => x.Version);
                });

            migrationBuilder.CreateTable(
                name: "MethodDilutions",
                schema: "measurements",
                columns: table => new
                {
                    ConventionTableVersion = table.Column<int>(type: "integer", nullable: false),
                    MethodKey = table.Column<string>(type: "text", nullable: false),
                    DilutionPercentage = table.Column<decimal>(type: "numeric", nullable: false),
                    MinPercentage = table.Column<decimal>(type: "numeric", nullable: true),
                    MaxPercentage = table.Column<decimal>(type: "numeric", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MethodDilutions", x => new { x.ConventionTableVersion, x.MethodKey });
                });

            migrationBuilder.CreateTable(
                name: "StandardDrinkGramValues",
                schema: "measurements",
                columns: table => new
                {
                    ConventionTableVersion = table.Column<int>(type: "integer", nullable: false),
                    JurisdictionCode = table.Column<string>(type: "text", nullable: false),
                    GramsPerStandardDrink = table.Column<decimal>(type: "numeric", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StandardDrinkGramValues", x => new { x.ConventionTableVersion, x.JurisdictionCode });
                });

            migrationBuilder.CreateTable(
                name: "UnitEquivalences",
                schema: "measurements",
                columns: table => new
                {
                    ConventionTableVersion = table.Column<int>(type: "integer", nullable: false),
                    UnitKey = table.Column<string>(type: "text", nullable: false),
                    MilliliterValue = table.Column<decimal>(type: "numeric", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UnitEquivalences", x => new { x.ConventionTableVersion, x.UnitKey });
                });

            migrationBuilder.InsertData(
                schema: "measurements",
                table: "ConventionTables",
                columns: new[] { "Version", "Effective", "EffectiveAt", "Notes" },
                values: new object[] { 1, true, new DateTimeOffset(new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new TimeSpan(0, 0, 0, 0, 0)), "R14 seed values: dash/barspoon ml equivalences, stirred/shaken/built dilution midpoints, default standard-drink grams. Curator-adjustable via a new version row." });

            migrationBuilder.InsertData(
                schema: "measurements",
                table: "MethodDilutions",
                columns: new[] { "ConventionTableVersion", "MethodKey", "DilutionPercentage", "MaxPercentage", "MinPercentage" },
                values: new object[,]
                {
                    { 1, "built", 0m, 0m, 0m },
                    { 1, "shaken", 0.275m, 0.30m, 0.25m },
                    { 1, "stirred", 0.225m, 0.25m, 0.20m }
                });

            migrationBuilder.InsertData(
                schema: "measurements",
                table: "StandardDrinkGramValues",
                columns: new[] { "ConventionTableVersion", "JurisdictionCode", "GramsPerStandardDrink" },
                values: new object[] { 1, "default", 14m });

            migrationBuilder.InsertData(
                schema: "measurements",
                table: "UnitEquivalences",
                columns: new[] { "ConventionTableVersion", "UnitKey", "MilliliterValue" },
                values: new object[,]
                {
                    { 1, "barspoon", 5m },
                    { 1, "dash", 0.92m }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ConventionTables",
                schema: "measurements");

            migrationBuilder.DropTable(
                name: "MethodDilutions",
                schema: "measurements");

            migrationBuilder.DropTable(
                name: "StandardDrinkGramValues",
                schema: "measurements");

            migrationBuilder.DropTable(
                name: "UnitEquivalences",
                schema: "measurements");
        }
    }
}
