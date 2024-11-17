class APIConfig {
  static const String baseUrl = 'http://192.168.1.10/mood_tracker_backend/api';

  static String get loginUrl => '$baseUrl/user.php?action=login';
  static String get registerUrl => '$baseUrl/user.php?action=register';
  static String get postsUrl => '$baseUrl/posts.php';
  static String get moodUrl => '$baseUrl/mood.php';
  static String get updateAvatar => '$baseUrl/user.php?action=updateAvatar';
  static String get updateProfile => '$baseUrl/user.php?action=updateProfile';
  static String get fetchUser => '$baseUrl/user.php?action=get_user&user_id';
}
