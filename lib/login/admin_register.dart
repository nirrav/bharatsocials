import 'package:bharatsocials/login/home.dart';
import 'package:bharatsocials/login/widgets/upload_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/login/widgets/dot_indicator.dart';
import 'package:bharatsocials/login/widgets/submit_button.dart';
import 'package:bharatsocials/login/widgets/text_field_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bharatsocials/login/widgets/password_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'dart:io'; // For File handling
import 'package:image_picker/image_picker.dart'; // For Image picking

class AdminRegisterPage extends StatefulWidget {
  @override
  _AdminRegisterPageState createState() => _AdminRegisterPageState();
}

class _AdminRegisterPageState extends State<AdminRegisterPage> {
  // Controllers for the input fields
  TextEditingController adminNameController = TextEditingController();
  TextEditingController collegeFieldController = TextEditingController();
  TextEditingController universityFieldController = TextEditingController();
  TextEditingController adminEmailController = TextEditingController();
  TextEditingController adminPhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _isTermsAgreed = false;
  String selectedRole = 'College Admin'; // Default role
  bool _isPasswordVisible = false; // Manage password visibility
  bool _isConfirmPasswordVisible = false; // Manage confirm password visibility
  String passwordStrength = 'weak'; // Default password strength
  File? _identityProof; // To hold the identity proof image

  @override
  void dispose() {
    adminNameController.dispose();
    collegeFieldController.dispose();
    universityFieldController.dispose();
    adminEmailController.dispose();
    adminPhoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Password strength check
  String checkPasswordStrength(String password) {
    if (password.length < 6) {
      return 'weak';
    } else if (password.length >= 6 && password.length < 10) {
      return 'medium';
    } else {
      return 'strong';
    }
  }

  // Callback to handle password changes and update strength
  void _onPasswordChanged(String password) {
    setState(() {
      passwordStrength = checkPasswordStrength(password);
    });
  }

  // Method for image picker (Proof of Identity)
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _identityProof = File(pickedFile.path);
      });
    }
  }

  // Submit method for saving data to Firestore
  Future<void> _onSubmit() async {
    // Validate fields
    if (adminNameController.text.isEmpty ||
        adminEmailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all required fields.")),
      );
      return;
    }

    // Check if password and confirm password match
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match.")),
      );
      return;
    }

    // Check password strength
    if (passwordStrength == 'weak') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password is too weak.")),
      );
      return;
    }

    try {
      // Firebase Authentication - Register the admin user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: adminEmailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Upload Proof of Identity (if exists) to Firebase Storage
      String? fileUrl;
      if (_identityProof != null) {
        // Upload image to Firebase Storage
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('proof_of_identity/${userCredential.user!.uid}');
        UploadTask uploadTask = storageReference.putFile(_identityProof!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
        fileUrl = await taskSnapshot.ref.getDownloadURL(); // Get download URL
      }

      // Create the data map to be sent to Firestore
      Map<String, dynamic> adminData = {
        'admin_name': adminNameController.text.trim(),
        'admin_email': adminEmailController.text.trim(),
        'admin_phone': adminPhoneController.text.trim(),
        'role': 'admin',
        'admin_role': selectedRole,
        'isVerified': false,
        'profile_picture': fileUrl, // Add the image URL from Firebase Storage
      };

      // Add college or university-specific data based on the selected role
      if (selectedRole == 'College Admin') {
        adminData['college_name'] = collegeFieldController.text.trim();
      } else if (selectedRole == 'University Admin') {
        adminData['university_name'] = universityFieldController.text.trim();
      }

      // Store data in Firestore under 'admins' collection
      await FirebaseFirestore.instance.collection('admins').add(adminData);
      print("Admin registered successfully");

      // Navigate to HomePage after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Color backgroundColor = AppColors.getBackgroundColor(context);
    Color textColor = AppColors.getTextColor(context);
    Color buttonColor = AppColors.getButtonColor(context);
    Color buttonTextColor = AppColors.getButtonTextColor(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DotIndicator(isActive: false, isDarkMode: isDarkMode),
                        _buildConnectingLine(),
                        DotIndicator(isActive: true, isDarkMode: isDarkMode),
                        _buildConnectingLine(),
                        DotIndicator(isActive: false, isDarkMode: isDarkMode),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin Registration',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth > 600 ? 30 : 26,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Title for Admin Role Selection
                        Text(
                          'Admin Role',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth > 600 ? 18 : 16,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Buttons for selecting College Admin or University Admin
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedRole == 'College Admin'
                                    ? buttonColor
                                    : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedRole = 'College Admin';
                                });
                              },
                              child: Text(
                                'College Admin',
                                style: TextStyle(
                                  color: buttonTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    selectedRole == 'University Admin'
                                        ? buttonColor
                                        : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedRole = 'University Admin';
                                });
                              },
                              child: Text(
                                'University Admin',
                                style: TextStyle(
                                  color: buttonTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Admin-specific fields
                        TextFieldWidget(
                          label: 'First Name',
                          controller: adminNameController,
                          isDarkMode: isDarkMode,
                        ),
                        TextFieldWidget(
                          label: 'Email',
                          controller: adminEmailController,
                          isDarkMode: isDarkMode,
                        ),
                        TextFieldWidget(
                          label: 'Contact Number',
                          controller: adminPhoneController,
                          isDarkMode: isDarkMode,
                        ),
                        PasswordFieldWidget(
                          label: 'Password',
                          isDarkMode: isDarkMode,
                          controller: passwordController,
                          showStrengthIndicator: true,
                          isPasswordVisible: _isPasswordVisible,
                          togglePasswordVisibility: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          passwordStrength: passwordStrength,
                          onPasswordChanged: _onPasswordChanged,
                        ),
                        PasswordFieldWidget(
                          label: 'Confirm Password',
                          isDarkMode: isDarkMode,
                          controller: confirmPasswordController,
                          showStrengthIndicator: false,
                          isPasswordVisible: _isConfirmPasswordVisible,
                          togglePasswordVisibility: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                          passwordStrength: '',
                          onPasswordChanged: (_) {},
                        ),

                        if (selectedRole == 'College Admin') ...[
                          TextFieldWidget(
                            label: 'College Name',
                            controller: collegeFieldController,
                            isDarkMode: isDarkMode,
                          ),
                        ],
                        if (selectedRole == 'University Admin') ...[
                          TextFieldWidget(
                            label: 'University Name',
                            controller: universityFieldController,
                            isDarkMode: isDarkMode,
                          ),
                        ],

                        SizedBox(height: 20),

                        // Upload Proof Of Identity
                        UploadButtonWidget(
                          label: 'Proof Of Identity (Upload ID Card)',
                          isDarkMode: isDarkMode,
                          onTap: _pickImage,
                        ),

                        // Terms and Conditions checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: _isTermsAgreed,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isTermsAgreed = value ?? false;
                                });
                              },
                              activeColor: buttonColor,
                            ),
                            Expanded(
                              child: Text(
                                'I Agree To Terms and Conditions',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth > 600 ? 16 : 14,
                                  color: textColor,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // You can implement a T&C dialog or redirect here
                              },
                              child: Text(
                                '(READ T&C)',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth > 600 ? 16 : 14,
                                  color: buttonColor,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Submit Button
                        SizedBox(height: screenHeight * 0.05),
                        SubmitButtonWidget(
                          isTermsAgreed: _isTermsAgreed,
                          onSubmit: _onSubmit,
                          selectedRole: selectedRole,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create a connecting line
  Widget _buildConnectingLine() {
    return Container(
      width: 80,
      height: 2,
      color: Colors.grey,
    );
  }
}
