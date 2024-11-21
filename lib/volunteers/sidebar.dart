import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/volunteers/settings.dart';
import 'package:bharatsocials/volunteers/acheivement.dart';
import 'package:bharatsocials/volunteers/viewProfile.dart';
import 'package:bharatsocials/volunteers/attendedEvent.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDrawerHeader(),
          const Divider(color: Colors.grey), // Divider for separation
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  context: context,
                  icon: Icons.person,
                  title: 'View Profile',
                  onTap: () => _navigateTo(context, ViewProfilePage()),
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.event,
                  title: 'Attended Events',
                  onTap: () => _navigateTo(context, AttendedEventPage()),
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.emoji_events,
                  title: 'Achievements',
                  onTap: () => _navigateTo(context, const AchievementPage()),
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () => _navigateTo(context, SettingsPage()),
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.info,
                  title: 'Dummy Button', // Dummy button for demonstration
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dummy Button Pressed!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Drawer Header Widget
  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.black26, // Header background color
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.black12, // Icon color
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'User Name', // Placeholder for user name
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Text color
            ),
          ),
        ],
      ),
    );
  }

  // Menu Item Widget
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black), // Icon color
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black // Text color
        ),
      ),
      onTap: onTap,
    );
  }

  // Navigation Helper
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
