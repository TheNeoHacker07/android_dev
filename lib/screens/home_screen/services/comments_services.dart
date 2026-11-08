import 'package:android_dev/screens/home_screen/models/comments_model.dart';

class CommentServices {
  // Add your comment service methods here

  List<CommentModel> comments = [];


  void addComment(CommentModel comment) {
    comments.add(comment);
  }


  void batchAddComments(List<CommentModel> newComments) {
    comments.addAll(newComments);
  }

}