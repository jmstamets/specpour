using Microsoft.EntityFrameworkCore.Migrations;
using NpgsqlTypes;

#nullable disable

namespace SpecPour.Modules.Catalog.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddRecipeSearchDocument : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "SearchDocumentText",
                schema: "catalog",
                table: "Recipes",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AlterColumn<NpgsqlTsVector>(
                name: "SearchVector",
                schema: "catalog",
                table: "Recipes",
                type: "tsvector",
                nullable: true,
                computedColumnSql: "specpour_immutable_to_tsvector_english(coalesce(\"SearchDocumentText\", ''))",
                stored: true,
                oldClrType: typeof(NpgsqlTsVector),
                oldType: "tsvector",
                oldNullable: true,
                oldComputedColumnSql: "specpour_immutable_to_tsvector_english(coalesce(\"PrimaryName\", '') || ' ' || coalesce(specpour_immutable_array_to_string(\"AlternateNames\", ' '), ''))",
                oldStored: true);

            // Npgsql's migration generator translates the AlterColumn above into a
            // DROP COLUMN + ADD COLUMN under the hood (Postgres has no ALTER for a
            // generated column's expression) — confirmed via `dotnet ef migrations
            // script`. Dropping SearchVector cascades to drop its GIN index too
            // (Postgres auto-drops dependent indexes), so it must be recreated here,
            // same as InitialCatalog's original raw-SQL index creation.
            migrationBuilder.Sql("""CREATE INDEX "IX_Recipes_SearchVector" ON catalog."Recipes" USING GIN ("SearchVector");""");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "SearchDocumentText",
                schema: "catalog",
                table: "Recipes");

            migrationBuilder.AlterColumn<NpgsqlTsVector>(
                name: "SearchVector",
                schema: "catalog",
                table: "Recipes",
                type: "tsvector",
                nullable: true,
                computedColumnSql: "specpour_immutable_to_tsvector_english(coalesce(\"PrimaryName\", '') || ' ' || coalesce(specpour_immutable_array_to_string(\"AlternateNames\", ' '), ''))",
                stored: true,
                oldClrType: typeof(NpgsqlTsVector),
                oldType: "tsvector",
                oldNullable: true,
                oldComputedColumnSql: "specpour_immutable_to_tsvector_english(coalesce(\"SearchDocumentText\", ''))",
                oldStored: true);

            migrationBuilder.Sql("""CREATE INDEX "IX_Recipes_SearchVector" ON catalog."Recipes" USING GIN ("SearchVector");""");
        }
    }
}
