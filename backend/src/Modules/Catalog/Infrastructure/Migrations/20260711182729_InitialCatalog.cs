using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NpgsqlTypes;
using SpecPour.BuildingBlocks.Search;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace SpecPour.Modules.Catalog.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class InitialCatalog : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "catalog");

            // Must exist before the Recipes table's SearchVector generated column
            // (below) references it — see EnsureImmutableToTsVectorFunction's remarks.
            migrationBuilder.EnsureImmutableToTsVectorFunction();

            migrationBuilder.CreateTable(
                name: "Categories",
                schema: "catalog",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    NameKey = table.Column<string>(type: "text", nullable: false),
                    Definition = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Categories", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ConceptPages",
                schema: "catalog",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ConceptPages", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Families",
                schema: "catalog",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    NameKey = table.Column<string>(type: "text", nullable: false),
                    Definition = table.Column<string>(type: "text", nullable: false),
                    ParentFamilyId = table.Column<Guid>(type: "uuid", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Families", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Families_Families_ParentFamilyId",
                        column: x => x.ParentFamilyId,
                        principalSchema: "catalog",
                        principalTable: "Families",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "FlavorProfiles",
                schema: "catalog",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    NameKey = table.Column<string>(type: "text", nullable: false),
                    Definition = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FlavorProfiles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Recipes",
                schema: "catalog",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    OwnerType = table.Column<int>(type: "integer", nullable: false),
                    OwnerId = table.Column<Guid>(type: "uuid", nullable: true),
                    LibraryScope = table.Column<int>(type: "integer", nullable: false),
                    PrimaryName = table.Column<string>(type: "text", nullable: false),
                    AlternateNames = table.Column<string[]>(type: "text[]", nullable: false),
                    FamilyId = table.Column<Guid>(type: "uuid", nullable: true),
                    Instructions = table.Column<string[]>(type: "text[]", nullable: false),
                    Garnishes = table.Column<string[]>(type: "text[]", nullable: false),
                    IceSpec = table.Column<string>(type: "text", nullable: false),
                    CreatorAttribution = table.Column<string>(type: "text", nullable: true),
                    History = table.Column<string>(type: "text", nullable: true),
                    Notes = table.Column<string>(type: "text", nullable: true),
                    Visibility = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    SearchVector = table.Column<NpgsqlTsVector>(type: "tsvector", nullable: true, computedColumnSql: "specpour_immutable_to_tsvector_english(coalesce(\"PrimaryName\", '') || ' ' || coalesce(specpour_immutable_array_to_string(\"AlternateNames\", ' '), ''))", stored: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Recipes", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Tags",
                schema: "catalog",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Key = table.Column<string>(type: "text", nullable: false),
                    DisplayText = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tags", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ConceptVariantLinks",
                schema: "catalog",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    ConceptId = table.Column<Guid>(type: "uuid", nullable: false),
                    RecipeId = table.Column<Guid>(type: "uuid", nullable: false),
                    DifferentiatorText = table.Column<string>(type: "text", nullable: false),
                    State = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ConceptVariantLinks", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ConceptVariantLinks_ConceptPages_ConceptId",
                        column: x => x.ConceptId,
                        principalSchema: "catalog",
                        principalTable: "ConceptPages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ConceptVariantLinks_Recipes_RecipeId",
                        column: x => x.RecipeId,
                        principalSchema: "catalog",
                        principalTable: "Recipes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "RecipeCategories",
                schema: "catalog",
                columns: table => new
                {
                    RecipeId = table.Column<Guid>(type: "uuid", nullable: false),
                    CategoryId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RecipeCategories", x => new { x.RecipeId, x.CategoryId });
                    table.ForeignKey(
                        name: "FK_RecipeCategories_Categories_CategoryId",
                        column: x => x.CategoryId,
                        principalSchema: "catalog",
                        principalTable: "Categories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_RecipeCategories_Recipes_RecipeId",
                        column: x => x.RecipeId,
                        principalSchema: "catalog",
                        principalTable: "Recipes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "RecipeEquipment",
                schema: "catalog",
                columns: table => new
                {
                    RecipeId = table.Column<Guid>(type: "uuid", nullable: false),
                    EquipmentId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RecipeEquipment", x => new { x.RecipeId, x.EquipmentId });
                    table.ForeignKey(
                        name: "FK_RecipeEquipment_Recipes_RecipeId",
                        column: x => x.RecipeId,
                        principalSchema: "catalog",
                        principalTable: "Recipes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "RecipeFlavorProfiles",
                schema: "catalog",
                columns: table => new
                {
                    RecipeId = table.Column<Guid>(type: "uuid", nullable: false),
                    FlavorProfileId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RecipeFlavorProfiles", x => new { x.RecipeId, x.FlavorProfileId });
                    table.ForeignKey(
                        name: "FK_RecipeFlavorProfiles_FlavorProfiles_FlavorProfileId",
                        column: x => x.FlavorProfileId,
                        principalSchema: "catalog",
                        principalTable: "FlavorProfiles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_RecipeFlavorProfiles_Recipes_RecipeId",
                        column: x => x.RecipeId,
                        principalSchema: "catalog",
                        principalTable: "Recipes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "RecipeGlassware",
                schema: "catalog",
                columns: table => new
                {
                    RecipeId = table.Column<Guid>(type: "uuid", nullable: false),
                    EquipmentId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RecipeGlassware", x => new { x.RecipeId, x.EquipmentId });
                    table.ForeignKey(
                        name: "FK_RecipeGlassware_Recipes_RecipeId",
                        column: x => x.RecipeId,
                        principalSchema: "catalog",
                        principalTable: "Recipes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "RecipeIngredientLines",
                schema: "catalog",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    RecipeId = table.Column<Guid>(type: "uuid", nullable: false),
                    Position = table.Column<int>(type: "integer", nullable: false),
                    IngredientId = table.Column<Guid>(type: "uuid", nullable: false),
                    Quantity = table.Column<decimal>(type: "numeric", nullable: false),
                    Unit = table.Column<string>(type: "text", nullable: false),
                    Purpose = table.Column<string>(type: "text", nullable: true),
                    ScalingRule = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RecipeIngredientLines", x => x.Id);
                    table.ForeignKey(
                        name: "FK_RecipeIngredientLines_Recipes_RecipeId",
                        column: x => x.RecipeId,
                        principalSchema: "catalog",
                        principalTable: "Recipes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "RecipeRelations",
                schema: "catalog",
                columns: table => new
                {
                    RecipeId = table.Column<Guid>(type: "uuid", nullable: false),
                    RelatedRecipeId = table.Column<Guid>(type: "uuid", nullable: false),
                    Note = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RecipeRelations", x => new { x.RecipeId, x.RelatedRecipeId });
                    table.ForeignKey(
                        name: "FK_RecipeRelations_Recipes_RecipeId",
                        column: x => x.RecipeId,
                        principalSchema: "catalog",
                        principalTable: "Recipes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_RecipeRelations_Recipes_RelatedRecipeId",
                        column: x => x.RelatedRecipeId,
                        principalSchema: "catalog",
                        principalTable: "Recipes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "RecipeTags",
                schema: "catalog",
                columns: table => new
                {
                    RecipeId = table.Column<Guid>(type: "uuid", nullable: false),
                    TagId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RecipeTags", x => new { x.RecipeId, x.TagId });
                    table.ForeignKey(
                        name: "FK_RecipeTags_Recipes_RecipeId",
                        column: x => x.RecipeId,
                        principalSchema: "catalog",
                        principalTable: "Recipes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_RecipeTags_Tags_TagId",
                        column: x => x.TagId,
                        principalSchema: "catalog",
                        principalTable: "Tags",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.InsertData(
                schema: "catalog",
                table: "Families",
                columns: new[] { "Id", "Definition", "NameKey", "ParentFamilyId" },
                values: new object[,]
                {
                    { new Guid("00000000-0000-0000-0000-000000000101"), "The base cocktail family.", "family.cocktail", null },
                    { new Guid("00000000-0000-0000-0000-000000000102"), "Spirit-forward, stirred drinks.", "family.spiritForward", null },
                    { new Guid("00000000-0000-0000-0000-000000000103"), "Spirit, citrus, sweetener.", "family.sour", null },
                    { new Guid("00000000-0000-0000-0000-000000000104"), "Spirit lengthened with a mixer over ice.", "family.highball", null },
                    { new Guid("00000000-0000-0000-0000-000000000105"), "Wine or spirit, sugar, and fruit over crushed ice.", "family.cobbler", null },
                    { new Guid("00000000-0000-0000-0000-000000000108"), "Spirit or wine, sugar, and a whole egg, shaken.", "family.flip", null },
                    { new Guid("00000000-0000-0000-0000-000000000106"), "Cobbler subtype: spirit, sugar, and mint over crushed ice.", "family.julep", new Guid("00000000-0000-0000-0000-000000000105") },
                    { new Guid("00000000-0000-0000-0000-000000000107"), "Cobbler subtype: spirit, sugar, and muddled fruit/herbs over crushed ice.", "family.smash", new Guid("00000000-0000-0000-0000-000000000105") },
                    { new Guid("00000000-0000-0000-0000-000000000109"), "Flip subtype: served over ice with milk or cream.", "family.nog", new Guid("00000000-0000-0000-0000-000000000108") }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Categories_NameKey",
                schema: "catalog",
                table: "Categories",
                column: "NameKey",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ConceptPages_Name",
                schema: "catalog",
                table: "ConceptPages",
                column: "Name",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ConceptVariantLinks_ConceptId_RecipeId",
                schema: "catalog",
                table: "ConceptVariantLinks",
                columns: new[] { "ConceptId", "RecipeId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ConceptVariantLinks_RecipeId",
                schema: "catalog",
                table: "ConceptVariantLinks",
                column: "RecipeId");

            migrationBuilder.CreateIndex(
                name: "IX_Families_NameKey",
                schema: "catalog",
                table: "Families",
                column: "NameKey",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Families_ParentFamilyId",
                schema: "catalog",
                table: "Families",
                column: "ParentFamilyId");

            migrationBuilder.CreateIndex(
                name: "IX_FlavorProfiles_NameKey",
                schema: "catalog",
                table: "FlavorProfiles",
                column: "NameKey",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_RecipeCategories_CategoryId",
                schema: "catalog",
                table: "RecipeCategories",
                column: "CategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_RecipeEquipment_EquipmentId",
                schema: "catalog",
                table: "RecipeEquipment",
                column: "EquipmentId");

            migrationBuilder.CreateIndex(
                name: "IX_RecipeFlavorProfiles_FlavorProfileId",
                schema: "catalog",
                table: "RecipeFlavorProfiles",
                column: "FlavorProfileId");

            migrationBuilder.CreateIndex(
                name: "IX_RecipeGlassware_EquipmentId",
                schema: "catalog",
                table: "RecipeGlassware",
                column: "EquipmentId");

            migrationBuilder.CreateIndex(
                name: "IX_RecipeIngredientLines_RecipeId_Position",
                schema: "catalog",
                table: "RecipeIngredientLines",
                columns: new[] { "RecipeId", "Position" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_RecipeRelations_RelatedRecipeId",
                schema: "catalog",
                table: "RecipeRelations",
                column: "RelatedRecipeId");

            migrationBuilder.CreateIndex(
                name: "IX_Recipes_OwnerId",
                schema: "catalog",
                table: "Recipes",
                column: "OwnerId");

            migrationBuilder.CreateIndex(
                name: "IX_Recipes_PrimaryName",
                schema: "catalog",
                table: "Recipes",
                column: "PrimaryName");

            migrationBuilder.CreateIndex(
                name: "IX_RecipeTags_TagId",
                schema: "catalog",
                table: "RecipeTags",
                column: "TagId");

            migrationBuilder.CreateIndex(
                name: "IX_Tags_Key",
                schema: "catalog",
                table: "Tags",
                column: "Key",
                unique: true);

            // GIN index over the generated SearchVector column (T032/R8), plus a
            // trigram index on PrimaryName for fuzzy name matching.
            migrationBuilder.Sql("""CREATE INDEX "IX_Recipes_SearchVector" ON catalog."Recipes" USING GIN ("SearchVector");""");
            migrationBuilder.AddTrigramIndex("catalog", "Recipes", "PrimaryName");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ConceptVariantLinks",
                schema: "catalog");

            migrationBuilder.DropTable(
                name: "Families",
                schema: "catalog");

            migrationBuilder.DropTable(
                name: "RecipeCategories",
                schema: "catalog");

            migrationBuilder.DropTable(
                name: "RecipeEquipment",
                schema: "catalog");

            migrationBuilder.DropTable(
                name: "RecipeFlavorProfiles",
                schema: "catalog");

            migrationBuilder.DropTable(
                name: "RecipeGlassware",
                schema: "catalog");

            migrationBuilder.DropTable(
                name: "RecipeIngredientLines",
                schema: "catalog");

            migrationBuilder.DropTable(
                name: "RecipeRelations",
                schema: "catalog");

            migrationBuilder.DropTable(
                name: "RecipeTags",
                schema: "catalog");

            migrationBuilder.DropTable(
                name: "ConceptPages",
                schema: "catalog");

            migrationBuilder.DropTable(
                name: "Categories",
                schema: "catalog");

            migrationBuilder.DropTable(
                name: "FlavorProfiles",
                schema: "catalog");

            migrationBuilder.DropTable(
                name: "Recipes",
                schema: "catalog");

            migrationBuilder.DropTable(
                name: "Tags",
                schema: "catalog");
        }
    }
}
