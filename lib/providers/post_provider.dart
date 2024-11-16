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
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } on http.ClientException {
      _posts = [];
    } on TimeoutException {
      _posts = [];
    } catch (error) {
      _posts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearPosts() {
    _posts = [];
    notifyListeners();
  }
}
