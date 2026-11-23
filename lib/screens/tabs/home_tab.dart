import "package:android_dev/screens/content/post_widget.dart";
import "package:android_dev/screens/content/story_widget.dart";
import "package:android_dev/screens/home_screen/providers/feed_providers.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch = rebuild this screen whenever the data changes.
    // The data now comes from the database, so it is an AsyncValue:
    // loading -> data (or error).
    final feed = ref.watch(feedProvider);
    final stories = ref.watch(storiesProvider).value ?? const [];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text('Instagram')),
      body: feed.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load feed: $error')),
        data: (posts) => ListView.builder(
          // +1 because the first item is the stories row
          itemCount: posts.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) return StoriesListWidget(stories: stories);
            final post = posts[index - 1];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: PostWidget(
                // key by id so Flutter reuses the right widget when the list changes
                key: ValueKey(post.id),
                post: post,
                // read = call an action once, don't subscribe
                onLike: () => ref.read(feedProvider.notifier).toggleLike(post),
              ),
            );
          },
        ),
      ),
    );
  }
}
