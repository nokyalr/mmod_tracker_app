import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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
