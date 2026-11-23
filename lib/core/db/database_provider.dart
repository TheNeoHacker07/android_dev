import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// The one database for the whole app. Tests override it with an in-memory
/// database: databaseProvider.overrideWithValue(AppDatabase(NativeDatabase.memory()))
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
