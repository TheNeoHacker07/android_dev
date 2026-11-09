import 'package:flutter/material.dart';
import 'package:android_dev/screens/home_screen/models/comments_model.dart';

const _defaultLikeImageUrl =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUAgHFb3z2Z4sV6Jv9pREKSXdWG18FAFk9By-deHO9Ig&s=10';


class CommentListWidget extends StatefulWidget {
  final List<CommentModel> comments;

  const CommentListWidget({super.key, required this.comments});

  @override
  State<CommentListWidget> createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends State<CommentListWidget> {
  @override
  Widget build(BuildContext context) {
    final comments = widget.comments;
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
            onPressed: () => setState(() => comment.isLiked = !comment.isLiked),
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



