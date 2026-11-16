import 'package:flutter/material.dart';
import 'package:android_dev/screens/home_screen/models/comments_model.dart';
import 'package:android_dev/screens/home_screen/providers/feed_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _defaultLikeImageUrl =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUAgHFb3z2Z4sV6Jv9pREKSXdWG18FAFk9By-deHO9Ig&s=10';


class CommentListWidget extends ConsumerWidget {
  final List<CommentModel> comments;

  const CommentListWidget({super.key, required this.comments});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The bottom sheet is a separate screen, so it subscribes to the feed
    // itself to redraw when a comment like changes.
    ref.watch(feedProvider);
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return ListTile(
          title: Text(comment.author),
          subtitle: Text(comment.text),
          leading: comment.userImageUrl != null
              ? CircleAvatar(backgroundImage: NetworkImage(comment.userImageUrl!))
              : null,
          trailing: IconButton(
            onPressed: () => ref.read(feedProvider.notifier).toggleCommentLike(comment),
            // faded until liked, full color once liked
            icon: Opacity(
              opacity: comment.isLiked ? 1 : 0.3,
              child: Image.network(
                comment.likeImageUrl ?? _defaultLikeImageUrl,
                width: 24,
                height: 24,
              ),
            ),
          ),
        );
      },
    );
  }
}



