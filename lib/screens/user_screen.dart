import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker_app/providers/post_provider.dart';
import 'package:mood_tracker_app/screens/edit_profile_screen.dart';
import 'package:mood_tracker_app/screens/report_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';

import '../../widgets/bottom_navigation.dart';
import '../../providers/user_provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    final userId =
        Provider.of<UserProvider>(context, listen: false).user?['user_id'];
    if (userId != null) {
      Provider.of<UserProvider>(context, listen: false).fetchUser(userId);
    }
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
          pageBuilder: (context, animation1, animation2) => const HomeScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const ReportScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    } else if (index == 2) {
      // Navigator.pushReplacement(
      //   context,
      //   PageRouteBuilder(
      //     pageBuilder: (context, animation1, animation2) =>
      //         const SuggestionScreen(),
      //     transitionDuration: Duration.zero,
      //   ),
      // );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const UserScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 150.0,
        backgroundColor: Colors.white,
        shape: Border(
          bottom: BorderSide(
            color: Color(0xFFE68C52).withOpacity(0.5),
            width: 2.0,
          ),
        ),
        title: user == null
            ? const Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  Image.asset(
                    user['profile_picture'] ??
                        'assets/images/default_profile.png',
                    height: 110,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'] ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Color(0xFFE68C52),
                          ),
                        ),
                        Text(
                          '@${user['username']}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Color(0xFFE68C52),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Edit Profile ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                EditProfileScreen(),
                                        transitionDuration: Duration.zero,
                                      ),
                                    );
                                  },
                              ),
                            ),
                            const SizedBox(width: 4),
                            Image.asset(
                              'assets/images/edit.png',
                              height: 14,
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/friends.png',
                    height: 24,
                  ),
                  const SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Friends',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigator.pushReplacement(
                          //   context,
                          //   PageRouteBuilder(
                          //     pageBuilder: (context, animation1, animation2) =>
                          //         ReportScreen(),
                          //     transitionDuration: Duration.zero,
                          //   ),
                          // );
                        },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Image.asset(
                    'assets/images/logout.png',
                    height: 24,
                  ),
                  const SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Sign out',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Provider.of<UserProvider>(context, listen: false)
                              .logout();
                          Provider.of<PostProvider>(context, listen: false)
                              .clearPosts();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
