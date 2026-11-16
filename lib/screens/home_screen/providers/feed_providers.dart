import 'package:android_dev/screens/home_screen/data/mock_data.dart';
import 'package:android_dev/screens/home_screen/models/comments_model.dart';
import 'package:android_dev/screens/home_screen/models/post_model.dart';
import 'package:android_dev/screens/home_screen/models/story_model.dart';
import 'package:android_dev/screens/home_screen/services/comments_services.dart';
import 'package:android_dev/screens/home_screen/services/post_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------- Dependency injection ----------
// Each service is created once, here. Everything else asks Riverpod for it
// (ref.watch / ref.read) instead of calling PostServices() itself, so a test
// can swap in a different service with overrideWithValue.

final postServicesProvider = Provider<PostServices>((ref) {
  return PostServices()
    ..batchAddPosts(mockPosts)
    ..batchAddStories(mockStories);
});

final commentServicesProvider = Provider<CommentServices>(
  (ref) => CommentServices(),
);

// ---------- Data managers ----------

/// Stories never change while the app runs, so a plain Provider is enough.
final storiesProvider = Provider<List<StoryModel>>(
  (ref) => ref.watch(postServicesProvider).stories,
);

/// Owns the feed state. The services do the work; the notifier publishes a
/// new list afterwards so every widget watching [feedProvider] rebuilds.
// ponytail: models are mutable and changed in place by the services;
// switch to immutable models + copyWith if posts are ever shared across screens.
class FeedNotifier extends Notifier<List<PostModel>> {
  PostServices get _posts => ref.read(postServicesProvider);
  CommentServices get _comments => ref.read(commentServicesProvider);

  @override
  List<PostModel> build() => [...ref.watch(postServicesProvider).posts];

  void toggleLike(PostModel post) {
    _posts.toggleLike(post);
    state = [..._posts.posts];
  }

  void toggleCommentLike(CommentModel comment) {
    _comments.toggleLike(comment);
    state = [..._posts.posts];
  }
}

final feedProvider =
    NotifierProvider<FeedNotifier, List<PostModel>>(FeedNotifier.new);
