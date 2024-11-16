import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/mood.dart';
import '../models/post.dart';
import '../models/suggestion.dart';

class ApiService {
  final String baseUrl = 'http://localhost/mood_tracker_backend/api';

  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user.php?action=login'),
      body: json.encode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<List<Mood>> getMoods() async {
    final response = await http.get(Uri.parse('$baseUrl/mood.php'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((mood) => Mood.fromJson(mood)).toList();
    } else {
      throw Exception('Failed to load moods');
    }
  }

  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/post.php'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> createPost(
      int userId, int moodId, int moodScore, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/post.php'),
      body: json.encode({
        'user_id': userId,
        'mood_id': moodId,
        'mood_score': moodScore,
        'content': content,
        'is_posted': 1,
        'post_date': DateTime.now().toString(),
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create post');
    }
  }

  Future<List<Suggestion>> getSuggestions() async {
    final response = await http.get(Uri.parse('$baseUrl/suggestion.php'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((suggestion) => Suggestion.fromJson(suggestion)).toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }
}
