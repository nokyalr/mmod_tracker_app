import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';
import 'home_screen.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: MoodDialog(onMoodSelected: (score) {}, onNextPressed: () {}),
      ),
    ),
  ));
}

class MoodDialog extends StatefulWidget {
  final Function(int) onMoodSelected;
  final VoidCallback onNextPressed;

  const MoodDialog(
      {super.key, required this.onMoodSelected, required this.onNextPressed});

  @override
  MoodDialogState createState() => MoodDialogState();
}

class MoodDialogState extends State<MoodDialog> {
  DateTime selectedDate = DateTime.now();
  int? selectedMoodScore;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("How are you today?",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE68C52))),
            const SizedBox(height: 16),
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
                        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [1, 2, 3, 4, 5]
                  .map((score) => _buildMoodImage(score))
                  .toList(),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _onNextPressed,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE68C52)),
                child: Text("Next", style: TextStyle(color: Color(0xFFFfFFFF))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodImage(int score) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedMoodScore == score) {
            selectedMoodScore = null; // Deselection if the same item is tapped
            widget.onMoodSelected(-1); // Pass deselection to parent
          } else {
            selectedMoodScore = score;
            widget.onMoodSelected(score); // Update mood selection
          }
        });
      },
      child: Opacity(
        opacity: selectedMoodScore == score ? 1.0 : 0.4,
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
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _onNextPressed() {
    if (selectedMoodScore != null) {
      showDialog(
          context: context,
          builder: (context) => MoodDetailsPage(
                selectedMoodScore: selectedMoodScore!,
                selectedDate: selectedDate,
              ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select a mood first!'),
          backgroundColor: Colors.red));
    }
  }
}

class MoodDetailsPage extends StatefulWidget {
  final int selectedMoodScore;
  final DateTime selectedDate;

  const MoodDetailsPage(
      {super.key, required this.selectedMoodScore, required this.selectedDate});

  @override
  MoodDetailsPageState createState() => MoodDetailsPageState();
}

class MoodDetailsPageState extends State<MoodDetailsPage> {
  int? selectedMoodScore;
  late int initialMoodScore; // Untuk menyimpan mood awal yang tidak berubah
  String? selectedItem; // Menyimpan item yang dipilih pada mood
  int? selectedMoodId; // Menyimpan mood_id yang dipilih

  @override
  void initState() {
    super.initState();
    selectedMoodScore = widget.selectedMoodScore;
    initialMoodScore = selectedMoodScore!;
    selectedItem = null; // Tidak ada item yang dipilih pada awalnya
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xFFE68C52)),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 4),
                Image.asset(
                  _getMoodImagePath(initialMoodScore),
                  width: 28,
                  height: 28,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _getMoodQuestionText(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE68C52)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2,
              children: _getMoodOptions()
                  .map((label) => _buildMoodOption(label))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE68C52)),
                onPressed: _onNextPressed,
                child: Text("Next", style: TextStyle(color: Color(0xFFFFfFFF))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMoodQuestionText() {
    switch (selectedMoodScore) {
      case 1:
        return "Isn’t anything under control?"; // Bad mood
      case 2:
        return "Is everything okay?"; // Poor mood
      case 3:
        return "Is there anything happened?"; // Medium mood
      case 4:
        return "Do you have something to share?"; // Good mood
      case 5:
        return "Great! What are you grateful for?"; // Excellent mood
      default:
        return "";
    }
  }

  List<Map<String, dynamic>> _getMoodOptions() {
    switch (selectedMoodScore) {
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

  Widget _buildMoodOption(Map<String, dynamic> moodOption) {
    bool isSelected =
        selectedItem == moodOption["label"]; // Cek apakah item ini dipilih

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedItem = null; // Deselect jika sudah dipilih
            selectedMoodId = null; // Reset mood_id
          } else {
            selectedItem = moodOption["label"];
            selectedMoodId = moodOption["mood_id"];
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFE68C52) : Color(0xFFFFFFFF),
          border: Border.all(color: Color(0xFFE68C52)),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          moodOption["label"],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Color(0xFFFFFFFF) : Color(0xFFE68C52),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _onNextPressed() {
    if (selectedItem != null) {
      showDialog(
        context: context,
        builder: (context) => NoteScreen(
          selectedMoodScore: selectedMoodScore!,
          selectedMoodId: selectedMoodId!,
          selectedDate: widget.selectedDate,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a sub mood first!'),
          backgroundColor: Colors.red,
        ),
      );
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

class NoteScreen extends StatelessWidget {
  final int selectedMoodScore;
  final int selectedMoodId;
  final DateTime selectedDate;

  const NoteScreen(
      {super.key,
      required this.selectedMoodScore,
      required this.selectedMoodId,
      required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final TextEditingController contentController = TextEditingController();

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xFFE68C52)),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 4),
                Image.asset(
                  _getMoodImagePath(selectedMoodScore),
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
                controller: contentController,
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
                      if (contentController.text.isNotEmpty) {
                        final userId =
                            Provider.of<UserProvider>(context, listen: false)
                                .user?['user_id'];
                        if (userId != null) {
                          final success = await postProvider.createPost(
                            userId: userId,
                            moodId: selectedMoodId,
                            moodScore: selectedMoodScore,
                            content: contentController.text,
                            isPosted: false,
                            postDate: selectedDate.toIso8601String(),
                          );
                          if (success) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => HomeScreen()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to create post')),
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
                      if (contentController.text.isNotEmpty) {
                        final userId =
                            Provider.of<UserProvider>(context, listen: false)
                                .user?['user_id'];
                        if (userId != null) {
                          final success = await postProvider.createPost(
                            userId: userId,
                            moodId: selectedMoodId,
                            moodScore: selectedMoodScore,
                            content: contentController.text,
                            isPosted: true,
                            postDate: selectedDate.toIso8601String(),
                          );
                          if (success) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => HomeScreen()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to create post')),
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
                    child: Text(
                      "Share",
                      style: TextStyle(color: Color(0xFFFFFFFF)),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
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
