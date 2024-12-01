import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/user_provider.dart';
import '../providers/suggestion_provider.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/text_field.dart';
import 'home_screen.dart';
import 'report_screen.dart';
import 'user_screen.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  SuggestionScreenState createState() => SuggestionScreenState();
}

class SuggestionScreenState extends State<SuggestionScreen> {
  int _selectedIndex = 2;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId =
          Provider.of<UserProvider>(context, listen: false).user?['user_id'];
      if (userId != null) {
        Provider.of<SuggestionProvider>(context, listen: false)
            .fetchSuggestionsBySubMood(userId);
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => HomeScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => ReportScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => SuggestionScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => UserScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      debugPrint('Launching URL: $url');
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Cannot launch URL: $url');
    }
  }

  void _onSearchSubmitted() {
    final query = _searchController.text;
    final userId =
        Provider.of<UserProvider>(context, listen: false).user?['user_id'];
    if (query.isEmpty) {
      if (userId != null) {
        Provider.of<SuggestionProvider>(context, listen: false)
            .fetchSuggestionsBySubMood(userId);
      }
    } else {
      if (userId != null) {
        Provider.of<SuggestionProvider>(context, listen: false)
            .searchSuggestions(query, userId);
      }
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final suggestionProvider = Provider.of<SuggestionProvider>(context);
    final user = userProvider.user ??
        {
          'name': 'Guest',
          'profile_picture': 'assets/images/default_profile.png'
        };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        imagePath:
            user['profile_picture'] ?? 'assets/images/default_profile.png',
        titleText: 'Suggestions',
        useBorder: true,
        imageHeight: 42,
        useImage: false,
        backgroundColor: Colors.white,
        textColor: const Color(0xFFE68C52),
      ),
      body: suggestionProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : suggestionProvider.noSubMood
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'You have no posts yet. Please create a post to get suggestions based on your mood.',
                      style: TextStyle(fontSize: 16, color: Color(0xFFE68C52)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              hintText: 'Search suggestions...',
                              prefixIconPath: 'assets/images/search.png',
                              showVisibilityIcon: false,
                              onSubmitted: (value) {
                                _onSearchSubmitted();
                                _searchFocusNode.requestFocus();
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send, color: Color(0xFFE68C52)),
                            onPressed: () {
                              _onSearchSubmitted();
                              _searchFocusNode.requestFocus();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Based on your recent mood:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFE68C52),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (suggestionProvider.suggestions.isEmpty)
                        const Text(
                          'No suggestions available at the moment.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFA6A6A6),
                          ),
                        ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: suggestionProvider.suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion =
                              suggestionProvider.suggestions[index];
                          return GestureDetector(
                            onTap: () {
                              final url = suggestion['link_to_article'];
                              if (url != null) {
                                _launchUrl(url);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xFFE68C52)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    suggestion['suggestion_text'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFE68C52),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Divider(color: Color(0xFFE68C52)),
                                  Text(
                                    suggestion['description'] ??
                                        'No description available',
                                    style: const TextStyle(
                                        fontSize: 14, color: Color(0xFF000000)),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
