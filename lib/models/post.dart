class Post {
  final int postId;
  final int userId;
  final int moodId;
  final int moodScore;
  final String content;
  final String postDate;

  Post({
    required this.postId,
    required this.userId,
    required this.moodId,
    required this.moodScore,
    required this.content,
    required this.postDate,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['post_id'],
      userId: json['user_id'],
      moodId: json['mood_id'],
      moodScore: json['mood_score'],
      content: json['content'],
      postDate: json['post_date'],
    );
  }
}
