import 'package:drift/drift.dart';

/// T029: the pull-based sync protocol's local bookmark (R9). One row per synced
/// entity stream — `key` is a stream identifier (e.g. "recipes", "ingredients"; a
/// single "global" row is enough for now since no synced content exists yet).
/// The sync engine (T132) advances `cursor` as it consumes `GET /sync/changes`.
class SyncState extends Table {
  TextColumn get key => text()();
  IntColumn get cursor => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}
