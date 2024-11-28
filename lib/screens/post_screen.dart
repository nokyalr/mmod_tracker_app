import 'package:flutter/material.dart';
import 'package:mood_tracker_app/screens/home_screen.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: MoodDialog(
          onMoodSelected: (score) {},
          onNextPressed: () {},
        ),
      ),
    ),
  ));
}

class MoodDialog extends StatefulWidget {
  final Function(int) onMoodSelected;
  final VoidCallback onNextPressed;

  const MoodDialog({
    super.key,
    required this.onMoodSelected,
    required this.onNextPressed,
  });

  @override
  State<MoodDialog> createState() => _MoodDialogState();
}

class _MoodDialogState extends State<MoodDialog> {
  DateTime selectedDate = DateTime.now();
  int? selectedMoodScore;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "How are you today?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE68C52),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE68C52)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Color(0xFFE68C52),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMoodImage(context, 'assets/images/bad.png', 1),
                _buildMoodImage(context, 'assets/images/poor.png', 2),
                _buildMoodImage(context, 'assets/images/medium.png', 3),
                _buildMoodImage(context, 'assets/images/good.png', 4),
                _buildMoodImage(context, 'assets/images/excellent.png', 5),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedMoodScore != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MoodDetailsPage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a mood first!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE68C52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodImage(BuildContext context, String imagePath, int score) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMoodScore = score;
          widget.onMoodSelected(score);
        });
      },
      child: Opacity(
        opacity: selectedMoodScore == score ? 1.0 : 0.4,
        child: Image.asset(
          imagePath,
          width: 42,
          height: 42,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}

class MoodDetailsPage extends StatelessWidget {
  const MoodDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  "Isn't anything under control?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _buildMoodOption(
                    context, "assets/images/depression.png", "Depression"),
                _buildMoodOption(
                    context, "assets/images/anxiety (1).png", "Anxiety"),
                _buildMoodOption(
                    context, "assets/images/anxiety.png", "Confused"),
                _buildMoodOption(context, "assets/images/anger.png", "Anger"),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NoteScreen(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildMoodOption(BuildContext context, String imagePath, String label) {
  bool isSelected =
      false; // Status lokal untuk mengetahui apakah gambar dipilih

  return StatefulBuilder(
    builder: (context, setState) {
      return GestureDetector(
        onTap: () {
          setState(() {
            isSelected = !isSelected; // Mengubah status saat gambar diklik
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.orange.withOpacity(0.2)
                    : Colors.transparent, // Warna berubah saat dipilih
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                width: 50,
                height: 50,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.orange),
            ),
          ],
        ),
      );
    },
  );
}

class NoteScreen extends StatelessWidget {
  NoteScreen({super.key});
  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE68C52)),
          onPressed: () {
            Navigator.of(context).pop(); // Navigasi kembali
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE68C52)),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8.0),
                child: const TextField(
                  maxLines: null, // Mendukung input teks multiline
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type your notes here...",
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Logika tombol Save
                    logger.i("Save button pressed!");

                    // Menampilkan pesan dan kembali ke home screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Note successfully saved"),
                      ),
                    );
                    Navigator.of(context)
                      ..push(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      ); // Kembali ke home screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE68C52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 32,
                    ),
                  ),
                  child: const Text(
                    "save",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Logika tombol Share
                    logger.i("Share button pressed!");

                    // Menampilkan pesan dan kembali ke home screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Note successfully shared"),
                      ),
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    ); // Kembali ke home screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE68C52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 32,
                    ),
                  ),
                  child: const Text(
                    "share",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
