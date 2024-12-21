import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor:
          Colors.blueGrey[50],  // Deep purple background for the BottomNavBar
      selectedItemColor: const Color.fromARGB(255, 0, 0, 0), // White color for selected item
      unselectedItemColor:
          const Color.fromARGB(255, 66, 63, 63), // Lighter color for unselected items
      selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14), // Bold and slightly larger font for selected labels
      showSelectedLabels: true,
      showUnselectedLabels: true, // Show both selected and unselected labels
      type: BottomNavigationBarType.fixed, // Keep a consistent height
      elevation: 10, // Add a subtle shadow to make it pop
      items: [
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.bullhorn,
            size: 24, // Set the size of the icon
            color: selectedIndex == 0
                ? const Color.fromARGB(255, 0, 0, 0)
                : const Color.fromARGB(255, 0, 0, 0), // Dynamic icon color
          ),
          label: 'Current Campaigns',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 24, // Set the size of the icon
            color: selectedIndex == 1
                ? const Color.fromARGB(255, 0, 0, 0)
                : const Color.fromARGB(255, 0, 0, 0), // Dynamic icon color
          ),
          label: 'Upcoming Campaigns',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.pending_actions,
            size: 24, // Set the size of the icon
            color: selectedIndex == 2
                ? const Color.fromARGB(255, 8, 8, 8)
                : const Color.fromARGB(255, 0, 0, 0), // Dynamic icon color
          ),
          label: 'Pending Volunteers',
        ),
      ],
    );
  }
}
