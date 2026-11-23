import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:flutter/material.dart";
import "package:android_dev/screens/content/comments_widget.dart";

/// Only displays a post. The like logic lives in feedProvider; this widget
/// just reports the tap through [onLike].
class PostWidget extends StatelessWidget {
  final PostModel post;
  final VoidCallback onLike;
  const PostWidget({super.key, required this.post, required this.onLike});

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // lets the sheet move up above the keyboard
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // SafeArea keeps the input above the system navigation bar
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: CommentListWidget(postId: post.id),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatar = post.authorAvatarUrl;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        children: [
          // author
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: avatar == null ? null : NetworkImage(avatar),
                ),
                const SizedBox(width: 8),
                Text(
                  post.author,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              post.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: post.isLiked
                    ? const Icon(Icons.favorite, color: Colors.red)
                    : const Icon(Icons.favorite_border),
                onPressed: onLike,
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () => openBottomSheet(context),
              ),
              Text('${post.commentCount}'),
              IconButton(icon: const Icon(Icons.share), onPressed: () {}),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                post.likeCount == 1 ? '1 like' : '${post.likeCount} likes',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Text(post.description, style: const TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}
