import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> setUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('user_id', userId);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user_id');
  }
}
