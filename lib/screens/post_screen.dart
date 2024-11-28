import 'package:flutter/material.dart';
import 'package:mood_tracker_app/screens/home_screen.dart';

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

  const MoodDialog({required this.onMoodSelected, required this.onNextPressed});

  @override
  _MoodDialogState createState() => _MoodDialogState();
}

class _MoodDialogState extends State<MoodDialog> {
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
          builder: (context) =>
              MoodDetailsPage(selectedMoodScore: selectedMoodScore!));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select a mood first!'),
          backgroundColor: Colors.red));
    }
  }
}

class MoodDetailsPage extends StatefulWidget {
  final int selectedMoodScore;

  const MoodDetailsPage({required this.selectedMoodScore});

  @override
  _MoodDetailsPageState createState() => _MoodDetailsPageState();
}

class _MoodDetailsPageState extends State<MoodDetailsPage> {
  int? selectedMoodScore;
  late int initialMoodScore; // Untuk menyimpan mood awal yang tidak berubah
  String? selectedItem; // Menyimpan item yang dipilih pada mood

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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        NoteScreen(selectedMoodScore: selectedMoodScore!),
                  );
                },
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

  List<String> _getMoodOptions() {
    switch (selectedMoodScore) {
      case 1:
        return ["Depressed", "Anxious", "Angry", "Overwhelmed"];
      case 2:
        return ["Sad", "Tired", "Frustrated", "Disappointed"];
      case 3:
        return ["Okay", "Satisfied", "Hopeful", "Relaxed"];
      case 4:
        return ["Happy", "Excited", "Proud", "Loved"];
      case 5:
        return ["Euphoric", "Inspired", "Grateful", "Accomplished"];
      default:
        return [];
    }
  }

  Widget _buildMoodOption(String label) {
    bool isSelected = selectedItem == label; // Cek apakah item ini dipilih

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItem =
              isSelected ? null : label; // Deselect jika sudah dipilih
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
          label,
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

  NoteScreen({required this.selectedMoodScore});

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
                  _getMoodImagePath(
                      selectedMoodScore), // Gunakan selectedMoodScore yang konsisten
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
                maxLines: null,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type your notes here...",
                    hintStyle: TextStyle(color: Color(0xFFA6A6A6))),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE68C52)),
                    onPressed: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => HomeScreen())),
                    child: Text("Save",
                        style: TextStyle(color: Color(0xFFFFFFFF)))),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE68C52)),
                    onPressed: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => HomeScreen())),
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

  // Helper method to get the correct mood image path
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
