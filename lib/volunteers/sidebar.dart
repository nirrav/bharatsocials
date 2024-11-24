import 'package:bharatsocials/login/userData.dart';
import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/volunteers/settings.dart';
import 'package:bharatsocials/volunteers/acheivement.dart';
import 'package:bharatsocials/volunteers/viewProfile.dart';
import 'package:bharatsocials/volunteers/attendedEvent.dart';

class VolunteerSidebar extends StatelessWidget {
  const VolunteerSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure that you're using the color scheme from AppColors
    Color defaultTextColor = AppColors.defualtTextColor(context);
    Color iconColor = AppColors.iconColor(context);

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDrawerHeader(
              context), // Pass context to the header for color use
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
  Widget _buildDrawerHeader(BuildContext context) {
    String userName = 'User Name'; // Default username

    // Check if the current user is a volunteer and use their first name if available
    if (GlobalUser.currentUser?.role == 'volunteer') {
      userName = GlobalUser.currentUser?.firstName ?? 'User Name';
    }

    // Get user image if available
    String userImage = GlobalUser.currentUser?.image ?? '';

    return DrawerHeader(
      decoration: BoxDecoration(
        color: AppColors.titleColor(context), // Use AppColors for background
      ),
      child: Row(
        children: [
          // Profile Picture with fallback if not available
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.appBgColor(context),
            backgroundImage: userImage.isNotEmpty
                ? NetworkImage(userImage)
                : null, // Display image if available
            child: userImage.isEmpty
                ? const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.black, // Icon color from AppColors
                  )
                : null, // Show default icon if no image available
          ),
          const SizedBox(width: 16),
          // Display the first name or default username
          Text(
            userName, // Display the first name if the user is a volunteer
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.defualtTextColor(
                  context), // Text color from AppColors
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
      leading: Icon(
        icon,
        color: AppColors.iconColor(context), // Icon color from AppColors
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color:
              AppColors.defualtTextColor(context), // Text color from AppColors
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
