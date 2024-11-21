import 'package:flutter/material.dart';
import 'package:mood_tracker_app/screens/report_screen.dart';
import 'package:provider/provider.dart';
import 'user_screen.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<PostProvider>(context, listen: false).fetchPosts();
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
      // Navigator.pushReplacement(
      //   context,
      //   PageRouteBuilder(
      //     pageBuilder: (context, animation1, animation2) => SuggestionScreen(),
      //     transitionDuration: Duration.zero,
      //   ),
      // );
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

  String getMoodImage(int moodScore) {
    switch (moodScore) {
      case 1:
        return 'assets/images/bad.png';
      case 2:
        return 'assets/images/poor.png';
      case 3:
        return 'assets/images/medium.png';
      case 4:
        return 'assets/images/good.png';
      case 5:
        return 'assets/images/excellent.png';
      default:
        return 'assets/images/medium.png';
    }
  }

  String formatTimeAgo(String timestamp) {
    final DateTime postTime = DateTime.parse(timestamp);
    final Duration difference = DateTime.now().difference(postTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else {
      final int weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);
    final posts = postProvider.posts;
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
        titleText: 'Welcome back, ${user['name'] ?? 'Guest'}!',
        useBorder: true,
        imageHeight: 42,
        useImage: true,
        backgroundColor: Colors.white,
        textColor: const Color(0xFFE68C52),
      ),
      body: postProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : posts.isEmpty
              ? const Center(child: Text('No posts available'))
              : ListView.builder(
                  itemCount: posts.length,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE68C52)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundImage: AssetImage(post[
                                                  'profile_picture'] ??
                                              'assets/images/default_profile.png'),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                post['name'] ?? 'Unknown User',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFE68C52),
                                                ),
                                              ),
                                              Text(
                                                post['time'] != null
                                                    ? formatTimeAgo(
                                                        post['time'])
                                                    : 'Some time ago',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFFA6A6A6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      post['description'] ??
                                          'No description available',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      post['date'] ?? 'Unknown Date',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFFA6A6A6)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: Image.asset(
                                  getMoodImage(post['mood_score'] ?? 3),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Color(0xFFE68C52)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Add a comment...',
                                  style: TextStyle(color: Color(0xFFA6A6A6)),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.comment,
                                      color: Color(0xFFA6A6A6)),
                                  const SizedBox(width: 4),
                                  Text(
                                    post['comments'] ?? '0',
                                    style: TextStyle(color: Color(0xFFA6A6A6)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tambahkan aksi ketika tombol "+" ditekan
          print('Tombol "+" ditekan!');
        },
        backgroundColor: const Color(0xFFE68C52),
        child: const Icon(Icons.add, size: 36, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
