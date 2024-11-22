import 'package:flutter/material.dart';
import 'package:mood_tracker_app/screens/note_screen.dart';

class MoodDetailsPage extends StatefulWidget {
  const MoodDetailsPage({Key? key}) : super(key: key);

  @override
  _MoodDetailsPageState createState() => _MoodDetailsPageState();
}

class _MoodDetailsPageState extends State<MoodDetailsPage> {
  // Menyimpan status warna yang dipilih (terklik atau tidak)
  final Map<String, bool> _selectedMoods = {
    "depression": false,
    "anxiety_1": false,
    "anxiety": false,
    "anger": false,
  };

  // Deskripsi untuk setiap mood
  final Map<String, String> _moodDescriptions = {
    "depression": "Feeling sad and down. Lack of energy.",
    "anxiety_1": "Feeling nervous or anxious.",
    "anxiety": "Feeling restless and worried.",
    "anger": "Feeling frustrated or angry.",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE68C52)),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text(
              "Isn't anything under control?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE68C52),
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildMoodOption(
                    context, "assets/images/depression.png", "depression"),
                _buildMoodOption(
                    context, "assets/images/anxiety (1).png", "anxiety_1"),
                _buildMoodOption(
                    context, "assets/images/anxiety.png", "anxiety"),
                _buildMoodOption(context, "assets/images/anger.png", "anger"),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Menavigasi ke halaman NoteScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoteScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE68C52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
              ),
              child: const Text(
                "Next",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk menampilkan opsi mood dengan warna latar belakang yang berubah saat dipilih
  Widget _buildMoodOption(
      BuildContext context, String imagePath, String moodKey) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMoods[moodKey] =
              !_selectedMoods[moodKey]!; // Toggle selection
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _selectedMoods[moodKey]!
              ? Colors.orange.withOpacity(0.3)
              : Colors.transparent, // Menambahkan warna redup saat dipilih
          border: Border.all(color: const Color(0xFFE68C52)),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menampilkan gambar hanya jika mood belum dipilih
            if (!_selectedMoods[moodKey]!)
              Image.asset(
                imagePath,
                width: 50,
                height: 50,
              ),
            // Menampilkan deskripsi jika mood dipilih
            if (_selectedMoods[moodKey]!)
              Text(
                _moodDescriptions[moodKey]!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
