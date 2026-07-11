using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SpecPour.Modules.Authorization.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddAuditLog : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AuditLogEntries",
                schema: "authz",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    ActorUserId = table.Column<Guid>(type: "uuid", nullable: false),
                    ActionKey = table.Column<string>(type: "text", nullable: false),
                    TargetEntityType = table.Column<string>(type: "text", nullable: false),
                    TargetEntityId = table.Column<Guid>(type: "uuid", nullable: false),
                    OccurredAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    BeforeStateJson = table.Column<string>(type: "text", nullable: true),
                    AfterStateJson = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditLogEntries", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AuditLogEntries_OccurredAt",
                schema: "authz",
                table: "AuditLogEntries",
                column: "OccurredAt");

            migrationBuilder.CreateIndex(
                name: "IX_AuditLogEntries_TargetEntityType_TargetEntityId",
                schema: "authz",
                table: "AuditLogEntries",
                columns: new[] { "TargetEntityType", "TargetEntityId" });

            // T019: append-only enforcement (FR-065/SC-016, data-model.md "no
            // UPDATE/DELETE permitted on the table"). A bare REVOKE is not sufficient
            // here — the app connects as "specpour", which OWNS this table (it ran the
            // CREATE TABLE above), and PostgreSQL table owners always retain full
            // privileges on their own objects regardless of REVOKE. The trigger below
            // is what actually enforces immutability, for the owning role or any
            // other. The REVOKE is issued anyway so it takes effect the day a
            // less-privileged runtime role (distinct from the migration-owner role)
            // is introduced — tracked under T139's hardening pass.
            migrationBuilder.Sql("""
                CREATE OR REPLACE FUNCTION authz.audit_log_entries_immutable()
                RETURNS trigger AS $$
                BEGIN
                    RAISE EXCEPTION 'authz.AuditLogEntries is append-only: % is not permitted', TG_OP;
                END;
                $$ LANGUAGE plpgsql;
                """);

            migrationBuilder.Sql("""
                CREATE TRIGGER audit_log_entries_no_update
                    BEFORE UPDATE ON authz."AuditLogEntries"
                    FOR EACH ROW EXECUTE FUNCTION authz.audit_log_entries_immutable();
                """);

            migrationBuilder.Sql("""
                CREATE TRIGGER audit_log_entries_no_delete
                    BEFORE DELETE ON authz."AuditLogEntries"
                    FOR EACH ROW EXECUTE FUNCTION authz.audit_log_entries_immutable();
                """);

            migrationBuilder.Sql("""REVOKE UPDATE, DELETE ON authz."AuditLogEntries" FROM specpour;""");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("""DROP TRIGGER IF EXISTS audit_log_entries_no_update ON authz."AuditLogEntries";""");
            migrationBuilder.Sql("""DROP TRIGGER IF EXISTS audit_log_entries_no_delete ON authz."AuditLogEntries";""");
            migrationBuilder.Sql("DROP FUNCTION IF EXISTS authz.audit_log_entries_immutable();");

            migrationBuilder.DropTable(
                name: "AuditLogEntries",
                schema: "authz");
        }
    }
}
