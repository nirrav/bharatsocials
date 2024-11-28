import 'package:flutter/material.dart';
import 'package:bharatsocials/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class Logout {
  // This method handles the logout process
  static Future<void> logout(BuildContext context) async {
    try {
      // Sign out the user using Firebase Auth
      await FirebaseAuth.instance.signOut();

      // Optionally, you can show a snackbar or a message indicating successful logout
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have been logged out successfully")),
      );

      // Redirect the user to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const LoginPage()), // Navigate to the Login page
      );
    } catch (e) {
      // Handle any errors that might occur during the logout process
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred while logging out")),
      );
    }
  }
}
