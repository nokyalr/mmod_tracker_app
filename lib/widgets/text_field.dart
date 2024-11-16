import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String prefixIconPath;
  final bool obscureText;
  final bool showVisibilityIcon;
  final bool isPasswordVisible;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSuffixIconPressed;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIconPath,
    this.obscureText = false,
    this.showVisibilityIcon = true,
    this.isPasswordVisible = false,
    this.onSuffixIconPressed,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText && !isPasswordVisible,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            prefixIconPath,
            width: 24,
            color: const Color(0xFFA6A6A6),
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFA6A6A6), fontSize: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE68C52)),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE68C52)),
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: showVisibilityIcon
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFFA6A6A6),
                ),
                onPressed: onSuffixIconPressed,
              )
            : null,
      ),
    );
  }
}
