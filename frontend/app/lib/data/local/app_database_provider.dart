import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// One AppDatabase instance for the app's lifetime — every repository (T029's
/// pattern, repository.dart) reads this instead of opening its own connection.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
