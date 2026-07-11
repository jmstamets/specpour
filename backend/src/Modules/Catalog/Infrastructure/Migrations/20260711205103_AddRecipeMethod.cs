using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SpecPour.Modules.Catalog.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddRecipeMethod : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "Method",
                schema: "catalog",
                table: "Recipes",
                type: "integer",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Method",
                schema: "catalog",
                table: "Recipes");
        }
    }
}
