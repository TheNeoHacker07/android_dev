import 'package:android_dev/core/db/app_database.dart';
import 'package:android_dev/screens/home_screen/models/comments_model.dart';
import 'package:drift/drift.dart';

/// Reads and writes comments and comment likes in the database.
class CommentServices {
  CommentServices(this._db);

  final AppDatabase _db;

  /// Comments of one post, oldest first, re-emitted on every change.
  Stream<List<CommentModel>> watchComments({
    required int postId,
    required int? userId,
  }) {
    return _db
        .customSelect(
          '''
          SELECT c.id, c.post_id, c.body, u.username, u.avatar_url,
                 (SELECT COUNT(*) FROM comment_likes l WHERE l.comment_id = c.id) AS like_count,
                 EXISTS (SELECT 1 FROM comment_likes l
                         WHERE l.comment_id = c.id AND l.user_id = ?) AS is_liked
          FROM comments c
          JOIN users u ON u.id = c.author_id
          WHERE c.post_id = ?
          ORDER BY c.created_at ASC, c.id ASC
          ''',
          variables: [Variable<int>(userId ?? -1), Variable<int>(postId)],
          readsFrom: {_db.comments, _db.users, _db.commentLikes},
        )
        .watch()
        .map(
          (rows) => [
            for (final row in rows)
              CommentModel(
                id: row.read<int>('id'),
                postId: row.read<int>('post_id'),
                author: row.read<String>('username'),
                userImageUrl: row.read<String?>('avatar_url'),
                text: row.read<String>('body'),
                likeCount: row.read<int>('like_count'),
                isLiked: row.read<bool>('is_liked'),
              ),
          ],
        );
  }

  Future<void> addComment({
    required int postId,
    required int authorId,
    required String text,
  }) {
    return _db
        .into(_db.comments)
        .insert(
          CommentsCompanion.insert(
            postId: postId,
            authorId: authorId,
            body: text.trim(),
          ),
        );
  }

  Future<void> toggleLike({required int commentId, required int userId}) {
    return _db.transaction(() async {
      final removed =
          await (_db.delete(_db.commentLikes)..where(
                (l) => l.commentId.equals(commentId) & l.userId.equals(userId),
              ))
              .go();
      if (removed == 0) {
        await _db
            .into(_db.commentLikes)
            .insert(
              CommentLikesCompanion.insert(userId: userId, commentId: commentId),
            );
      }
    });
  }
}
