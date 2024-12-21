import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bharatsocials/ngos/ngoDashboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bharatsocials/volunteers/volDashboard.dart';
import 'package:bharatsocials/dashboard/dashboardTemplate.dart';
import 'package:bharatsocials/admins/UniAdmin/uniDashboard.dart';
import 'package:bharatsocials/admins/CollegeAdmin/caDashboard.dart';

class LoginHelper {
  final BuildContext context;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final Function(bool) setLoading;
  final Function(String) showSnackBar;

  LoginHelper({
    required this.context,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.setLoading,
    required this.showSnackBar,
  });

  Future<void> onLogin() async {
    try {
      setLoading(true);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _navigateToHomeScreen(user);
      }

      setLoading(false);
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      showSnackBar(e.message ?? 'Login failed');
    }
  }

  Future<void> _navigateToHomeScreen(User user) async {
    String role = '';
    String? adminRole;

    try {
      // Retrieve the role from Firestore based on user UID
      final roleDoc = await _getUserRole(user);
      role = roleDoc['role'];
      adminRole = roleDoc['adminRole'];

      // Update FCM token
      await _updateFcmToken(user);

      // Navigate based on role
      _navigateBasedOnRole(role, adminRole);
    } catch (e) {
      print('Error checking user role: $e');
    }
  }

  Future<Map<String, dynamic>> _getUserRole(User user) async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid) // Get the document based on UID, not email
        .get();

    if (userSnapshot.exists) {
      var userData = userSnapshot.data();
      if (userData != null) {
        return {
          'role': userData['role'],
          'adminRole': userData['adminRole'],
        };
      }
    }

    throw Exception('User role not found');
  }

  Future<void> _updateFcmToken(User user) async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null && user.email != null) {
        // Use a batch to update the FCM token in the 'users' collection
        WriteBatch batch = FirebaseFirestore.instance.batch();

        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          batch.update(userSnapshot.reference, {'fcmToken': fcmToken});
        }

        await batch.commit();
        print('FCM Token updated');
      }
    } catch (e) {
      print('Error updating FCM token: $e');
    }
  }

  // Function to navigate based on role
  void _navigateBasedOnRole(String role, String? adminRole) {
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
      } else if (adminRole == 'college') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardTemplate()),
        );
      }
    }
  }
}
