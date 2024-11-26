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
  int? selectedUserId;

  @override
  void initState() {
    super.initState();
    final userId =
        Provider.of<UserProvider>(context, listen: false).user?['user_id'];
    if (userId != null) {
      final friendsProvider =
          Provider.of<FriendsProvider>(context, listen: false);
      friendsProvider.fetchFriends(userId, context);
      friendsProvider.fetchAllUsers(userId);
      friendsProvider.fetchFriendIds(userId).then((ids) {
        if (mounted) {
          setState(() {
            friendIds = ids;
          });
        }
      });
      friendsProvider.fetchPendingRequests(userId);
    }
  }

  void _openAddFriendOverlay() {
    setState(() {
      showOverlay = true;
      _searchUsernameController.clear();
      selectedUserId = null;
    });
  }

  void _closeAddFriendOverlay() {
    setState(() {
      showOverlay = false;
      selectedUserId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<FriendsProvider>(context);
    final friends = friendsProvider.friends;
    final allUsers = friendsProvider.filteredUsers;
    final pendingRequests = friendsProvider.pendingRequests;
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
                if (friends.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'You have no friends yet. Add friends to start.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFA6A6A6),
                      ),
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
                          backgroundImage: AssetImage(
                              friend['profile_picture'] ??
                                  'assets/images/default_profile.png'),
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
                }),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pending Friend Requests',
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
                if (pendingRequests.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'No pending friend requests.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFA6A6A6),
                      ),
                    ),
                  ),
                ...pendingRequests.map((request) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(
                              request['profile_picture'] ??
                                  'assets/images/default_profile.png'),
                          radius: 24,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '@${request['username']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFFA6A6A6),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            final userId = Provider.of<UserProvider>(context,
                                    listen: false)
                                .user?['user_id'];
                            if (userId != null) {
                              friendsProvider.acceptFriendRequest(
                                  userId, request['user_id'], context);
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            final userId = Provider.of<UserProvider>(context,
                                    listen: false)
                                .user?['user_id'];
                            if (userId != null) {
                              friendsProvider.rejectFriendRequest(
                                  userId, request['user_id'], context);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }),
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
                height: MediaQuery.of(context).size.height * 0.6,
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
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedUserId =
                                      selectedUserId == user['user_id']
                                          ? null
                                          : user['user_id'];
                                });
                              },
                              child: Container(
                                color: selectedUserId == user['user_id']
                                    ? Color(0xFFE68C52).withOpacity(0.2)
                                    : Colors.transparent,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage(user[
                                            'profile_picture'] ??
                                        'assets/images/default_profile.png'),
                                    radius: 20,
                                  ),
                                  title: Text(user['name'] ?? ''),
                                  subtitle: Text('@${user['username']}'),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Add buttons at the bottom
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 115,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: selectedUserId != null
                                    ? () async {
                                        final userId =
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .user?['user_id'];
                                        if (userId != null &&
                                            selectedUserId != null) {
                                          try {
                                            await friendsProvider.addFriend(
                                                userId,
                                                selectedUserId!,
                                                context);
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Friend added successfully')),
                                              );
                                              _closeAddFriendOverlay();
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Failed to add friend')),
                                              );
                                            }
                                          }
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                          color: Color(0xFFE68C52)),
                                    ),
                                    backgroundColor: selectedUserId != null
                                        ? const Color(0xFFE68C52)
                                        : const Color(0xFFFFFFFF),
                                    disabledBackgroundColor: Color(0xFFFFFFFF)),
                                child: Text(
                                  'add',
                                  style: TextStyle(
                                    color: selectedUserId != null
                                        ? Colors.white
                                        : const Color(0xFFE68C52),
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            )
                          ],
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
