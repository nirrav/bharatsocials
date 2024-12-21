import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bharatsocials/login/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bharatsocials/ngos/ngoDashboard.dart';
import 'package:bharatsocials/volunteers/volDashboard.dart';
import 'package:bharatsocials/dashboard/dashboardTemplate.dart';
import 'package:bharatsocials/admins/UniAdmin/uniDashboard.dart';
import 'package:bharatsocials/admins/CollegeAdmin/caDashboard.dart';

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
      // Check if the user exists in the 'users' collection and retrieve role
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        var userData = userSnapshot.data();
        if (userData != null) {
          role = userData['role'];
          adminRole = userData['adminRole'];
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
        MaterialPageRoute(builder: (context) => const DashboardTemplate()),
      );
    } else if (role == 'ngo') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardTemplate()),
      );
    } else if (role == 'admin') {
      // Redirect based on admin role
      if (adminRole == 'uni') {
        // If adminRole is 'uni', navigate to UniAdminDashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UniAdminDashboard()),
        );
      } else {
        // For other admin roles, navigate to DashboardTemplate
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardTemplate()),
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
