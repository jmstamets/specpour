using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace SpecPour.Tools.MigrationRunner.Migrations
{
    /// <inheritdoc />
    public partial class InitialBase : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // The 18 module-owned schemas (data-model.md; Search owns none — see the
            // T141 ADR) are created empty here so every module's own forward-only
            // migrations always have a pre-existing schema to add tables into. Not
            // derivable from SpecPourBaseDbContext's model (EF has no "empty schema"
            // entity type to hang this off), so hand-added post-scaffold.
            migrationBuilder.EnsureSchema(name: "identity");
            migrationBuilder.EnsureSchema(name: "authz");
            migrationBuilder.EnsureSchema(name: "catalog");
            migrationBuilder.EnsureSchema(name: "ingredients");
            migrationBuilder.EnsureSchema(name: "equipment");
            migrationBuilder.EnsureSchema(name: "glossary");
            migrationBuilder.EnsureSchema(name: "community");
            migrationBuilder.EnsureSchema(name: "inventory");
            migrationBuilder.EnsureSchema(name: "measurements");
            migrationBuilder.EnsureSchema(name: "shopping");
            migrationBuilder.EnsureSchema(name: "prep");
            migrationBuilder.EnsureSchema(name: "collections");
            migrationBuilder.EnsureSchema(name: "tastinglog");
            migrationBuilder.EnsureSchema(name: "media");
            migrationBuilder.EnsureSchema(name: "notifications");
            migrationBuilder.EnsureSchema(name: "compliance");
            migrationBuilder.EnsureSchema(name: "venues");
            migrationBuilder.EnsureSchema(name: "ai");

            migrationBuilder.EnsureSchema(
                name: "outbox");

            migrationBuilder.EnsureSchema(
                name: "sync");

            migrationBuilder.AlterDatabase()
                .Annotation("Npgsql:PostgresExtension:postgis", ",,");

            migrationBuilder.CreateTable(
                name: "outbox_messages",
                schema: "outbox",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    EventType = table.Column<string>(type: "text", nullable: false),
                    PayloadJson = table.Column<string>(type: "jsonb", nullable: false),
                    OccurredAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    SourceModule = table.Column<string>(type: "text", nullable: false),
                    ProcessedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    Attempts = table.Column<int>(type: "integer", nullable: false),
                    LastError = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_outbox_messages", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "sync_change",
                schema: "sync",
                columns: table => new
                {
                    Cursor = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityAlwaysColumn),
                    EntityType = table.Column<string>(type: "text", nullable: false),
                    EntityId = table.Column<Guid>(type: "uuid", nullable: false),
                    ChangeKind = table.Column<int>(type: "integer", nullable: false),
                    OccurredAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    SyncProtocolVersion = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_sync_change", x => x.Cursor);
                });

            migrationBuilder.CreateIndex(
                name: "IX_outbox_messages_ProcessedAt",
                schema: "outbox",
                table: "outbox_messages",
                column: "ProcessedAt");

            migrationBuilder.CreateIndex(
                name: "IX_sync_change_EntityType_EntityId",
                schema: "sync",
                table: "sync_change",
                columns: new[] { "EntityType", "EntityId" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "outbox_messages",
                schema: "outbox");

            migrationBuilder.DropTable(
                name: "sync_change",
                schema: "sync");

            // Schemas are intentionally left in place on Down() — by the time this base
            // migration could be rolled back, module migrations may have created tables
            // inside them, and forward-only is the mandated posture (constitution
            // Principle III / research R3) anyway. This Down() exists only to satisfy
            // EF's migration contract in dev/test scenarios.
        }
    }
}
