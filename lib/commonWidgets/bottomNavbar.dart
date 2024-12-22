import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool isVolunteer; // Flag to check if user is a volunteer

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.isVolunteer, // Pass the volunteer flag
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor: Colors.blueGrey[50],
      selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      unselectedItemColor: const Color.fromARGB(255, 66, 63, 63),
      selectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      showSelectedLabels: true,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
      items: [
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.bullhorn,
            size: 24,
            color: selectedIndex == 0
                ? const Color.fromARGB(255, 0, 0, 0)
                : const Color.fromARGB(255, 0, 0, 0),
          ),
          label: 'Home Page',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 24,
            color: selectedIndex == 1
                ? const Color.fromARGB(255, 0, 0, 0)
                : const Color.fromARGB(255, 0, 0, 0),
          ),
          label: 'Upcoming Events',
        ),
        // Show "Pending Volunteers" only if the user is not a volunteer
        if (!isVolunteer)
          BottomNavigationBarItem(
            icon: Icon(
              Icons.pending_actions,
              size: 24,
              color: selectedIndex == 2
                  ? const Color.fromARGB(255, 8, 8, 8)
                  : const Color.fromARGB(255, 0, 0, 0),
            ),
            label: 'Pending Volunteers',
          ),
      ],
    );
  }
}
