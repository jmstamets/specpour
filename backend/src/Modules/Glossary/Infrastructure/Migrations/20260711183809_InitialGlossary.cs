using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NpgsqlTypes;
using SpecPour.BuildingBlocks.Search;

#nullable disable

namespace SpecPour.Modules.Glossary.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class InitialGlossary : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "glossary");

            // Must exist before Articles/GlossaryTerms' SearchVector generated
            // columns (below) reference it — idempotent, harmless if another
            // module's migration already created it.
            migrationBuilder.EnsureImmutableToTsVectorFunction();

            migrationBuilder.CreateTable(
                name: "Articles",
                schema: "glossary",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Title = table.Column<string>(type: "text", nullable: false),
                    Body = table.Column<string>(type: "text", nullable: false),
                    SearchVector = table.Column<NpgsqlTsVector>(type: "tsvector", nullable: true, computedColumnSql: "specpour_immutable_to_tsvector_english(coalesce(\"Title\", '') || ' ' || coalesce(\"Body\", ''))", stored: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Articles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "GlossaryTerms",
                schema: "glossary",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Term = table.Column<string>(type: "text", nullable: false),
                    Definitions = table.Column<string[]>(type: "text[]", nullable: false),
                    SearchVector = table.Column<NpgsqlTsVector>(type: "tsvector", nullable: true, computedColumnSql: "specpour_immutable_to_tsvector_english(coalesce(\"Term\", '') || ' ' || coalesce(specpour_immutable_array_to_string(\"Definitions\", ' '), ''))", stored: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GlossaryTerms", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ArticleContentLinks",
                schema: "glossary",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    ArticleId = table.Column<Guid>(type: "uuid", nullable: false),
                    ContentType = table.Column<int>(type: "integer", nullable: false),
                    ContentId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ArticleContentLinks", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ArticleContentLinks_Articles_ArticleId",
                        column: x => x.ArticleId,
                        principalSchema: "glossary",
                        principalTable: "Articles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ArticleTermLinks",
                schema: "glossary",
                columns: table => new
                {
                    ArticleId = table.Column<Guid>(type: "uuid", nullable: false),
                    GlossaryTermId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ArticleTermLinks", x => new { x.ArticleId, x.GlossaryTermId });
                    table.ForeignKey(
                        name: "FK_ArticleTermLinks_Articles_ArticleId",
                        column: x => x.ArticleId,
                        principalSchema: "glossary",
                        principalTable: "Articles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ArticleTermLinks_GlossaryTerms_GlossaryTermId",
                        column: x => x.GlossaryTermId,
                        principalSchema: "glossary",
                        principalTable: "GlossaryTerms",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "GlossaryTermContentLinks",
                schema: "glossary",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    GlossaryTermId = table.Column<Guid>(type: "uuid", nullable: false),
                    ContentType = table.Column<int>(type: "integer", nullable: false),
                    ContentId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GlossaryTermContentLinks", x => x.Id);
                    table.ForeignKey(
                        name: "FK_GlossaryTermContentLinks_GlossaryTerms_GlossaryTermId",
                        column: x => x.GlossaryTermId,
                        principalSchema: "glossary",
                        principalTable: "GlossaryTerms",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "LinkOverrides",
                schema: "glossary",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Context = table.Column<string>(type: "text", nullable: false),
                    TermId = table.Column<Guid>(type: "uuid", nullable: false),
                    Action = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_LinkOverrides", x => x.Id);
                    table.ForeignKey(
                        name: "FK_LinkOverrides_GlossaryTerms_TermId",
                        column: x => x.TermId,
                        principalSchema: "glossary",
                        principalTable: "GlossaryTerms",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ArticleContentLinks_ArticleId_ContentType_ContentId",
                schema: "glossary",
                table: "ArticleContentLinks",
                columns: new[] { "ArticleId", "ContentType", "ContentId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ArticleContentLinks_ContentType_ContentId",
                schema: "glossary",
                table: "ArticleContentLinks",
                columns: new[] { "ContentType", "ContentId" });

            migrationBuilder.CreateIndex(
                name: "IX_Articles_Title",
                schema: "glossary",
                table: "Articles",
                column: "Title");

            migrationBuilder.CreateIndex(
                name: "IX_ArticleTermLinks_GlossaryTermId",
                schema: "glossary",
                table: "ArticleTermLinks",
                column: "GlossaryTermId");

            migrationBuilder.CreateIndex(
                name: "IX_GlossaryTermContentLinks_ContentType_ContentId",
                schema: "glossary",
                table: "GlossaryTermContentLinks",
                columns: new[] { "ContentType", "ContentId" });

            migrationBuilder.CreateIndex(
                name: "IX_GlossaryTermContentLinks_GlossaryTermId_ContentType_Content~",
                schema: "glossary",
                table: "GlossaryTermContentLinks",
                columns: new[] { "GlossaryTermId", "ContentType", "ContentId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_GlossaryTerms_Term",
                schema: "glossary",
                table: "GlossaryTerms",
                column: "Term",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_LinkOverrides_Context_TermId",
                schema: "glossary",
                table: "LinkOverrides",
                columns: new[] { "Context", "TermId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_LinkOverrides_TermId",
                schema: "glossary",
                table: "LinkOverrides",
                column: "TermId");

            // GIN indexes over the generated SearchVector columns (FR-049), plus
            // trigram indexes for fuzzy name matching.
            migrationBuilder.Sql("""CREATE INDEX "IX_GlossaryTerms_SearchVector" ON glossary."GlossaryTerms" USING GIN ("SearchVector");""");
            migrationBuilder.Sql("""CREATE INDEX "IX_Articles_SearchVector" ON glossary."Articles" USING GIN ("SearchVector");""");
            migrationBuilder.AddTrigramIndex("glossary", "GlossaryTerms", "Term");
            migrationBuilder.AddTrigramIndex("glossary", "Articles", "Title");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ArticleContentLinks",
                schema: "glossary");

            migrationBuilder.DropTable(
                name: "ArticleTermLinks",
                schema: "glossary");

            migrationBuilder.DropTable(
                name: "GlossaryTermContentLinks",
                schema: "glossary");

            migrationBuilder.DropTable(
                name: "LinkOverrides",
                schema: "glossary");

            migrationBuilder.DropTable(
                name: "Articles",
                schema: "glossary");

            migrationBuilder.DropTable(
                name: "GlossaryTerms",
                schema: "glossary");
        }
    }
}
