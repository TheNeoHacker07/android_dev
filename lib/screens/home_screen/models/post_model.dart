/// One post as the feed shows it. Built from a database query, never changed
/// in place: after a like the database changes and a fresh list arrives.
class PostModel {
  final int id;
  final String author;
  final String? authorAvatarUrl;
  final String imageUrl;
  final String description;
  final int likeCount;
  final int commentCount;

  /// Whether the logged-in user likes this post.
  final bool isLiked;

  const PostModel({
    required this.id,
    required this.author,
    this.authorAvatarUrl,
    required this.imageUrl,
    required this.description,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
  });
}
