import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';
import 'home_screen.dart';

class EditPostScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const EditPostScreen({super.key, required this.post});

  @override
  EditPostScreenState createState() => EditPostScreenState();
}

class EditPostScreenState extends State<EditPostScreen> {
  final TextEditingController _contentController = TextEditingController();
  int? _selectedMoodScore;
  int? _selectedMoodId;
  String? _selectedSubMood;
  late DateTime _selectedDate;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.post['content'] ?? '';
    _selectedMoodScore = widget.post['mood_score'] ?? 0;
    _selectedMoodId = widget.post['mood_id'] ?? 0;
    _selectedSubMood = _getSubMoodLabel(widget.post['mood_id']);
    _selectedDate = widget.post['post_date'] != null
        ? DateTime.parse(widget.post['post_date'])
        : DateTime.now();
  }

  String _getSubMoodLabel(int? moodId) {
    switch (moodId) {
      case 1:
        return 'Depressed';
      case 2:
        return 'Anxious';
      case 3:
        return 'Angry';
      case 4:
        return 'Overwhelmed';
      case 5:
        return 'Sad';
      case 6:
        return 'Tired';
      case 7:
        return 'Frustrated';
      case 8:
        return 'Disappointed';
      case 9:
        return 'Okay';
      case 10:
        return 'Satisfied';
      case 11:
        return 'Hopeful';
      case 12:
        return 'Relaxed';
      case 13:
        return 'Happy';
      case 14:
        return 'Excited';
      case 15:
        return 'Proud';
      case 16:
        return 'Loved';
      case 17:
        return 'Euphoric';
      case 18:
        return 'Inspired';
      case 19:
        return 'Grateful';
      case 20:
        return 'Accomplished';
      default:
        return '';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onNextPressed() {
    setState(() {
      _currentStep++;
    });
  }

  void _onBackPressed() {
    setState(() {
      _currentStep--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_currentStep == 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFFE68C52)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 4),
                ],
              ),
              const SizedBox(height: 8),
              Text("How are you today?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE68C52))),
              const SizedBox(height: 48),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE68C52)),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Color(0xFFE68C52)),
                      SizedBox(width: 8),
                      Text(
                          "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [1, 2, 3, 4, 5]
                    .map((score) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMoodScore = score;
                            });
                          },
                          child: Opacity(
                            opacity: _selectedMoodScore == score ? 1.0 : 0.4,
                            child: Image.asset(
                                'assets/images/${[
                                  'bad',
                                  'poor',
                                  'medium',
                                  'good',
                                  'excellent'
                                ][score - 1]}.png',
                                width: 42,
                                height: 42),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 48),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE68C52)),
                  child:
                      Text("Next", style: TextStyle(color: Color(0xFFFFFFFF))),
                ),
              ),
            ] else if (_currentStep == 1) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFFE68C52)),
                    onPressed: _onBackPressed,
                  ),
                  SizedBox(width: 4),
                  Image.asset(
                    _getMoodImagePath(_selectedMoodScore ?? 3),
                    width: 28,
                    height: 28,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text("Select a sub mood",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE68C52))),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2,
                children: _getMoodOptions()
                    .map((option) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSubMood = option['label'];
                              _selectedMoodId = option['mood_id'];
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedSubMood == option['label']
                                  ? Color(0xFFE68C52)
                                  : Color(0xFFFFFFFF),
                              border: Border.all(color: Color(0xFFE68C52)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              option['label'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _selectedSubMood == option['label']
                                    ? Color(0xFFFFFFFF)
                                    : Color(0xFFE68C52),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE68C52)),
                  child:
                      Text("Next", style: TextStyle(color: Color(0xFFFFFFFF))),
                ),
              ),
            ] else if (_currentStep == 2) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFFE68C52)),
                    onPressed: _onBackPressed,
                  ),
                  SizedBox(width: 4),
                  Image.asset(
                    _getMoodImagePath(_selectedMoodScore ?? 3),
                    width: 28,
                    height: 28,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text("Type your notes here...",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE68C52))),
              const SizedBox(height: 32),
              Container(
                height: 120,
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFE68C52)),
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Type your notes here...",
                      hintStyle: TextStyle(color: Color(0xFFA6A6A6))),
                ),
              ),
              const SizedBox(height: 52),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE68C52)),
                      onPressed: () async {
                        if (_contentController.text.isNotEmpty) {
                          final userId =
                              Provider.of<UserProvider>(context, listen: false)
                                  .user?['user_id'];
                          if (userId != null) {
                            final success = await Provider.of<PostProvider>(
                                    context,
                                    listen: false)
                                .updatePost(
                              postId: widget.post['post_id'],
                              userId: userId,
                              moodId: _selectedMoodId!,
                              moodScore: _selectedMoodScore!,
                              content: _contentController.text,
                              isPosted: false,
                              postDate: _selectedDate.toIso8601String(),
                              updatedAt: DateTime.now().toIso8601String(),
                            );
                            if (success) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => HomeScreen()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Failed to update post')),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('User not logged in')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please type a note first!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Text("Save",
                          style: TextStyle(color: Color(0xFFFFFFFF)))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE68C52)),
                      onPressed: () async {
                        if (_contentController.text.isNotEmpty) {
                          final userId =
                              Provider.of<UserProvider>(context, listen: false)
                                  .user?['user_id'];
                          if (userId != null) {
                            final success = await Provider.of<PostProvider>(
                                    context,
                                    listen: false)
                                .updatePost(
                              postId: widget.post['post_id'],
                              userId: userId,
                              moodId: _selectedMoodId!,
                              moodScore: _selectedMoodScore!,
                              content: _contentController.text,
                              isPosted: true,
                              postDate: _selectedDate.toIso8601String(),
                              updatedAt: DateTime.now().toIso8601String(),
                            );
                            if (success) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => HomeScreen()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Failed to update post')),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('User not logged in')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please type a note first!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Text("Share",
                          style: TextStyle(color: Color(0xFFFFFFFF)))),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getMoodOptions() {
    switch (_selectedMoodScore) {
      case 1:
        return [
          {"mood_id": 1, "label": "Depressed"},
          {"mood_id": 2, "label": "Anxious"},
          {"mood_id": 3, "label": "Angry"},
          {"mood_id": 4, "label": "Overwhelmed"}
        ];
      case 2:
        return [
          {"mood_id": 5, "label": "Sad"},
          {"mood_id": 6, "label": "Tired"},
          {"mood_id": 7, "label": "Frustrated"},
          {"mood_id": 8, "label": "Disappointed"}
        ];
      case 3:
        return [
          {"mood_id": 9, "label": "Okay"},
          {"mood_id": 10, "label": "Satisfied"},
          {"mood_id": 11, "label": "Hopeful"},
          {"mood_id": 12, "label": "Relaxed"}
        ];
      case 4:
        return [
          {"mood_id": 13, "label": "Happy"},
          {"mood_id": 14, "label": "Excited"},
          {"mood_id": 15, "label": "Proud"},
          {"mood_id": 16, "label": "Loved"}
        ];
      case 5:
        return [
          {"mood_id": 17, "label": "Euphoric"},
          {"mood_id": 18, "label": "Inspired"},
          {"mood_id": 19, "label": "Grateful"},
          {"mood_id": 20, "label": "Accomplished"}
        ];
      default:
        return [];
    }
  }

  String _getMoodImagePath(int score) {
    switch (score) {
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
        return 'assets/images/medium.png'; // Default image
    }
  }
}
