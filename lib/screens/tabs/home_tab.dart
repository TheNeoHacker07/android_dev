import "package:android_dev/screens/content/post_widget.dart";
import "package:android_dev/screens/content/story_widget.dart";
import "package:android_dev/screens/home_screen/data/mock_data.dart";
import "package:android_dev/screens/home_screen/services/post_services.dart";
import "package:flutter/material.dart";

class HomeTab extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    PostServices postServices = PostServices();
    postServices.batchAddPosts(mockPosts);
    postServices.batchAddStories(mockStories);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Instagram'),
      ),
      body: ListView.builder(
        // +1 because the first item is the stories row
        itemCount: postServices.posts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return StoriesListWidget(stories: postServices.stories);
          }
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: PostWidget(post: postServices.posts[index - 1]),
          );
        },
      ),
    );
  }
}
