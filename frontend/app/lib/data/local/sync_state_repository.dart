import 'package:drift/drift.dart';

import 'app_database.dart';

/// The concrete repository example for T029's pattern (repository.dart) — reads and
/// advances the local sync cursor per entity stream. The real sync engine (T132)
/// calls [getCursor] before `GET /sync/changes?cursor=` and [setCursor] after
/// successfully applying a page of changes.
class SyncStateRepository {
  SyncStateRepository(this._db);

  final AppDatabase _db;

  Future<int> getCursor(String key) async {
    final row = await (_db.select(
      _db.syncState,
    )..where((row) => row.key.equals(key))).getSingleOrNull();
    return row?.cursor ?? 0;
  }

  Future<void> setCursor(String key, int cursor) {
    return _db
        .into(_db.syncState)
        .insertOnConflictUpdate(
          SyncStateCompanion.insert(key: key, cursor: Value(cursor)),
        );
  }
}
