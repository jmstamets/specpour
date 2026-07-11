import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/sync_state_table.dart';

part 'app_database.g.dart';

/// T029's Drift local store skeleton (R9: offline cache + sync workspace). Schema
/// v1 is deliberately minimal — SyncState (the pull-sync cursor bookmark, T130-T132)
/// and the FTS5 local search index (T134) — because no synced content entity exists
/// yet to model further; each future story's own local table lands alongside the
/// feature that needs it, following [SyncedRepository]'s pattern (repository.dart).
@DriftDatabase(tables: [SyncState])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For tests: pass an in-memory or NativeDatabase executor directly.
  AppDatabase.withExecutor(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await _createSearchIndex();
    },
    // v2+ migrations add onUpgrade steps here (Drift's versioned migrator, R9's
    // "migratable local schema") — never rewritten in place, same forward-only
    // posture as the backend's EF Core migrations.
  );

  /// FTS5 enablement (T029/R9). Declared via raw SQL rather than Drift's `.drift`
  /// virtual-table codegen (drift_dev 2.34.0 has an internal deserialization bug on
  /// FTS5-only include files at the time of writing) — a well-established,
  /// documented pattern in Drift apps regardless, since virtual tables' MATCH syntax
  /// isn't expressible through the type-safe query builder anyway. No synced content
  /// exists yet to index (T134, Phase 18, is the real consumer); [LocalSearchIndex]
  /// proves the extension actually loads and queries correctly on this platform.
  Future<void> _createSearchIndex() {
    return customStatement('''
      CREATE VIRTUAL TABLE local_search_index USING fts5(
        entity_type,
        entity_id UNINDEXED,
        title,
        body
      );
    ''');
  }

  static QueryExecutor _openConnection() => driftDatabase(name: 'specpour');
}
