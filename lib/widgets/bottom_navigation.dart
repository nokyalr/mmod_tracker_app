import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE68C52).withOpacity(0.3),
            width: 1.0,
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: onItemTapped,
        items: <BottomNavigationBarItem>[
          _buildNavItem('Home', 'assets/images/home.png', 0),
          _buildNavItem('Report', 'assets/images/calender.png', 1),
          _buildNavItem('Suggestion', 'assets/images/idea.png', 2),
          _buildNavItem('User', 'assets/images/user2.png', 3),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      String label, String assetPath, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        decoration: BoxDecoration(
          color: index == selectedIndex
              ? const Color(0xFFE68C52).withOpacity(0.2)
              : Colors.transparent,
          border: index == selectedIndex
              ? Border.all(
                  color: const Color(0xFFE68C52),
                  width: 1.0,
                )
              : null,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(5.0),
        child: Image.asset(
          assetPath,
          height: 32,
        ),
      ),
      label: label,
    );
  }
}
