import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/constants.dart';

class SuggestionProvider with ChangeNotifier {
  List<Map<String, dynamic>> _suggestions = [];
  bool _isLoading = false;
  bool _noSubMood = false;

  List<Map<String, dynamic>> get suggestions => _suggestions;
  bool get isLoading => _isLoading;
  bool get noSubMood => _noSubMood;

  Future<void> fetchSuggestionsBySubMood(int userId) async {
    _isLoading = true;
    _noSubMood = false;
    notifyListeners();

    final url = '${APIConfig.baseUrl}/suggestion.php?user_id=$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        _suggestions =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      } else if (response.statusCode == 404) {
        _noSubMood = true;
        _suggestions = [];
      } else {
        throw Exception('Failed to load suggestions');
      }
    } catch (error) {
      _suggestions = [];
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchSuggestions(String query, int userId) async {
    _isLoading = true;
    notifyListeners();

    final url =
        '${APIConfig.baseUrl}/suggestion.php?query=$query&user_id=$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        _suggestions =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to search suggestions');
      }
    } catch (error) {
      _suggestions = [];
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
