import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:bharatsocials/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class RegistrationHelper {
  final BuildContext context;
  final bool isTermsAgreed;
  final dynamic image;
  final bool Function() isFormValid;
  final Function(String) showErrorSnackbar;
  final Function() clearFormFields;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String selectedRole;
  final TextEditingController firstNameController;
  final TextEditingController phoneNoController;
  final TextEditingController rollNoController;
  final TextEditingController departmentController;
  final TextEditingController collegeNameController;
  final TextEditingController organizationNameController;
  final TextEditingController contactNumberController;
  final TextEditingController cityController;

  bool _isLoading = false;

  RegistrationHelper({
    required this.context,
    required this.isTermsAgreed,
    required this.image,
    required this.isFormValid,
    required this.showErrorSnackbar,
    required this.clearFormFields,
    required this.emailController,
    required this.passwordController,
    required this.selectedRole,
    required this.firstNameController,
    required this.phoneNoController,
    required this.rollNoController,
    required this.departmentController,
    required this.collegeNameController,
    required this.organizationNameController,
    required this.contactNumberController,
    required this.cityController,
  });

  void onRegister() async {
    setLoadingState(true);

    // Helper function to handle error and stop loading
    void handleError(String message) {
      showErrorSnackbar(message);
      setLoadingState(false);
    }

    // Check if terms and conditions are agreed
    if (!isTermsAgreed)
      return handleError('Please agree to the terms and conditions.');

    // Check if proof of identity (image) is provided
    if (image == null) return handleError('Please upload a proof of identity.');

    // Check form validity
    if (!isFormValid())
      return handleError('Please fill all required fields correctly.');

    try {
      // Firebase Authentication (signup)
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Generate FCM token
      String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      print("FCM Token generated: $fcmToken");

      // Image upload to Firebase Storage (if image is provided)
      String imageUrl = '';
      if (image != null) {
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
        try {
          UploadTask uploadTask = FirebaseStorage.instance
              .ref('users/images/$fileName')
              .putFile(image);
          TaskSnapshot snapshot = await uploadTask;
          imageUrl = await snapshot.ref.getDownloadURL();
          print("Image uploaded successfully. Download URL: $imageUrl");
        } catch (e) {
          print("Error during image upload: $e");
          return handleError('Error uploading image.');
        }
      }

      // Prepare the user data
      Map<String, dynamic> userData = {
        'email': emailController.text,
        'fcmToken': fcmToken,
        'image': imageUrl,
        'isVerified': false,
        'role': selectedRole, // Use the role field to differentiate users
      };

      // Add role-specific data to userData
      if (selectedRole == 'volunteer') {
        userData.addAll({
          'name': firstNameController.text,
          'phone': phoneNoController.text,
          'rollno': rollNoController.text,
          'department': departmentController.text,
          'collegeName': collegeNameController.text,
        });
      } else if (selectedRole == 'ngo') {
        userData.addAll({
          'name': organizationNameController.text,
          'phone': contactNumberController.text,
          'city': cityController.text,
        });
      }

      // Store data in a single 'users' collection instead of multiple collections
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set(userData);

      // Navigate to the Login Page and show success message
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginPage()));

      // Show success snackbar after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text("You've registered successfully. Now, please login.")));
      });

      // Clear the form fields
      clearFormFields();
    } catch (e) {
      print("Error occurred during form submission: ${e.toString()}");
      handleError('Error: ${e.toString()}');
    } finally {
      // Stop loading when all processes are complete
      setLoadingState(false);
    }
  }

  // Helper method to handle loading state
  void setLoadingState(bool state) {
    _isLoading = state;
    // If the loading state changes, trigger a UI update in the calling widget
    (context as Element).markNeedsBuild();
  }
}

class AdminRegistrationHelper {
  final BuildContext context;
  final bool isLoading;
  final bool Function() isFormValid;
  final Function(String) showErrorSnackbar;
  final Function() clearFormFields;
  final dynamic image;
  final TextEditingController adminNameController;
  final TextEditingController adminEmailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController adminPhoneController;
  final String passwordStrength;
  final String selectedRole;
  final TextEditingController collegeFieldController;
  final TextEditingController universityFieldController;

  AdminRegistrationHelper({
    required this.context,
    required this.isLoading,
    required this.isFormValid,
    required this.showErrorSnackbar,
    required this.clearFormFields,
    required this.image,
    required this.adminNameController,
    required this.adminEmailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.adminPhoneController,
    required this.passwordStrength,
    required this.selectedRole,
    required this.collegeFieldController,
    required this.universityFieldController,
  });

  Future<void> onAdminRegister() async {
    // Start loading
    setLoadingState(true);

    // Helper function to handle error and stop loading
    void handleError(String message) {
      showErrorSnackbar(message);
      setLoadingState(false);
    }

    // Check if proof of identity (image) is provided
    if (image == null) {
      return handleError('Please upload a proof of identity.');
    }

    // Validate fields
    if (adminNameController.text.isEmpty ||
        adminEmailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      return handleError('Please fill in all required fields.');
    }

    // Check if password and confirm password match
    if (passwordController.text != confirmPasswordController.text) {
      return handleError('Passwords do not match.');
    }

    // Check password strength
    if (passwordStrength == 'weak') {
      return handleError('Password is too weak.');
    }

    try {
      // Firebase Authentication - Register the admin user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: adminEmailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Generate FCM token
      String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      print("FCM Token generated: $fcmToken");

      // Image upload to Firebase Storage
      String imageUrl = '';
      if (image != null) {
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
        try {
          UploadTask uploadTask = FirebaseStorage.instance.ref('admins/images/$fileName').putFile(image);
          TaskSnapshot snapshot = await uploadTask;
          imageUrl = await snapshot.ref.getDownloadURL();
          print("Image uploaded successfully. Download URL: $imageUrl");
        } catch (e) {
          print("Error during image upload: $e");
          return handleError('Error uploading image.');
        }
      }

      // Create the user data for Firestore in the 'users' collection
      Map<String, dynamic> userData = {
        'name': adminNameController.text.trim(),
        'email': adminEmailController.text.trim(),
        'phone': adminPhoneController.text.trim(),
        'role': 'admin', // Always set to admin
        'isVerified': false,
        'fcmToken': fcmToken,
        'POIurl': imageUrl,
      };

      // Add role-specific data (same logic as before)
      if (selectedRole == 'college') {
        userData['collegeName'] = collegeFieldController.text.trim();
        userData['adminRole'] = 'college'; // Set admin role to 'college'
      } else if (selectedRole == 'uni') {
        userData['uniName'] = universityFieldController.text.trim();
        userData['adminRole'] = 'uni'; // Set admin role to 'uni'
      }

      // Store the user data in the 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set(userData);

      print("Admin and User registered successfully");

      // Navigate to the Login Page after a short delay
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );

      // After a short delay, show the Snackbar
      Future.delayed(const Duration(seconds: 1), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("You've registered successfully. Now, please login.")),
        );
      });
    } catch (e) {
      print("Error occurred during registration: ${e.toString()}");
      handleError('Error: ${e.toString()}');
    } finally {
      setLoadingState(false);
    }
  }

  // Helper method to handle loading state
  void setLoadingState(bool state) {
    // Trigger UI update
    (context as Element).markNeedsBuild();
  }
}
