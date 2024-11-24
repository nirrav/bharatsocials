import 'package:bharatsocials/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bharatsocials/login/userData.dart';

class SlideBar extends StatelessWidget {
  const SlideBar({super.key});

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
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.person, color: Colors.white, size: 50),
                const SizedBox(height: 8),
                Text(
                  'Hello, ${currentUser?.organizationName ?? 'User'}!', // Show user's first name if available
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  currentUser?.email ??
                      'user@example.com', // Show user's email if available
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          // Drawer Items
          ListTile(
            leading: const Icon(Icons.home, color: Colors.black),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close drawer on tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.black),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.black),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.black),
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

                // Optionally clear any other relevant data if necessary
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
                        const LoginPage(), // Replace with your actual LoginPage
                  ),
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
