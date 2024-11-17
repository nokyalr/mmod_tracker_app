import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config/constants.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _user; // Store user data

  Map<String, dynamic>? get user => _user;

  // Registrasi API
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
        notifyListeners(); // Memberitahu perubahan state
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
        _user = json.decode(response.body); // Menyimpan data user
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', json.encode(_user)); // Cache data user
        notifyListeners();
      } else {
        final error = json.decode(response.body)['message'];
        throw Exception(error ?? 'Login failed');
      }
    } catch (error) {
      rethrow;
    }
  }

  // Ambil data pengguna berdasarkan user_id
  Future<void> fetchUser(int userId) async {
    try {
      final url =
          '${APIConfig.baseUrl}/user.php?action=get_user&user_id=$userId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        _user = json.decode(response.body); // Simpan data user
        notifyListeners();
      } else {
        final error = json.decode(response.body)['message'];
        throw Exception(error ?? 'Failed to fetch user data');
      }
    } catch (error) {
      rethrow;
    }
  }

  // Update Avatar
  Future<void> updateAvatar(String profilePicture) async {
    final userId = _user?['user_id'];
    if (userId == null) return;

    final url = '${APIConfig.baseUrl}/user.php?action=updateAvatar';
    final body =
        json.encode({'user_id': userId, 'profile_picture': profilePicture});

    final response = await http.post(
      Uri.parse(url),
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

  // Update Profil
  Future<void> updateProfile(String name, String password) async {
    final userId = _user?['user_id'];
    if (userId == null) return;

    final url = '${APIConfig.baseUrl}/user.php?action=updateProfile';
    final body = json.encode({
      'user_id': userId,
      'name': name,
      'password': password,
    });

    final response = await http.post(
      Uri.parse(url),
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

  // Logout
  void logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Menghapus data cache
    await DefaultCacheManager().emptyCache(); // Menghapus file cache
    notifyListeners();
  }

  // Restore User dari SharedPreferences
  Future<void> restoreUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      _user = json.decode(userData);
      notifyListeners();
    }
  }
}
