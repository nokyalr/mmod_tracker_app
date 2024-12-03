import 'package:flutter/material.dart';
import 'package:mood_tracker_app/screens/edit_post_screen.dart';
import 'package:mood_tracker_app/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'package:mood_tracker_app/providers/post_provider.dart';
import 'package:mood_tracker_app/providers/user_provider.dart';

class CommentScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const CommentScreen({super.key, required this.post});

  @override
  CommentScreenState createState() => CommentScreenState();
}

class CommentScreenState extends State<CommentScreen> {
  @override
  void initState() {
    super.initState();
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.fetchComments(widget.post['post_id']);
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

  void _showEditRemoveDialog(BuildContext context) async {
    final userId =
        Provider.of<UserProvider>(context, listen: false).user?['user_id'];

    final action = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose an action'),
          content: const Text('Do you want to edit or remove this post?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    insetPadding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
                        ),
                        child: EditPostScreen(post: widget.post),
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Edit',
                  style: TextStyle(color: Color(0xFFE68C52))),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'remove'),
              child: const Text('Remove',
                  style: TextStyle(color: Color(0xFFE68C52))),
            ),
          ],
        );
      },
    );

    if (action == 'remove' && userId != null) {
      final success = await Provider.of<PostProvider>(context, listen: false)
          .removePost(widget.post['post_id']);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove post')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    final postProvider = Provider.of<PostProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final userId = userProvider.user?['user_id'];

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Color(0xFFE68C52),
            height: 1.0,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFE68C52)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Post',
          style: TextStyle(color: Color(0xFFE68C52)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
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
                            backgroundImage: AssetImage(
                                widget.post['profile_picture'] ??
                                    'assets/images/default_profile.png'),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post['name'] ?? 'Unknown User',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE68C52),
                                  ),
                                ),
                                Text(
                                  widget.post['time'] != null
                                      ? formatTimeAgo(widget.post['time'])
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
                        widget.post['description'] ??
                            'No description available',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget
                            .post['mood_category'], // Display the sub mood here
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        widget.post['date'] ?? 'Unknown Date',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFFA6A6A6)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    getMoodImage(widget.post['mood_score'] ?? 3),
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            const Divider(color: Color(0xFFE68C52)),
            Expanded(
              child: Consumer<PostProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (provider.hasError) {
                    return const Center(child: Text('Error loading comments'));
                  } else if (provider.comments.isEmpty) {
                    return const Center(child: Text('No comments available'));
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0), // Mengurangi padding
                      itemCount: provider.comments.length,
                      itemBuilder: (context, index) {
                        final comment = provider.comments[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 4.0), // Mengurangi padding
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(
                                comment['profile_picture'] ??
                                    'assets/images/default_profile.png'),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  comment['name'].length > 20
                                      ? '${comment['name'].substring(0, 20)}...'
                                      : comment['name'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                formatTimeAgo(comment['created_at']),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFA6A6A6),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(comment['comment']),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: commentController,
                hintText: 'Add a comment...',
                prefixIconPath: 'assets/images/message.png',
                showVisibilityIcon: false,
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: Color(0xFFE68C52)),
              onPressed: () async {
                if (commentController.text.isNotEmpty && userId != null) {
                  await postProvider.addComment(
                    widget.post['post_id'],
                    userId,
                    commentController.text,
                  );
                  commentController.clear();
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: userId == widget.post['user_id']
          ? FloatingActionButton(
              onPressed: () {
                _showEditRemoveDialog(context);
              },
              backgroundColor: const Color(0xFFE68C52),
              child: const Icon(Icons.edit, size: 36, color: Colors.white),
            )
          : null,
    );
  }
}
