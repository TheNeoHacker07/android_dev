import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:flutter/material.dart";
import "package:android_dev/screens/content/comments_widget.dart";


class PostWidget extends StatefulWidget {
  final PostModel? post;
  const PostWidget({super.key,required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  void toggleLike() {
    final post = widget.post;
    if (post == null) return;
    setState(() {
      post.isLiked = !post.isLiked;
      post.addLike((post.likeCount ?? 0) + (post.isLiked ? 1 : -1));
    });
  }
 void openBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: CommentListWidget(comments: widget.post?.comments ?? []),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              widget.post?.imageUrl ?? 'https://via.placeholder.com/150',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: (widget.post?.isLiked ?? false)
                    ? const Icon(Icons.favorite, color: Colors.red)
                    : const Icon(Icons.favorite_border),
                onPressed: toggleLike,
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () {
                  openBottomSheet();
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
              Spacer(),
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
                '${widget.post?.likeCount ?? 0} likes',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Text(
            widget.post?.description ?? '',
            style: const TextStyle(fontSize: 16.0),
          ),

        ],)

    );
  }
}