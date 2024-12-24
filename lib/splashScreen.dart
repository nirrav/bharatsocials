import 'package:flutter/material.dart';
import 'package:bharatsocials/login/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bharatsocials/dashboard/dashboardTemplate.dart';
import 'package:bharatsocials/admins/UniAdmin/uniDashboard.dart';

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

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _opacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();

    // Print a debug statement to ensure splash screen logic is working
    print("SplashScreen is initialized, checking login...");

    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // If not logged in, navigate to login screen
      print("User not logged in, navigating to HomePage...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // If logged in, navigate based on user role
      print("User logged in, checking role...");
      await _navigateToHomeScreen(user);
    }
  }

  Future<void> _navigateToHomeScreen(User user) async {
    try {
      String role = '';
      String? adminRole;

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

      print("User role is: $role");

      // Navigate based on the role
      if (mounted) {
        onSuccess(role, adminRole);
      }
    } catch (e) {
      print("Error fetching user data: $e");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  void onSuccess(String role, String? adminRole) {
    print("Navigating based on user role...");
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
      if (adminRole == 'uni') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UniAdminDashboard()),
        );
      } else {
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
