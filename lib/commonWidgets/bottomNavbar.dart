import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool isVolunteer;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.isVolunteer,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        if (isVolunteer && index == 1) {
          onItemTapped(3); // Map Saved Events to the correct index
        } else {
          onItemTapped(index);
        }
      },
      backgroundColor: AppColors.titleColor(context),
      selectedItemColor: const Color.fromARGB(255, 8, 0, 0),
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
            FontAwesomeIcons.house,
            size: 24,
            color: AppColors.titleTextColor(context),
          ),
          label: 'Home',
        ),
        if (!isVolunteer)
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.solidClock,
              size: 24,
              color: AppColors.titleTextColor(context),
            ),
            label: 'Current Campaigns',
          ),
        if (!isVolunteer)
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.bullhorn,
              size: 24,
              color: AppColors.titleTextColor(context),
            ),
            label: 'Pending Volunteers',
          ),
        if (isVolunteer)
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.solidBookmark,
              size: 24,
              color: AppColors.titleTextColor(context),
            ),
            label: 'Saved Events',
          ),
      ],
    );
  }
}
