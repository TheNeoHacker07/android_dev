import 'package:android_dev/core/db/app_database.dart';
import 'package:android_dev/screens/home_screen/models/post_model.dart';
import 'package:android_dev/screens/home_screen/models/story_model.dart';
import 'package:drift/drift.dart';

/// Reads and writes posts, likes and stories in the database.
/// Knows nothing about widgets or Riverpod.
class PostServices {
  PostServices(this._db);

  final AppDatabase _db;

  /// The feed, newest first, re-emitted whenever posts, likes or comments
  /// change. [userId] decides which hearts are red (null = nobody logged in).
  Stream<List<PostModel>> watchFeed(int? userId) {
    return _db
        .customSelect(
          '''
          SELECT p.id, p.image_url, p.description,
                 u.username, u.avatar_url,
                 (SELECT COUNT(*) FROM post_likes l WHERE l.post_id = p.id) AS like_count,
                 (SELECT COUNT(*) FROM comments c WHERE c.post_id = p.id) AS comment_count,
                 EXISTS (SELECT 1 FROM post_likes l
                         WHERE l.post_id = p.id AND l.user_id = ?) AS is_liked
          FROM posts p
          JOIN users u ON u.id = p.author_id
          ORDER BY p.created_at DESC, p.id DESC
          ''',
          variables: [Variable<int>(userId ?? -1)],
          // watch() re-runs the query when any of these tables change
          readsFrom: {_db.posts, _db.users, _db.postLikes, _db.comments},
        )
        .watch()
        .map(
          (rows) => [
            for (final row in rows)
              PostModel(
                id: row.read<int>('id'),
                author: row.read<String>('username'),
                authorAvatarUrl: row.read<String?>('avatar_url'),
                imageUrl: row.read<String>('image_url'),
                description: row.read<String>('description'),
                likeCount: row.read<int>('like_count'),
                commentCount: row.read<int>('comment_count'),
                isLiked: row.read<bool>('is_liked'),
              ),
          ],
        );
  }

  /// Like if not liked yet, otherwise remove the like.
  Future<void> toggleLike({required int postId, required int userId}) {
    return _db.transaction(() async {
      final removed =
          await (_db.delete(_db.postLikes)..where(
                (l) => l.postId.equals(postId) & l.userId.equals(userId),
              ))
              .go();
      if (removed == 0) {
        await _db
            .into(_db.postLikes)
            .insert(PostLikesCompanion.insert(userId: userId, postId: postId));
      }
    });
  }

  /// Stories row: every user that has an avatar.
  Stream<List<StoryModel>> watchStories() {
    final query = _db.select(_db.users)
      ..where((u) => u.avatarUrl.isNotNull())
      ..orderBy([(u) => OrderingTerm.asc(u.id)]);
    return query.watch().map(
      (users) => [
        for (final u in users)
          StoryModel(username: u.username, imageUrl: u.avatarUrl!),
      ],
    );
  }
}
