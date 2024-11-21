import 'package:flutter/material.dart';
import 'package:mood_tracker_app/screens/user_screen.dart';
import 'package:provider/provider.dart';
import '../providers/friends_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/text_field.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  FriendsScreenState createState() => FriendsScreenState();
}

class FriendsScreenState extends State<FriendsScreen> {
  final TextEditingController _friendController = TextEditingController();
  final TextEditingController _searchUsernameController =
      TextEditingController();
  String searchQuery = '';
  bool showOverlay = false;

  List<int> friendIds = [];

  @override
  void initState() {
    super.initState();
    final userId =
        Provider.of<UserProvider>(context, listen: false).user?['user_id'];
    if (userId != null) {
      final friendsProvider =
          Provider.of<FriendsProvider>(context, listen: false);
      friendsProvider.fetchFriends(userId);
      friendsProvider.fetchAllUsers(userId);
      friendsProvider.fetchFriendIds(userId).then((ids) {
        setState(() {
          friendIds = ids;
        });
      });
    }
  }

  void _openAddFriendOverlay() {
    setState(() {
      showOverlay = true;
      _searchUsernameController.clear();
    });
  }

  void _closeAddFriendOverlay() {
    setState(() {
      showOverlay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<FriendsProvider>(context);
    final friends = friendsProvider.friends;
    final allUsers = friendsProvider.filteredUsers;
    final loggedInUserId =
        Provider.of<UserProvider>(context, listen: false).user?['user_id'];

    final filteredUsers = allUsers
        .where((user) =>
            user['user_id'] != loggedInUserId &&
            !friendIds.contains(user['user_id']))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        useImage: true,
        imagePath: 'assets/images/back.png',
        imageHeight: 28,
        titleText: 'Friends',
        navigationScreen: const UserScreen(),
        useBorder: true,
        backgroundColor: Colors.white,
        textColor: const Color(0xFFE68C52),
        imageColor: const Color(0xFFE68C52),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _friendController,
                        hintText: 'Search friends',
                        prefixIconPath: 'assets/images/search.png',
                        showVisibilityIcon: false,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Friends - ${friends.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE68C52),
                        ),
                      ),
                      const Divider(
                        thickness: 1.5,
                        color: Color(0xFFE68C52),
                        height: 10,
                      ),
                    ],
                  ),
                ),
                ...friends
                    .where((friend) => friend['name']
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .map((friend) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage(friend['profile_picture']),
                          radius: 24,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              friend['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '@${friend['username']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFFA6A6A6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          if (showOverlay)
            GestureDetector(
              onTap: _closeAddFriendOverlay,
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          if (showOverlay)
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: _closeAddFriendOverlay,
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFFE68C52),
                            ),
                          ),
                          const Text(
                            'Add Friend',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE68C52),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _searchUsernameController,
                        hintText: 'Search username',
                        prefixIconPath: 'assets/images/search.png',
                        showVisibilityIcon: false,
                        onChanged: friendsProvider.searchUsers,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage(user['profile_picture']),
                                radius: 20,
                              ),
                              title: Text(user['name'] ?? ''),
                              subtitle: Text('@${user['username']}'),
                              onTap: () {
                                // Action when a user is tapped
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddFriendOverlay,
        backgroundColor: const Color(0xFFE68C52),
        child: const Icon(Icons.add),
      ),
    );
  }
}
