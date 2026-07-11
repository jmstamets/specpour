import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specpour_app/data/local/app_database.dart';
import 'package:specpour_app/data/local/local_search_index.dart';
import 'package:specpour_app/data/local/sync_state_repository.dart';

/// T029: proves the Drift schema v1 skeleton actually works — an in-memory database
/// built from the same migrator every real device uses (AppDatabase.migration),
/// not a hand-maintained parallel test schema.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  group('SyncStateRepository', () {
    test('an unseen key defaults to cursor 0', () async {
      final repo = SyncStateRepository(db);

      expect(await repo.getCursor('recipes'), 0);
    });

    test('setCursor then getCursor round-trips the value', () async {
      final repo = SyncStateRepository(db);

      await repo.setCursor('recipes', 42);

      expect(await repo.getCursor('recipes'), 42);
    });

    test(
      'setCursor on an existing key updates rather than duplicating',
      () async {
        final repo = SyncStateRepository(db);

        await repo.setCursor('recipes', 1);
        await repo.setCursor('recipes', 2);

        expect(await repo.getCursor('recipes'), 2);
      },
    );
  });

  group('LocalSearchIndex (FTS5)', () {
    test('an indexed row is found by a matching query', () async {
      final index = LocalSearchIndex(db);
      await index.index(
        entityType: 'Widget',
        entityId: '1',
        title: 'Mai Tai',
        body: 'A classic tiki cocktail with rum and orgeat.',
      );

      final results = await index.search('tiki');

      expect(results, hasLength(1));
      expect(results.single.title, 'Mai Tai');
    });

    test('a non-matching query returns no results', () async {
      final index = LocalSearchIndex(db);
      await index.index(
        entityType: 'Widget',
        entityId: '1',
        title: 'Mai Tai',
        body: 'A classic tiki cocktail with rum and orgeat.',
      );

      final results = await index.search('xyzzyzzyzzy');

      expect(results, isEmpty);
    });
  });
}
