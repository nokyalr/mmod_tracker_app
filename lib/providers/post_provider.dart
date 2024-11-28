import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/constants.dart';

class PostProvider with ChangeNotifier {
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get posts => _posts;
  bool get isLoading => _isLoading;

  // Fetch all posts from the server
  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    final url = APIConfig.postsUrl;

    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        _posts = data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw 'Failed to load posts: ${response.statusCode}';
      }
    } catch (error) {
      print('Error fetching posts: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new post
  Future<bool> createPost({
    required int userId,
    required int moodId,
    required int moodScore,
    required String content,
    required bool isPosted,
    required String postDate,
  }) async {
    final url = APIConfig.postsUrl;

    final Map<String, dynamic> postData = {
      'user_id': userId,
      'mood_id': moodId,
      'mood_score': moodScore,
      // 'content': content,
      // 'is_posted': isPosted ? 1 : 0, // Convert boolean to integer (1 or 0)
      // 'post_date': postDate,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(postData),
      );

      if (response.statusCode == 201) {
        // Post successfully created, optionally refetch posts
        await fetchPosts();
        return true;
      } else {
        print('Failed to create post: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error creating post: $error');
      return false;
    }
  }

  // Clear all posts from local state
  void clearPosts() {
    _posts = [];
    notifyListeners();
  }
}
