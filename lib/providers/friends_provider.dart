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

  List<Map<String, dynamic>> _pendingRequests = [];
  List<Map<String, dynamic>> get pendingRequests => _pendingRequests;

  void showMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<Map<String, dynamic>> makeApiRequest(String endpoint,
      {Map<String, dynamic>? body, bool isPost = false}) async {
    try {
      final Uri uri = Uri.parse(endpoint);
      final response = isPost
          ? await http.post(uri,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(body))
          : await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw ('Failed to load data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchFriends(int userId, BuildContext context) async {
    try {
      final data = await makeApiRequest(
          '${APIConfig.getFriends}?action=get_friends&user_id=$userId');

      if (data['friends'] != null && data['friends'].isNotEmpty) {
        _friends = List<Map<String, dynamic>>.from(data['friends']);
      } else {
        _friends = [];
        if (context.mounted) {
          showMessage('No friends found', context);
        }
      }
    } catch (e) {
      _friends = [];
      if (context.mounted) {
        showMessage('Failed to load friends', context);
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchAllUsers(int userId) async {
    try {
      final data = await makeApiRequest(
          '${APIConfig.getFriends}?action=get_all_users&user_id=$userId');
      _allUsers = List<Map<String, dynamic>>.from(data['users']);
      filteredUsers = List.from(_allUsers);
    } finally {
      notifyListeners();
    }
  }

  Future<List<int>> fetchFriendIds(int userId) async {
    try {
      final data = await makeApiRequest(
          '${APIConfig.getFriends}?action=get_friend_ids&user_id=$userId');
      friendIds = List<int>.from(data['friend_ids']);
    } finally {
      notifyListeners();
    }
    return friendIds;
  }

  void searchUsers(String query) {
    filteredUsers = _allUsers
        .where((user) =>
            user['username'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> addFriend(int userId, int friendId, BuildContext context) async {
    try {
      final data = await makeApiRequest(
        '${APIConfig.getFriends}?action=add_friend',
        body: {'user_id': userId, 'friend_id': friendId},
        isPost: true,
      );

      String message;
      switch (data['status']) {
        case 'already_friend':
          message = "You are already friends with this user.";
          break;
        case 'pending':
          message = "Friend request is pending.";
          break;
        case 'success':
          message = "Friend request sent successfully.";
          break;
        default:
          message = "An unknown error occurred.";
          break;
      }
      if (context.mounted) {
        showMessage(message, context);
      }

      await fetchFriends(userId, context);
      await fetchFriendIds(userId);
    } catch (e) {
      if (context.mounted) {
        showMessage("Failed to add friend", context);
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchPendingRequests(int userId) async {
    try {
      final data = await makeApiRequest(
          '${APIConfig.getFriends}?action=fetch_pending_requests&user_id=$userId');
      if (data['status'] == 'success' && data['pending_requests'] != null) {
        _pendingRequests =
            List<Map<String, dynamic>>.from(data['pending_requests']);
      } else {
        _pendingRequests = [];
      }
    } catch (e) {
      _pendingRequests = [];
    } finally {
      notifyListeners();
    }
  }

  Future<void> acceptFriendRequest(
      int userId, int friendId, BuildContext context) async {
    try {
      final data = await makeApiRequest(
        '${APIConfig.getFriends}?action=accept_friend_request',
        body: {'user_id': userId, 'friend_id': friendId},
        isPost: true,
      );

      String message = data['status'] == 'success'
          ? "Friend request accepted."
          : "Failed to accept friend request.";
      if (context.mounted) {
        showMessage(message, context);
      }

      if (data['status'] == 'success') {
        _pendingRequests
            .removeWhere((request) => request['user_id'] == friendId);
      }
      await fetchFriends(userId, context);
    } catch (e) {
      if (context.mounted) {
        showMessage("Failed to accept friend request", context);
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> rejectFriendRequest(
      int userId, int friendId, BuildContext context) async {
    try {
      final data = await makeApiRequest(
        '${APIConfig.getFriends}?action=reject_friend_request',
        body: {'user_id': userId, 'friend_id': friendId},
        isPost: true,
      );

      String message = data['status'] == 'success'
          ? "Friend request rejected."
          : "Failed to reject friend request.";
      if (context.mounted) {
        showMessage(message, context);
      }

      if (data['status'] == 'success') {
        _pendingRequests
            .removeWhere((request) => request['user_id'] == friendId);
      }
    } catch (e) {
      if (context.mounted) {
        showMessage("Failed to reject friend request", context);
      }
    } finally {
      notifyListeners();
    }
  }
}
