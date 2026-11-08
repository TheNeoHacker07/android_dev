import 'package:android_dev/screens/home_screen/models/story_model.dart';
import 'package:flutter/material.dart';

/// One story: round avatar with the username below it.
class StoryWidget extends StatelessWidget {
  final StoryModel story;

  const StoryWidget({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.pink,
            child: CircleAvatar(
              radius: 29,
              child: ClipOval(
                child: Image.network(
                  story.imageUrl,
                  width: 58,
                  height: 58,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            story.username,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Horizontal row of stories shown under the app bar.
class StoriesListWidget extends StatelessWidget {
  final List<StoryModel> stories;

  const StoriesListWidget({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        itemCount: stories.length,
        itemBuilder: (context, index) => StoryWidget(story: stories[index]),
      ),
    );
  }
}
