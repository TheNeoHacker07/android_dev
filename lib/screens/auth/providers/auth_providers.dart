import 'package:android_dev/core/db/app_database.dart';
import 'package:android_dev/core/db/database_provider.dart';
import 'package:android_dev/screens/auth/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.watch(databaseProvider)),
);

/// The logged-in user (null = logged out). The whole app listens to this:
/// AuthGate swaps login screen <-> main screen, and the feed uses the id
/// to know which posts this user liked.
final currentUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).watchCurrentUser(),
);
