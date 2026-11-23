/// One comment as the comments sheet shows it. Built from a database query.
class CommentModel {
  final int id;
  final int postId;
  final String author;
  final String? userImageUrl;
  final String text;
  final int likeCount;

  /// Whether the logged-in user likes this comment.
  final bool isLiked;

  const CommentModel({
    required this.id,
    required this.postId,
    required this.author,
    this.userImageUrl,
    required this.text,
    this.likeCount = 0,
    this.isLiked = false,
  });
}
