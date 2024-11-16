import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config/constants.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _user; // Store user data

  Map<String, dynamic>? get user => _user;

  // Registration API Call
  Future<void> register(String username, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse(APIConfig.registerUrl), // Perbaiki URL untuk registrasi
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
          'name': name,
        }),
      );

      if (response.statusCode == 201) {
        notifyListeners(); // Notify listeners about the state change
      } else {
        final error = json.decode(response.body)['message'];
        throw Exception(error ?? 'Registration failed');
      }
    } catch (error) {
      rethrow;
    }
  }

  // Login API Call
  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(APIConfig.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        _user = json.decode(response.body); // Save user data
        notifyListeners();
      } else {
        final error = json.decode(response.body)['message'];
        throw Exception(error ?? 'Login failed');
      }
    } catch (error) {
      rethrow;
    }
  }

  // Fetch User Data by user_id
  Future<void> fetchUser(int userId) async {
    try {
      final url =
          '${APIConfig.baseUrl}/user.php?action=get_user&user_id=$userId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        _user = json.decode(response.body); // Save user data
        notifyListeners();
      } else {
        final error = json.decode(response.body)['message'];
        throw Exception(error ?? 'Failed to fetch user data');
      }
    } catch (error) {
      rethrow;
    }
  }

  // Logout Function
  void logout() async {
    // Reset user data
    _user = null;

    // Hapus cache SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Hapus cache file HTTP
    await DefaultCacheManager().emptyCache();

    notifyListeners();
  }
}
