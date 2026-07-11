import 'package:drift/drift.dart';

import 'app_database.dart';

/// Typed wrapper over the `local_search_index` FTS5 virtual table (see
/// AppDatabase._createSearchIndex) — raw SQL in, typed results out, since Drift's
/// query builder doesn't model FTS5's MATCH operator.
class LocalSearchIndex {
  LocalSearchIndex(this._db);

  final AppDatabase _db;

  Future<void> index({
    required String entityType,
    required String entityId,
    required String title,
    required String body,
  }) {
    return _db.customStatement(
      'INSERT INTO local_search_index (entity_type, entity_id, title, body) VALUES (?, ?, ?, ?)',
      [entityType, entityId, title, body],
    );
  }

  Future<List<LocalSearchResult>> search(String query) async {
    final rows = await _db
        .customSelect(
          'SELECT entity_type, entity_id, title FROM local_search_index WHERE local_search_index MATCH ? ORDER BY rank',
          variables: [Variable.withString(query)],
        )
        .get();

    return rows
        .map(
          (row) => LocalSearchResult(
            entityType: row.read<String>('entity_type'),
            entityId: row.read<String>('entity_id'),
            title: row.read<String>('title'),
          ),
        )
        .toList();
  }
}

class LocalSearchResult {
  LocalSearchResult({
    required this.entityType,
    required this.entityId,
    required this.title,
  });

  final String entityType;
  final String entityId;
  final String title;
}
