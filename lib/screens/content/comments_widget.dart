import 'package:android_dev/screens/home_screen/providers/feed_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _defaultLikeImageUrl =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUAgHFb3z2Z4sV6Jv9pREKSXdWG18FAFk9By-deHO9Ig&s=10';

/// Comments sheet of one post: the list from the database plus a field to
/// write a new comment.
class CommentListWidget extends ConsumerStatefulWidget {
  final int postId;

  const CommentListWidget({super.key, required this.postId});

  @override
  ConsumerState<CommentListWidget> createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends ConsumerState<CommentListWidget> {
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    _input.clear();
    await ref
        .read(feedProvider.notifier)
        .addComment(postId: widget.postId, text: text);
  }

  @override
  Widget build(BuildContext context) {
    // The sheet is a separate route, so it watches the comments itself.
    final comments = ref.watch(commentsProvider(widget.postId));

    return Column(
      children: [
        Expanded(
          child: comments.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('$error')),
            data: (comments) => comments.isEmpty
                ? const Center(child: Text('No comments yet'))
                : ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      final avatar = comment.userImageUrl;
                      return ListTile(
                        title: Text(comment.author),
                        subtitle: Text(comment.text),
                        leading: avatar != null
                            ? CircleAvatar(backgroundImage: NetworkImage(avatar))
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (comment.likeCount > 0)
                              Text('${comment.likeCount}'),
                            IconButton(
                              onPressed: () => ref
                                  .read(feedProvider.notifier)
                                  .toggleCommentLike(comment),
                              // faded until liked, full color once liked
                              icon: Opacity(
                                opacity: comment.isLiked ? 1 : 0.3,
                                child: Image.network(
                                  _defaultLikeImageUrl,
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 4, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _input,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    hintText: 'Add a comment…',
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
              IconButton(icon: const Icon(Icons.send), onPressed: _send),
            ],
          ),
        ),
      ],
    );
  }
}
