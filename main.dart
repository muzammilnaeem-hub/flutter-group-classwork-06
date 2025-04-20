import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/post_bloc.dart';
import 'bloc/post_event.dart';
import 'bloc/post_state.dart';
import 'repository/post_repository.dart';
import 'models/post.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final PostRepository _repository = PostRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Infinite List',
      home: BlocProvider(
        create: (_) => PostBloc(repository: _repository)..add(PostFetched()),
        child: PostListScreen(),
      ),
    );
  }
}

class PostListScreen extends StatelessWidget {
  final _scrollController = ScrollController();

  PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<PostBloc>().add(PostFetched());
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text('Infinite List')),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (_, state) {
          if (state is PostFailure) {
            return Center(child: Text('Failed to fetch posts'));
          } else if (state is PostSuccess) {
            if (state.posts.isEmpty) return Center(child: Text('No posts'));
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax
                  ? state.posts.length
                  : state.posts.length + 1,
              itemBuilder: (_, index) {
                if (index >= state.posts.length) {
                  return Center(child: CircularProgressIndicator());
                }
                final post = state.posts[index];
                return ListTile(
                  title: Text('${post.id}: ${post.title}'),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
