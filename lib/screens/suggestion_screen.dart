import 'package:flutter/material.dart';
import '../models/suggestion.dart';
import '../services/api_service.dart';

class SuggestionScreen extends StatelessWidget {
  const SuggestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Activity Suggestions')),
      body: FutureBuilder(
        future: ApiService().getSuggestions(),
        builder: (context, AsyncSnapshot<List<Suggestion>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading suggestions.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No suggestions available.'));
          } else {
            final suggestions = snapshot.data!;
            return ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return ListTile(
                  title: Text(suggestion.suggestionText),
                  subtitle: Text(suggestion.linkToArticle),
                  onTap: () {
                    if (suggestion.linkToArticle.isNotEmpty) {
                      // Navigate to external link
                      // Example: launchUrl(Uri.parse(suggestion.linkToArticle!));
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
