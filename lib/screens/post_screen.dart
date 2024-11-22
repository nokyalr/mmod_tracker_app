import 'package:flutter/material.dart';
import 'package:mood_tracker_app/widgets/confirm_button.dart';
import 'package:mood_tracker_app/screens/mood_details.dart';

class MoodDialog extends StatefulWidget {
  final Function(int) onMoodSelected;

  const MoodDialog({
    super.key,
    required this.onMoodSelected,
    required Null Function() onNextPressed,
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
              child: ConfirmButton(
                text: "Next",
                onPressed: () {
                  if (selectedMoodScore != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MoodDetailsPage(),
                      ),
                    );
                  } else {
                    // Tampilkan pesan jika mood belum dipilih
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a mood first!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                width: 100,
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
