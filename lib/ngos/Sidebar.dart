import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bharatsocials/login/userData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NgoSlideBar extends StatelessWidget {
  const NgoSlideBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the user data is available (GlobalUser.currentUser)
    final currentUser = GlobalUser.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.UpcomingeventCardBgColor(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.person,
                    color: AppColors.iconColor(context), size: 50),
                const SizedBox(height: 8),
                Text(
                  'Hello, ${currentUser?.organizationName ?? 'User'}!', // Show user's first name if available
                  style: TextStyle(
                      color: AppColors.iconColor(context), fontSize: 18),
                ),
                Text(
                  currentUser?.email ??
                      'user@example.com', // Show user's email if available
                  style: TextStyle(
                      color: AppColors.iconColor(context), fontSize: 14),
                ),
              ],
            ),
          ),
          // Drawer Items
          ListTile(
            leading: Icon(Icons.home, color: AppColors.iconColor(context)),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close drawer on tap
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: AppColors.iconColor(context)),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: AppColors.iconColor(context)),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: AppColors.iconColor(context)),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Log Out'),
            onTap: () async {
              try {
                // Sign out the user from Firebase Authentication
                await FirebaseAuth.instance.signOut();

                // Clear login-related data from SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('isLoggedIn');
                await prefs.remove('userRole');
                await prefs.remove('userDocId');
                await prefs.remove('email');

                // Show a message that the user has logged out
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('You have logged out successfully')),
                );

                // Redirect to the LoginPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const LoginPage()), // Redirect to LoginPage
                );
              } catch (e) {
                // Handle any errors during logout
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error logging out: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
