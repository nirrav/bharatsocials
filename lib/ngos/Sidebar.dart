import 'package:bharatsocials/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SlideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.person, color: Colors.white, size: 50),
                SizedBox(height: 8),
                Text(
                  'Hello, User!',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  'user@example.com',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          // Drawer Items
          ListTile(
            leading: Icon(Icons.home, color: Colors.black),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close drawer on tap
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.black),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.black),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.black),
            title: Text('About'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Log Out'),
            onTap: () async {
              try {
                // Sign out the user from Firebase Authentication
                await FirebaseAuth.instance.signOut();

                // Clear SharedPreferences to remove login state and user email
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                await prefs.remove('email'); // Optionally remove user email

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
                        LoginPage(), // Replace with your actual LoginPage
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
