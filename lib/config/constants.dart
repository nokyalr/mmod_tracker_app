class APIConfig {
  static const String baseUrl = 'http://localhost/mood_tracker_backend/api';

  static String get loginUrl => '$baseUrl/user.php?action=login';
  static String get registerUrl => '$baseUrl/user.php?action=register';
  static String get postsUrl => '$baseUrl/posts.php';
  static String get moodUrl => '$baseUrl/mood.php';
  static String get updateAvatar => '$baseUrl/user.php?action=updateAvatar';
  static String get updateProfile => '$baseUrl/user.php?action=updateProfile';
  static String get fetchUser => '$baseUrl/user.php?action=get_user&user_id';
  static String get fetchReportSummary =>
      '$baseUrl/report.php?action=getMoodSummary&user_id';
  static String get fetchReportDates =>
      '$baseUrl/report.php?action=getMoodDates&user_id';
}
