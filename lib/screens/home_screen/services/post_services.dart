import 'package:android_dev/screens/home_screen/models/post_model.dart';
import 'package:android_dev/screens/home_screen/models/story_model.dart';

class PostServices{

  final List<PostModel> posts = [];
  final List<StoryModel> stories = [];

  PostServices();

  void addPost(PostModel post) {
    posts.add(post);
  }

  void toggleLike(PostModel post) {
    post.isLiked = !post.isLiked;
    post.addLike((post.likeCount ?? 0) + (post.isLiked ? 1 : -1));
  }

  void commentOnPost(PostModel post) {
    post.addComment((post.commentCount ?? 0) + 1);
  }

  void batchAddPosts(List<PostModel> newPosts) {
    posts.addAll(newPosts);
  }

  void batchAddStories(List<StoryModel> newStories) {
    stories.addAll(newStories);
  }
}