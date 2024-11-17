import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config/constants.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _user;

  Future<void> register(String username, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse(APIConfig.registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
          'name': name,
        }),
      );

      if (response.statusCode == 201) {
        notifyListeners();
      } else {
        final error = json.decode(response.body)['message'];
        throw Exception(error ?? 'Registration failed');
      }
    } catch (error) {
      rethrow;
    }
  }

  // Login API
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
        _user = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', json.encode(_user));
        notifyListeners();
      } else {
        final error = json.decode(response.body)['message'];
        throw Exception(error ?? 'Login failed');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchUser(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('${APIConfig.fetchUser}=$userId'));

      if (response.statusCode == 200) {
        _user = json.decode(response.body);
        notifyListeners();
      } else {
        final error = json.decode(response.body)['message'];
        throw Exception(error ?? 'Failed to fetch user data');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateAvatar(String profilePicture) async {
    final userId = _user?['user_id'];
    if (userId == null) return;

    final body =
        json.encode({'user_id': userId, 'profile_picture': profilePicture});

    final response = await http.post(
      Uri.parse(APIConfig.updateAvatar),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      _user?['profile_picture'] = profilePicture;
      notifyListeners();
    } else {
      throw Exception('Failed to update avatar');
    }
  }

  Future<void> updateProfile(String name, String password) async {
    final userId = _user?['user_id'];
    if (userId == null) return;

    final body = json.encode({
      'user_id': userId,
      'name': name,
      'password': password,
    });

    final response = await http.post(
      Uri.parse(APIConfig.updateProfile),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      _user?['name'] = name;
      notifyListeners();
    } else {
      throw Exception('Failed to update profile');
    }
  }

  void logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await DefaultCacheManager().emptyCache();
    notifyListeners();
  }

  Future<void> restoreUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      _user = json.decode(userData);
      notifyListeners();
    }
  }
}
