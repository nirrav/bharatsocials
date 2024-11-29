import 'dart:async';
import 'package:bharatsocials/volunteers/volDashboard.dart';
import 'package:flutter/material.dart';
import 'package:bharatsocials/login/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bharatsocials/ngos/ngoDashboard.dart';
import 'package:bharatsocials/admins/UniAdmin/uniDashboard.dart';
import 'package:bharatsocials/admins/CollegeAdmin/caDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Timer to check login state and navigate after a delay
    Timer(const Duration(seconds: 3), () {
      _checkLoginStatus();
    });

    // Set up the animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _opacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Start the animation
    _animationController.forward();
  }

  // Check if the user is logged in
  void _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // If not logged in, navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const HomePage()), // LoginPage or wherever your login screen is
      );
    } else {
      // If logged in, navigate based on user role
      _navigateToHomeScreen(user);
    }
  }

  // Navigate to the correct screen based on user role
  void _navigateToHomeScreen(User user) async {
    String role = '';
    String? adminRole;

    try {
      // Check if the user is a volunteer
      final volunteerSnapshot = await FirebaseFirestore.instance
          .collection('volunteers')
          .where('email', isEqualTo: user.email)
          .get();

      if (volunteerSnapshot.docs.isNotEmpty) {
        role = 'volunteer';
      } else {
        // Check if the user is an NGO
        final ngoSnapshot = await FirebaseFirestore.instance
            .collection('ngos')
            .where('email', isEqualTo: user.email)
            .get();

        if (ngoSnapshot.docs.isNotEmpty) {
          role = 'ngo';
        } else {
          // Check if the user is an admin
          final adminSnapshot = await FirebaseFirestore.instance
              .collection('admins')
              .where('email', isEqualTo: user.email)
              .get();

          if (adminSnapshot.docs.isNotEmpty) {
            role = 'admin';
            DocumentSnapshot userDoc = adminSnapshot.docs.first;
            adminRole = userDoc['adminRole'];
          }
        }
      }

      // Navigate based on the role
      onSuccess(role, adminRole);
    } catch (e) {
      // Handle any errors here (network, permission, etc.)
      print('Error fetching user data: $e');
      // Optionally, show an error message or navigate to an error screen
    }
  }

  // Navigate to the specific screen based on role and admin role
  void onSuccess(String role, String? adminRole) {
    if (role == 'volunteer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VolunteerDashboard()),
      );
    } else if (role == 'ngo') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NgoDashboard()),
      );
    } else if (role == 'admin') {
      if (adminRole == 'uni') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UniAdminDashboard()),
        );
      } else if (adminRole == 'college') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CaDashboardScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Bharat Socials',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 150,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[700],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
