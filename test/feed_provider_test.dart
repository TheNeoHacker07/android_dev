import "package:android_dev/core/db/app_database.dart";
import "package:android_dev/core/db/database_provider.dart";
import "package:android_dev/screens/auth/providers/auth_providers.dart";
import "package:android_dev/screens/auth/services/auth_service.dart";
import "package:android_dev/screens/home_screen/data/mock_data.dart";
import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/providers/feed_providers.dart";
import "package:drift/native.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  late ProviderContainer container;
  late AuthService auth;

  setUp(() {
    // Dependency injection: the whole app runs on a fresh in-memory database.
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(
          AppDatabase(NativeDatabase.memory()),
        ),
      ],
    );
    // keep the streams alive between reads
    container.listen(currentUserProvider, (_, _) {});
    container.listen(feedProvider, (_, _) {});
    auth = container.read(authServiceProvider);
  });
  tearDown(() async {
    await container.read(databaseProvider).close();
    container.dispose();
  });

  /// Waits until the logged-in user's name equals [username] (null = logged out).
  Future<void> expectUser(String? username) async {
    for (var i = 0; i < 50; i++) {
      final user = await container.read(currentUserProvider.future);
      if (user?.username == username) return;
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    fail("current user never became $username");
  }

  /// Waits until the feed stream has delivered a state that passes [test].
  Future<PostModel> firstPostWhen(bool Function(PostModel) test) async {
    for (var i = 0; i < 50; i++) {
      final posts = await container.read(feedProvider.future);
      if (test(posts.first)) return posts.first;
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    fail("feed never reached the expected state");
  }

  test("new database is seeded and nobody is logged in", () async {
    await expectUser(null);
    final posts = await container.read(feedProvider.future);
    expect(posts, hasLength(seedPosts.length));
    expect(posts.first.description, seedPosts.first.description);
    expect(posts.first.commentCount, seedPosts.first.comments.length);
  });

  test("register logs in, logout logs out, login works again", () async {
    await auth.register(username: " New_User ", password: "secret1");
    await expectUser("new_user");
    final user = await container.read(currentUserProvider.future);
    expect(user!.passwordHash, isNot(contains("secret1")));

    await auth.logout();
    await expectUser(null);

    await auth.login(username: "NEW_USER", password: "secret1");
    await expectUser("new_user");
  });

  test("register and login reject bad input", () async {
    await expectLater(
      auth.register(username: "aida", password: "secret1"),
      throwsA(isA<AuthException>()),
    );
    await expectLater(
      auth.register(username: "ok_name", password: "123"),
      throwsA(isA<AuthException>()),
    );
    await expectLater(
      auth.login(username: "aida", password: "wrong-password"),
      throwsA(isA<AuthException>()),
    );
    await auth.login(username: "aida", password: seedPassword);
    await expectUser("aida");
  });

  test("likes are stored per user", () async {
    final feed = container.read(feedProvider.notifier);

    await auth.login(username: "aida", password: seedPassword);
    var post = await firstPostWhen((_) => true);
    await feed.toggleLike(post);
    post = await firstPostWhen((p) => p.isLiked);
    expect(post.likeCount, 1);

    // another user sees aida's like in the count, but not as their own
    await auth.logout();
    await auth.login(username: "timur", password: seedPassword);
    post = await firstPostWhen((p) => !p.isLiked);
    expect(post.likeCount, 1);
    await feed.toggleLike(post);
    post = await firstPostWhen((p) => p.likeCount == 2);
    expect(post.isLiked, isTrue);

    // unlike removes only timur's like
    await feed.toggleLike(post);
    post = await firstPostWhen((p) => p.likeCount == 1);
    expect(post.isLiked, isFalse);
  });

  test("comments and comment likes go to the database", () async {
    await auth.login(username: "aida", password: seedPassword);
    final feed = container.read(feedProvider.notifier);
    final post = await firstPostWhen((_) => true);
    final provider = commentsProvider(post.id);
    container.listen(provider, (_, _) {});

    await feed.addComment(postId: post.id, text: "  hello from test  ");
    await firstPostWhen((p) => p.commentCount == post.commentCount + 1);
    var comments = await container.read(provider.future);
    expect(comments.last.text, "hello from test");
    expect(comments.last.author, "aida");

    await feed.toggleCommentLike(comments.last);
    await pumpEventQueue();
    comments = await container.read(provider.future);
    expect(comments.last.isLiked, isTrue);
    expect(comments.last.likeCount, 1);
  });
}
