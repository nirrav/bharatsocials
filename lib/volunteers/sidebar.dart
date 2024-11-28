import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/volunteers/settings.dart';
import 'package:bharatsocials/volunteers/acheivement.dart';
import 'package:bharatsocials/volunteers/viewProfile.dart';
import 'package:bharatsocials/volunteers/attendedEvent.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bharatsocials/volunteers/volunteerData.dart'; // Import the VolunteerData class

class VolunteerSidebar extends StatefulWidget {
  const VolunteerSidebar({super.key});

  @override
  _VolunteerSidebarState createState() => _VolunteerSidebarState();
}

class _VolunteerSidebarState extends State<VolunteerSidebar> {
  late Future<VolunteerData?> _volunteerDataFuture;

  @override
  void initState() {
    super.initState();
    _volunteerDataFuture =
        VolunteerData.fetchVolunteerData(); // Trigger data fetch
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VolunteerData?>(
      future: _volunteerDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No Data Found'));
        }

        VolunteerData volunteerData = snapshot.data!;

        return Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDrawerHeader(context, volunteerData),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildMenuItem(
                      context: context,
                      icon: Icons.person,
                      title: 'View Profile',
                      onTap: () =>
                          _navigateTo(context, const ViewProfilePage()),
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.event,
                      title: 'Attended Events',
                      onTap: () =>
                          _navigateTo(context, const AttendedEventPage()),
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.emoji_events,
                      title: 'Achievements',
                      onTap: () =>
                          _navigateTo(context, const AchievementPage()),
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () => _navigateTo(context, const SettingsPage()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerHeader(BuildContext context, VolunteerData volunteerData) {
    String userName = volunteerData.name;
    String userEmail = volunteerData.email;

    return DrawerHeader(
      decoration: BoxDecoration(
        color: AppColors.appBgColor(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.appBgColor(context),
            child: Icon(
              FontAwesomeIcons.user,
              size: 40,
              color: AppColors.iconColor(context),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userName,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.defualtTextColor(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: AppColors.defualtTextColor(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.iconColor(context),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.defualtTextColor(context),
        ),
      ),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
