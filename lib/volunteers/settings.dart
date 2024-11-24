import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bharatsocials/volunteers/volDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get theme-dependent colors using the AppColors utility
    Color backgroundColor = AppColors.appBgColor(context);
    Color textColor = AppColors.defualtTextColor(context);
    Color buttonColor = AppColors.mainButtonColor(context);
    Color buttonTextColor = AppColors.mainButtonTextColor(context);

    // Get screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VolunteerDashboard()),
            );
          },
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Theme'),
            onTap: () {
              // Add navigation to Theme settings here
            },
          ),
          ListTile(
            title: const Text('Report Bug'),
            onTap: () {
              // Add navigation to Report Bug page here
            },
          ),
          ListTile(
            title: const Text('Contact Us'),
            onTap: () {
              // Add navigation to Contact Us page here
            },
          ),
          ListTile(
            title: const Text('Log Out'),
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
