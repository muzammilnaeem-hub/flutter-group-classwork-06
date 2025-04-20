import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostRepository {
  Future<List<Post>> fetchPosts(int startIndex, {int limit = 20}) async {
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch posts');
    }
  }
}
