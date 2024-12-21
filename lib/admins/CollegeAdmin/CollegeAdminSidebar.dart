import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/commonWidgets/widgets.dart';
import 'package:bharatsocials/admins/UniAdmin/Unisettings.dart';
import 'package:bharatsocials/admins/CollegeAdmin/ColProfile.dart';
import 'package:bharatsocials/admins/CollegeAdmin/collegeAdminData.dart';


class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    // Use FutureBuilder to fetch admin data from Firestore
    return FutureBuilder<AdminData?>(
      future: AdminData.fetchAdminData(), // Fetch admin data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the data is being fetched, show a loading spinner
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // If an error occurs while fetching data, show an error message
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          // If no data is returned, show a message
          return const Center(child: Text('No data available'));
        } else {
          // If data is fetched successfully, use the data to display the sidebar
          AdminData adminData =
              snapshot.data!; // Admin data fetched from Firestore
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Drawer Header
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.appBgColor(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.person,
                          color: AppColors.iconColor(context), size: 50),
                      const SizedBox(height: 8),
                      Text(
                        'Hello, ${adminData.name}!', // Show fetched user's name
                        style: TextStyle(
                            color: AppColors.iconColor(context), fontSize: 18),
                      ),
                      Text(
                        adminData.email, // Show fetched user's email
                        style: TextStyle(
                            color: AppColors.iconColor(context), fontSize: 14),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading:
                      Icon(Icons.person, color: AppColors.iconColor(context)),
                  title: const Text('View Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const CollegeProfileScreen()), // Notification page
                    );
                  },
                ),
                ListTile(
                  leading:
                      Icon(Icons.settings, color: AppColors.iconColor(context)),
                  title: const Text('Settings'),
                  onTap: () {
                     Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const Unisettings()), // Notification page
              );
                  },
                ),
                ListTile(
                  leading:
                      Icon(Icons.info, color: AppColors.iconColor(context)),
                  title: const Text('About'),
                  onTap: () {
                   Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const Placeholder()), // Notification page
              );
                  },
                ),
                ListTile(
                  title: const Text('Log Out'),
                  onTap: () {
                    // Use the Logout class to handle the logout
                    Logout.logout(context);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
