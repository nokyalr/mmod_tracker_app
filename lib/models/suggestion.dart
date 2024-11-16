class Suggestion {
  final String suggestionText;
  final String linkToArticle;

  Suggestion({required this.suggestionText, required this.linkToArticle});

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      suggestionText: json['suggestion_text'],
      linkToArticle: json['link_to_article'] ?? '',
    );
  }
}
