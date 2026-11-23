import 'package:android_dev/core/db/database_provider.dart';
import 'package:android_dev/screens/auth/providers/auth_providers.dart';
import 'package:android_dev/screens/home_screen/models/comments_model.dart';
import 'package:android_dev/screens/home_screen/models/post_model.dart';
import 'package:android_dev/screens/home_screen/models/story_model.dart';
import 'package:android_dev/screens/home_screen/services/comments_services.dart';
import 'package:android_dev/screens/home_screen/services/post_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------- Dependency injection ----------
// databaseProvider -> services -> data managers -> widgets.
// Each service gets the database through its constructor, so a test can
// swap the real database for an in-memory one with a single override.

final postServicesProvider = Provider<PostServices>(
  (ref) => PostServices(ref.watch(databaseProvider)),
);

final commentServicesProvider = Provider<CommentServices>(
  (ref) => CommentServices(ref.watch(databaseProvider)),
);

/// Id of the logged-in user. `select` means: rebuild only when the id itself
/// changes, not on every event of currentUserProvider.
int? _userId(Ref ref) =>
    ref.watch(currentUserProvider.select((user) => user.value?.id));

// ---------- Data managers ----------

final storiesProvider = StreamProvider<List<StoryModel>>(
  (ref) => ref.watch(postServicesProvider).watchStories(),
);

/// Owns the feed. The state is a live database query: after any change
/// (like, comment, another user logs in) the database sends a new list and
/// every widget watching [feedProvider] rebuilds. The methods only write to
/// the database; they never touch `state` themselves.
class FeedNotifier extends StreamNotifier<List<PostModel>> {
  @override
  Stream<List<PostModel>> build() =>
      ref.watch(postServicesProvider).watchFeed(_userId(ref));

  int? get _currentUserId => ref.read(currentUserProvider).value?.id;

  Future<void> toggleLike(PostModel post) async {
    final userId = _currentUserId;
    if (userId == null) return;
    await ref
        .read(postServicesProvider)
        .toggleLike(postId: post.id, userId: userId);
  }

  Future<void> toggleCommentLike(CommentModel comment) async {
    final userId = _currentUserId;
    if (userId == null) return;
    await ref
        .read(commentServicesProvider)
        .toggleLike(commentId: comment.id, userId: userId);
  }

  Future<void> addComment({required int postId, required String text}) async {
    final userId = _currentUserId;
    if (userId == null || text.trim().isEmpty) return;
    await ref
        .read(commentServicesProvider)
        .addComment(postId: postId, authorId: userId, text: text);
  }
}

final feedProvider = StreamNotifierProvider<FeedNotifier, List<PostModel>>(
  FeedNotifier.new,
);

/// Comments of one post: ref.watch(commentsProvider(post.id)).
/// autoDispose closes the query when the comments sheet is closed.
final commentsProvider = StreamProvider.autoDispose
    .family<List<CommentModel>, int>(
      (ref, postId) => ref
          .watch(commentServicesProvider)
          .watchComments(postId: postId, userId: _userId(ref)),
    );
