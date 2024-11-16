import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;

  const ConfirmButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 135,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFE68C52),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
