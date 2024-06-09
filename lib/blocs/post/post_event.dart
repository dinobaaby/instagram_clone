import '../../models/post.dart';

abstract class PostEvent {}

class AddPostEvent extends PostEvent {
  final Post post;

  AddPostEvent(this.post);
}

class LoadPostsEvent extends PostEvent {}