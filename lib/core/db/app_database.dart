import 'package:android_dev/core/security/password.dart';
import 'package:android_dev/screens/home_screen/data/mock_data.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// ---------- Tables ----------
// Drift turns every class below into an SQLite table and generates a row
// class for it (Users -> User, Posts -> Post, ...) in app_database.g.dart.
// After changing a table run:  dart run build_runner build

/// Accounts. Username is unique; the password is stored only as a hash.
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(min: 3, max: 30).unique()();
  TextColumn get passwordHash => text()();
  TextColumn get salt => text()();
  TextColumn get avatarUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// A post always belongs to a user. Like and comment counts are NOT stored
/// here: they are counted from PostLikes / Comments, so they can never drift.
class Posts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get authorId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get imageUrl => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// One row = "this user likes this post". The (userId, postId) primary key
/// makes a double like impossible.
class PostLikes extends Table {
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();
  IntColumn get postId =>
      integer().references(Posts, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column<Object>> get primaryKey => {userId, postId};
}

class Comments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get postId =>
      integer().references(Posts, #id, onDelete: KeyAction.cascade)();
  IntColumn get authorId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get body => text().withLength(min: 1, max: 500)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class CommentLikes extends Table {
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();
  IntColumn get commentId =>
      integer().references(Comments, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column<Object>> get primaryKey => {userId, commentId};
}

/// Who is logged in on this device. Holds at most one row:
/// login writes it, logout deletes it, so the login survives an app restart.
class Sessions extends Table {
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get loggedInAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {userId};
}

// ---------- Database ----------

@DriftDatabase(
  tables: [Users, Posts, PostLikes, Comments, CommentLikes, Sessions],
)
class AppDatabase extends _$AppDatabase {
  /// The app uses a file on the phone; tests pass an in-memory database.
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'instaclone'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seed();
    },
    // SQLite ignores REFERENCES unless this is switched on.
    beforeOpen: (_) => customStatement('PRAGMA foreign_keys = ON'),
  );

  /// Fills a brand-new database with the starter users, posts and comments.
  Future<void> _seed() async {
    final userIds = <String, int>{};
    for (final user in seedUsers) {
      final salt = newSalt();
      userIds[user.username] = await into(users).insert(
        UsersCompanion.insert(
          username: user.username,
          passwordHash: hashPassword(seedPassword, salt),
          salt: salt,
          avatarUrl: Value(avatarUrl(user.avatar)),
        ),
      );
    }

    final now = DateTime.now();
    for (final (index, post) in seedPosts.indexed) {
      // Older posts further down the feed.
      final postTime = now.subtract(Duration(hours: index + 1));
      final postId = await into(posts).insert(
        PostsCompanion.insert(
          authorId: userIds[post.author]!,
          imageUrl: post.imageUrl,
          description: Value(post.description),
          createdAt: Value(postTime),
        ),
      );
      for (final (i, (author, text)) in post.comments.indexed) {
        await into(comments).insert(
          CommentsCompanion.insert(
            postId: postId,
            authorId: userIds[author]!,
            body: text,
            createdAt: Value(postTime.add(Duration(minutes: i + 1))),
          ),
        );
      }
    }
  }
}
