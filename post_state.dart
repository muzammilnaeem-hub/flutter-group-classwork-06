import '../models/post.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostSuccess extends PostState {
  final List<Post> posts;
  final bool hasReachedMax;

  PostSuccess({required this.posts, required this.hasReachedMax});
}

class PostFailure extends PostState {}
