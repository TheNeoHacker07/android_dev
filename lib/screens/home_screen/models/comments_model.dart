class CommentModel {
  final String id;
  final String text;
  final String author;
  final String? likeImageUrl;
  final String? userImageUrl;

  CommentModel({
    required this.id,
    required this.text,
    required this.author,
    this.likeImageUrl,
    this.userImageUrl,
  });


  void addComment(String newText) {
    
  }
}
