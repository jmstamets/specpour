/// T029's repository layer pattern (R9, offline-first architecture): every synced
/// entity's repository implements this, coordinating between the local Drift cache
/// (source of truth for reads — the UI never blocks on network) and api_client
/// (source of truth for writes, queued locally when offline and reconciled by the
/// sync engine, T130-T132, via GET /sync/changes and POST /sync/push with
/// merge-or-prompt conflict handling for user-authored edits, R9).
///
/// No concrete synced entity exists yet (Catalog/Ingredients/etc. land T032+), so
/// there is deliberately no second implementation of this interface here —
/// [SyncStateRepository] is the one concrete example today, over the sync
/// protocol's own bookmark table rather than a business entity.
abstract interface class SyncedRepository<T> {
  /// Local-first reads: reactive stream over the Drift cache, independent of
  /// network state.
  Stream<List<T>> watchAll();

  /// Local-first writes: returns once the local write lands, not once the server
  /// confirms it — the sync engine pushes queued writes when connectivity allows.
  Future<void> save(T entity);
}
