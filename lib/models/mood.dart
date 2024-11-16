class Mood {
  final int moodId;
  final String moodLevel;
  final String moodCategory;

  Mood(
      {required this.moodId,
      required this.moodLevel,
      required this.moodCategory});

  factory Mood.fromJson(Map<String, dynamic> json) {
    return Mood(
      moodId: json['mood_id'],
      moodLevel: json['mood_level'],
      moodCategory: json['mood_category'],
    );
  }
}
