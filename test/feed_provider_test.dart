import "package:android_dev/screens/home_screen/models/comments_model.dart";
import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/providers/feed_providers.dart";
import "package:android_dev/screens/home_screen/services/post_services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("feedProvider likes and unlikes through the injected service", () {
    final comment = CommentModel(id: "c1", text: "hi", author: "aida");
    // Dependency injection: give the provider a small fake service
    // instead of the real one with 20 mock posts.
    final fakeService = PostServices()
      ..batchAddPosts([PostModel(description: "test", comments: [comment])]);
    final container = ProviderContainer(
      overrides: [postServicesProvider.overrideWithValue(fakeService)],
    );
    addTearDown(container.dispose);

    final feed = container.read(feedProvider.notifier);
    final post = container.read(feedProvider).single;

    feed.toggleLike(post);
    expect(container.read(feedProvider).single.isLiked, isTrue);
    expect(container.read(feedProvider).single.likeCount, 1);

    feed.toggleLike(post);
    expect(container.read(feedProvider).single.isLiked, isFalse);
    expect(container.read(feedProvider).single.likeCount, 0);

    feed.toggleCommentLike(comment);
    expect(comment.isLiked, isTrue);
  });
}
