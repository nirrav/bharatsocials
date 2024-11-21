import 'package:bharatsocials/admins/CollegeAdmin/caDashboard.dart';
import 'package:bharatsocials/admins/UniAdmin/uniDashboard.dart';
import 'package:bharatsocials/login/home.dart';
import 'package:bharatsocials/login/login.dart'; // Import LoginPage
import 'package:bharatsocials/login/userData.dart';
import 'package:bharatsocials/ngos/ngoDashboard.dart';
import 'package:bharatsocials/volunteers/volDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

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

    // Timer to move to the HomeScreen after a delay
    Timer(const Duration(seconds: 3), () async {
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

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? userRole = prefs.getString('userRole');
    String? userDocId = prefs.getString('userDocId');

    if (isLoggedIn && userRole != null && userDocId != null) {
      try {
        DocumentSnapshot userDoc;

        // Fetch user data using document ID
        if (userRole == 'volunteer') {
          userDoc = await FirebaseFirestore.instance
              .collection('volunteers')
              .doc(userDocId)
              .get();
        } else if (userRole == 'ngo') {
          userDoc = await FirebaseFirestore.instance
              .collection('ngos')
              .doc(userDocId)
              .get();
        } else if (userRole == 'admin') {
          userDoc = await FirebaseFirestore.instance
              .collection('admins')
              .doc(userDocId)
              .get();
        } else {
          throw Exception('Unknown user role');
        }

        if (userDoc.exists) {
          // Create the current user instance
          UserData currentUser = UserData.fromFirestore(userDoc);

          // Store the user instance globally
          GlobalUser.currentUser = currentUser;

          // Redirect to the respective dashboard
          if (userRole == 'volunteer') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => VolunteerDashboard()),
            );
          } else if (userRole == 'ngo') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NgoDashboard()),
            );
          } else if (userRole == 'admin') {
            if (currentUser.adminRole == 'uni') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UniDashboard()),
              );
            } else if (currentUser.adminRole == 'college') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CaDashboardScreen()),
              );
            }
          }
        } else {
          throw Exception('User document does not exist');
        }
      } catch (e) {
        // Handle errors (e.g., document not found)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } else {
      // Not logged in, navigate to LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
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
          // Centered logo and text
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
          // Loading bar at the bottom
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
