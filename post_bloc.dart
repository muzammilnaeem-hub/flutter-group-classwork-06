import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/post.dart';
import '../repository/post_repository.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repository;

  PostBloc({required this.repository}) : super(PostInitial()) {
    on<PostFetched>((event, emit) async {
      if (state is PostSuccess && (state as PostSuccess).hasReachedMax) return;

      try {
        final currentState = state;
        List<Post> oldPosts = [];

        if (currentState is PostSuccess) {
          oldPosts = currentState.posts;
        }

        final posts = await repository.fetchPosts(oldPosts.length);
        final allPosts = oldPosts + posts;

        emit(PostSuccess(
          posts: allPosts,
          hasReachedMax: posts.isEmpty,
        ));
      } catch (_) {
        emit(PostFailure());
      }
    });
  }
}
