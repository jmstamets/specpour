using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SpecPour.Modules.Ingredients.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddUncategorizedCategorySeed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                schema: "ingredients",
                table: "IngredientCategories",
                columns: new[] { "Id", "Definition", "NameKey" },
                values: new object[] { new Guid("00000000-0000-0000-0000-000000000207"), "Fallback category for personal-library ingredients created without an explicit category.", "category.uncategorized" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                schema: "ingredients",
                table: "IngredientCategories",
                keyColumn: "Id",
                keyValue: new Guid("00000000-0000-0000-0000-000000000207"));
        }
    }
}
