import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool useImage;
  final String imagePath;
  final double imageHeight;
  final Widget? userScreen;
  final String titleText;
  final Color textColor;
  final Color? imageColor;
  final bool useBorder;
  final Color backgroundColor;

  const CustomAppBar({
    super.key,
    required this.useImage,
    required this.imagePath,
    required this.imageHeight,
    this.userScreen,
    required this.titleText,
    required this.textColor,
    this.imageColor,
    this.useBorder = true,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      toolbarHeight: 50.0,
      shape: useBorder
          ? Border(
              bottom: BorderSide(
                color: Color(0xFFE68C52).withOpacity(0.5),
                width: 2.0,
              ),
            )
          : null,
      title: Row(
        children: [
          if (useImage)
            GestureDetector(
              onTap: () {
                if (userScreen != null) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          userScreen!,
                      transitionDuration: Duration.zero,
                    ),
                  );
                }
              },
              child: Image.asset(
                imagePath,
                height: imageHeight,
                color: imageColor,
              ),
            ),
          if (useImage) const SizedBox(width: 10),
          Text(
            titleText,
            style: TextStyle(
              fontSize: 18,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}
