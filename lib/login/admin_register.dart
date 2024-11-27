import 'dart:io'; // For File handling
import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/login/home.dart';
import 'package:bharatsocials/login/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bharatsocials/login/widgets/dot_indicator.dart';
import 'package:bharatsocials/login/widgets/submit_button.dart';
import 'package:bharatsocials/login/widgets/text_field_widget.dart';
import 'package:image_picker/image_picker.dart'; // For Image picking
import 'package:bharatsocials/login/widgets/upload_button_widget.dart';
import 'package:bharatsocials/login/widgets/password_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage

class AdminRegisterPage extends StatefulWidget {
  const AdminRegisterPage({super.key});

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
  String selectedRole = 'college'; // Default role
  bool _isPasswordVisible = false; // Manage password visibility
  bool _isConfirmPasswordVisible = false; // Manage confirm password visibility
  String passwordStrength = 'weak'; // Default password strength
  File? _identityProof; // To hold the identity proof image
  File? _image; // Variable to hold the selected image
  bool _isLoading = false; // Track the loading state

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

// Function to handle the image selected in the UploadButtonWidget
  void _onImageSelected(File? image) {
    setState(() {
      _image = image; // Update the selected image
    });
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

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      print("Image picked: Path: ${_image?.path}");
    } else {
      print("No image selected from gallery.");
    }
  }

  Future<void> _onRegister() async {
    setState(() {
      _isLoading = true; // Show loader when submitting
    });

    // Check if proof of identity (image) is provided
    if (_image == null) {
      _showErrorSnackbar('Please upload a proof of identity.');
      setState(() {
        _isLoading = false; // Hide loader after error
      });
      return;
    }

    // Validate fields (same validation logic as before)
    if (adminNameController.text.isEmpty ||
        adminEmailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields.")),
      );
      setState(() {
        _isLoading = false; // Hide loader after error
      });
      return;
    }

    // Check if password and confirm password match (same validation)
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match.")),
      );
      setState(() {
        _isLoading = false; // Hide loader after error
      });
      return;
    }

    // Check password strength (same validation)
    if (passwordStrength == 'weak') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password is too weak.")),
      );
      setState(() {
        _isLoading = false; // Hide loader after error
      });
      return;
    }

    try {
      // Firebase Authentication - Register the admin user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: adminEmailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Image upload to Firebase Storage
      String imageUrl = '';
      if (_image != null) {
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
        try {
          UploadTask uploadTask = FirebaseStorage.instance
              .ref('${selectedRole.toLowerCase()}s/$fileName')
              .putFile(_image!);

          TaskSnapshot snapshot = await uploadTask;
          imageUrl = await snapshot.ref.getDownloadURL();
          print("Image uploaded successfully. Download URL: $imageUrl");
        } catch (e) {
          print("Error during image upload: $e");
          _showErrorSnackbar('Error uploading image.');
          setState(() {
            _isLoading = false; // Hide loader after error
          });
          return;
        }
      }

      // Create the data map to be sent to Firestore
      Map<String, dynamic> adminData = {
        'name': adminNameController.text.trim(),
        'email': adminEmailController.text.trim(),
        'phone': adminPhoneController.text.trim(),
        'role': 'admin', // Always set to admin
        'adminRole': selectedRole,
        'isVerified': false,
        'POIurl': imageUrl,
      };

      // Add role-specific data (same logic as before)
      if (selectedRole == 'college') {
        adminData['collegeName'] = collegeFieldController.text.trim();
      } else if (selectedRole == 'uni') {
        adminData['uniName'] = universityFieldController.text.trim();
      }

      // Store data in Firestore under 'admins' collection
      await FirebaseFirestore.instance.collection('admins').add(adminData);
      print("Admin registered successfully");

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loader after the operation completes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Color backgroundColor = AppColors.appBgColor(context);
    Color textColor = AppColors.defualtTextColor(context);
    Color buttonColor = AppColors.mainButtonColor(context);
    Color buttonTextColor = AppColors.mainButtonTextColor(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                backgroundColor: selectedRole == 'college'
                                    ? buttonColor
                                    : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedRole = 'college';
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
                            const SizedBox(width: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedRole == 'uni'
                                    ? buttonColor
                                    : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedRole = 'uni';
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
                          label: 'Full Name',
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

                        if (selectedRole == 'college') ...[
                          TextFieldWidget(
                            label: 'College Name',
                            controller: collegeFieldController,
                            isDarkMode: isDarkMode,
                          ),
                        ],
                        if (selectedRole == 'uni') ...[
                          TextFieldWidget(
                            label: 'University Name',
                            controller: universityFieldController,
                            isDarkMode: isDarkMode,
                          ),
                        ],

                        const SizedBox(height: 20),

                        // Upload Proof Of Identity
                        UploadButtonWidget(
                          label: selectedRole == 'NGO'
                              ? 'Proof Of Identity (Upload Government ID)'
                              : 'Proof Of Identity (Upload ID Card)',
                          isDarkMode: isDarkMode,
                          onImageSelected:
                              _onImageSelected, // Pass callback here
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
                        _isLoading // Show loader if _isLoading is true
                            ? Center(
                                child: CircularProgressIndicator(
                                  color:
                                      buttonColor, // Customize color if needed
                                ),
                              )
                            : SubmitButtonWidget(
                                isTermsAgreed: _isTermsAgreed,
                                selectedRole: selectedRole,
                                onSubmit: _onRegister,
                              ),
                        const SizedBox(height: 20),
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

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
