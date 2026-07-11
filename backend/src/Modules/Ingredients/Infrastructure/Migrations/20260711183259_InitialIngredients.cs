using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NpgsqlTypes;
using SpecPour.BuildingBlocks.Search;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace SpecPour.Modules.Ingredients.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class InitialIngredients : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "ingredients");

            // Must exist before the Ingredients table's SearchVector generated
            // column (below) references it — idempotent (CREATE OR REPLACE), so
            // harmless if Catalog's migration already created it.
            migrationBuilder.EnsureImmutableToTsVectorFunction();

            migrationBuilder.CreateTable(
                name: "Allergens",
                schema: "ingredients",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Key = table.Column<string>(type: "text", nullable: false),
                    DisplayNameKey = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Allergens", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "IngredientCategories",
                schema: "ingredients",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    NameKey = table.Column<string>(type: "text", nullable: false),
                    Definition = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_IngredientCategories", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Ingredients",
                schema: "ingredients",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    OwnerType = table.Column<int>(type: "integer", nullable: false),
                    OwnerId = table.Column<Guid>(type: "uuid", nullable: true),
                    LibraryScope = table.Column<int>(type: "integer", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    CategoryId = table.Column<Guid>(type: "uuid", nullable: false),
                    ParentId = table.Column<Guid>(type: "uuid", nullable: true),
                    Sources = table.Column<string[]>(type: "text[]", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: true),
                    Visibility = table.Column<int>(type: "integer", nullable: false),
                    DefiningRecipeId = table.Column<Guid>(type: "uuid", nullable: true),
                    YieldQuantity = table.Column<decimal>(type: "numeric", nullable: true),
                    YieldUnit = table.Column<string>(type: "text", nullable: true),
                    ShelfLife = table.Column<TimeSpan>(type: "interval", nullable: true),
                    StorageInstructions = table.Column<string>(type: "text", nullable: true),
                    SearchVector = table.Column<NpgsqlTsVector>(type: "tsvector", nullable: true, computedColumnSql: "specpour_immutable_to_tsvector_english(coalesce(\"Name\", ''))", stored: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Ingredients", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Ingredients_IngredientCategories_CategoryId",
                        column: x => x.CategoryId,
                        principalSchema: "ingredients",
                        principalTable: "IngredientCategories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Ingredients_Ingredients_ParentId",
                        column: x => x.ParentId,
                        principalSchema: "ingredients",
                        principalTable: "Ingredients",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "IngredientAllergens",
                schema: "ingredients",
                columns: table => new
                {
                    IngredientId = table.Column<Guid>(type: "uuid", nullable: false),
                    AllergenId = table.Column<Guid>(type: "uuid", nullable: false),
                    Certainty = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_IngredientAllergens", x => new { x.IngredientId, x.AllergenId });
                    table.ForeignKey(
                        name: "FK_IngredientAllergens_Allergens_AllergenId",
                        column: x => x.AllergenId,
                        principalSchema: "ingredients",
                        principalTable: "Allergens",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_IngredientAllergens_Ingredients_IngredientId",
                        column: x => x.IngredientId,
                        principalSchema: "ingredients",
                        principalTable: "Ingredients",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "SubstitutionRules",
                schema: "ingredients",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    FromIngredientId = table.Column<Guid>(type: "uuid", nullable: false),
                    ToIngredientId = table.Column<Guid>(type: "uuid", nullable: false),
                    SuitabilityNote = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SubstitutionRules", x => x.Id);
                    table.ForeignKey(
                        name: "FK_SubstitutionRules_Ingredients_FromIngredientId",
                        column: x => x.FromIngredientId,
                        principalSchema: "ingredients",
                        principalTable: "Ingredients",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_SubstitutionRules_Ingredients_ToIngredientId",
                        column: x => x.ToIngredientId,
                        principalSchema: "ingredients",
                        principalTable: "Ingredients",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.InsertData(
                schema: "ingredients",
                table: "Allergens",
                columns: new[] { "Id", "DisplayNameKey", "Key" },
                values: new object[,]
                {
                    { new Guid("00000000-0000-0000-0000-000000000201"), "allergen.egg", "egg" },
                    { new Guid("00000000-0000-0000-0000-000000000202"), "allergen.dairy", "dairy" },
                    { new Guid("00000000-0000-0000-0000-000000000203"), "allergen.treeNut", "treeNut" },
                    { new Guid("00000000-0000-0000-0000-000000000204"), "allergen.peanut", "peanut" },
                    { new Guid("00000000-0000-0000-0000-000000000205"), "allergen.gluten", "gluten" },
                    { new Guid("00000000-0000-0000-0000-000000000206"), "allergen.sulfites", "sulfites" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Allergens_Key",
                schema: "ingredients",
                table: "Allergens",
                column: "Key",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_IngredientAllergens_AllergenId",
                schema: "ingredients",
                table: "IngredientAllergens",
                column: "AllergenId");

            migrationBuilder.CreateIndex(
                name: "IX_IngredientCategories_NameKey",
                schema: "ingredients",
                table: "IngredientCategories",
                column: "NameKey",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Ingredients_CategoryId",
                schema: "ingredients",
                table: "Ingredients",
                column: "CategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_Ingredients_Name",
                schema: "ingredients",
                table: "Ingredients",
                column: "Name");

            migrationBuilder.CreateIndex(
                name: "IX_Ingredients_OwnerId",
                schema: "ingredients",
                table: "Ingredients",
                column: "OwnerId");

            migrationBuilder.CreateIndex(
                name: "IX_Ingredients_ParentId",
                schema: "ingredients",
                table: "Ingredients",
                column: "ParentId");

            migrationBuilder.CreateIndex(
                name: "IX_SubstitutionRules_FromIngredientId_ToIngredientId",
                schema: "ingredients",
                table: "SubstitutionRules",
                columns: new[] { "FromIngredientId", "ToIngredientId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_SubstitutionRules_ToIngredientId",
                schema: "ingredients",
                table: "SubstitutionRules",
                column: "ToIngredientId");

            // GIN index over the generated SearchVector column (FR-049), plus a
            // trigram index on Name for fuzzy name matching.
            migrationBuilder.Sql("""CREATE INDEX "IX_Ingredients_SearchVector" ON ingredients."Ingredients" USING GIN ("SearchVector");""");
            migrationBuilder.AddTrigramIndex("ingredients", "Ingredients", "Name");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "IngredientAllergens",
                schema: "ingredients");

            migrationBuilder.DropTable(
                name: "SubstitutionRules",
                schema: "ingredients");

            migrationBuilder.DropTable(
                name: "Allergens",
                schema: "ingredients");

            migrationBuilder.DropTable(
                name: "Ingredients",
                schema: "ingredients");

            migrationBuilder.DropTable(
                name: "IngredientCategories",
                schema: "ingredients");
        }
    }
}
