import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/constants.dart';

class FriendsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _friends = [];
  List<Map<String, dynamic>> get friends => _friends;

  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> get allUsers => _allUsers;

  List<Map<String, dynamic>> filteredUsers = [];
  List<int> friendIds = [];

  Future<void> fetchFriends(int userId) async {
    final response = await http.get(
      Uri.parse('${APIConfig.getFriends}?action=get_friends&user_id=$userId'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _friends = List<Map<String, dynamic>>.from(data['friends']);
      notifyListeners();
    }
  }

  Future<void> fetchAllUsers(int userId) async {
    final response = await http.get(
      Uri.parse('${APIConfig.getFriends}?action=get_all_users&user_id=$userId'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _allUsers = List<Map<String, dynamic>>.from(data['users']);
      filteredUsers = List.from(_allUsers);
      notifyListeners();
    }
  }

  Future<List<int>> fetchFriendIds(int userId) async {
    final response = await http.get(
      Uri.parse(
          '${APIConfig.getFriends}?action=get_friend_ids&user_id=$userId'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      friendIds = List<int>.from(data['friend_ids']);
      notifyListeners();
      return friendIds;
    } else {
      return [];
    }
  }

  void searchUsers(String query) {
    filteredUsers = _allUsers
        .where((user) =>
            user['username'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
