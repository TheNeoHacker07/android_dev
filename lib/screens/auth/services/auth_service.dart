import 'package:android_dev/core/db/app_database.dart';
import 'package:android_dev/core/security/password.dart';
import 'package:drift/drift.dart';

/// Error with a message that can be shown to the user as is.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Registration, login and logout, stored in the Users and Sessions tables.
class AuthService {
  AuthService(this._db);

  final AppDatabase _db;

  static final _usernamePattern = RegExp(r'^[a-z0-9._]{3,30}$');
  static const minPasswordLength = 6;

  /// The logged-in user, or null. Emits again on every login/logout.
  Stream<User?> watchCurrentUser() {
    final query = _db.select(_db.sessions).join([
      innerJoin(_db.users, _db.users.id.equalsExp(_db.sessions.userId)),
    ]);
    return query.watchSingleOrNull().map((row) => row?.readTable(_db.users));
  }

  /// Creates the account and logs straight into it.
  Future<void> register({
    required String username,
    required String password,
  }) async {
    final name = _normalize(username);
    if (!_usernamePattern.hasMatch(name)) {
      throw const AuthException(
        'Username: 3–30 characters, only letters, digits, "." and "_"',
      );
    }
    if (password.length < minPasswordLength) {
      throw const AuthException(
        'Password must be at least $minPasswordLength characters',
      );
    }
    if (await _findByUsername(name) != null) {
      throw AuthException('Username "$name" is already taken');
    }

    final salt = newSalt();
    final userId = await _db
        .into(_db.users)
        .insert(
          UsersCompanion.insert(
            username: name,
            passwordHash: hashPassword(password, salt),
            salt: salt,
            // A generated avatar so the new user shows up in stories.
            avatarUrl: Value('https://i.pravatar.cc/150?u=$name'),
          ),
        );
    await _startSession(userId);
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final user = await _findByUsername(_normalize(username));
    // Same message for both cases, so nobody can probe which usernames exist.
    if (user == null || hashPassword(password, user.salt) != user.passwordHash) {
      throw const AuthException('Wrong username or password');
    }
    await _startSession(user.id);
  }

  Future<void> logout() => _db.delete(_db.sessions).go();

  String _normalize(String username) => username.trim().toLowerCase();

  Future<User?> _findByUsername(String username) => (_db.select(
    _db.users,
  )..where((u) => u.username.equals(username))).getSingleOrNull();

  /// Only one session per device: replace whatever was there.
  Future<void> _startSession(int userId) => _db.transaction(() async {
    await _db.delete(_db.sessions).go();
    await _db
        .into(_db.sessions)
        .insert(SessionsCompanion.insert(userId: Value(userId)));
  });
}
