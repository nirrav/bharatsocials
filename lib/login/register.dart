import 'dart:io';
import 'package:bharatsocials/login/admin_register.dart';
import 'package:bharatsocials/login/home.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/login/login.dart';
import 'package:bharatsocials/login/widgets/dot_indicator.dart';
import 'package:bharatsocials/login/widgets/password_field_widget.dart';
import 'package:bharatsocials/login/widgets/upload_button_widget.dart';
import 'package:bharatsocials/login/widgets/text_field_widget.dart';
import 'package:bharatsocials/login/widgets/submit_button.dart';
import 'package:bharatsocials/login/widgets/role_selection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Controllers for the input fields
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController collegeNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String passwordStrength = "";
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _isTermsAgreed = false;

  String selectedRole = '';
  File? _image; // Variable to hold the selected image

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    phoneNoController.dispose();
    rollNoController.dispose();
    departmentController.dispose();
    collegeNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // Password strength checking logic
  void _checkPasswordStrength(String password) {
    if (password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password)) {
      setState(() {
        passwordStrength = "strong";
      });
    } else if (password.length >= 6) {
      setState(() {
        passwordStrength = "medium";
      });
    } else {
      setState(() {
        passwordStrength = "weak";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showRoleSelectionDialog();
    });
  }

  // Show dialog for role selection
  void _showRoleSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissal by tapping outside
      builder: (BuildContext context) {
        return RoleSelectionDialog(
          onRoleSelected: (role) {
            setState(() {
              selectedRole = role; // Update the selected role
            });
            Navigator.of(context).pop(); // Close the dialog after selection

            // Redirect based on role selection
            if (role == 'Admin') {
              // If the user selects 'Admin', navigate to the Admin registration page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AdminRegisterPage(), // Admin registration page
                ),
              );
            }
          },
        );
      },
    );
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

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REGISTER',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth > 600 ? 30 : 26,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    if (selectedRole == 'Volunteer')
                      _buildVolunteerForm(isDarkMode),
                    if (selectedRole == 'NGO') _buildNgoForm(isDarkMode),
                    PasswordFieldWidget(
                      label: 'Create A Password',
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
                      onPasswordChanged: (value) {
                        _checkPasswordStrength(value);
                      },
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
                      passwordStrength: "",
                      onPasswordChanged: (value) {},
                    ),
                    UploadButtonWidget(
                      label: selectedRole == 'NGO'
                          ? 'Proof Of Identity (Upload Government ID)'
                          : 'Proof Of Identity (Upload ID Card)',
                      isDarkMode: isDarkMode,
                      onTap: _pickImage,
                    ),
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
                            'I Agree To Term And Condition',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth > 600 ? 16 : 14,
                              color: textColor,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
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
                    SizedBox(height: screenHeight * 0.05),
                    SubmitButtonWidget(
                      isTermsAgreed: _isTermsAgreed,
                      onSubmit: _onSubmit,
                      selectedRole: selectedRole,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  void _onSubmit() async {
    // Check if terms and conditions are agreed
    if (!_isTermsAgreed) {
      _showErrorSnackbar('Please agree to the terms and conditions.');
      return;
    }

    // Check form validity
    if (!_isFormValid()) {
      _showErrorSnackbar('Please fill all required fields correctly.');
      return; // Don't proceed further if form is invalid
    }

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

      // Image upload to Firebase Storage
      String imageUrl = '';
      if (_image != null) {
        print("Starting image upload...");

        String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
        try {
          print("Uploading image with file name: $fileName");
          UploadTask uploadTask = FirebaseStorage.instance
              .ref('${selectedRole.toLowerCase()}s/$fileName')
              .putFile(_image!);

          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            print(
                'Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
          });

          TaskSnapshot snapshot = await uploadTask;
          imageUrl = await snapshot.ref.getDownloadURL();
          print("Image uploaded successfully. Download URL: $imageUrl");
        } catch (e) {
          print("Error during image upload: $e");
          _showErrorSnackbar('Error uploading image.');
          return;
        }
      } else {
        print("No image selected. Skipping image upload.");
      }

      // Firestore data save
      Map<String, dynamic> userData = {
        'first_name': firstNameController.text,
        'middle_name': middleNameController.text,
        'last_name': lastNameController.text,
        'email': emailController.text,
        'phone': phoneNoController.text,
        'role': selectedRole,
        'image': imageUrl,
        'isVerified': false,
        'fcmToken': fcmToken, // Store the FCM token
      };

      if (selectedRole == 'Volunteer') {
        userData.addAll({
          'roll_no': rollNoController.text,
          'department': departmentController.text,
          'college_name': collegeNameController.text,
        });
        await FirebaseFirestore.instance.collection('volunteers').add(userData);
      } else if (selectedRole == 'NGO') {
        userData.addAll({
          'organization_name':
              firstNameController.text, // Organization name for NGOs
          'contact_number': phoneNoController.text, // Contact number for NGOs
          'city': collegeNameController.text, // City for NGOs
        });
        await FirebaseFirestore.instance.collection('ngos').add(userData);
      }

      // Navigate to the next page only after successful data saving
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage(userRole: 'role')),
      );

      // Clear all the form fields after successful submission
      _clearFormFields();
    } catch (e) {
      print("Error occurred during form submission: ${e.toString()}");
      _showErrorSnackbar('Error: ${e.toString()}');
    }
  }

  void _requestPermissions() async {
    PermissionStatus status = await Permission.storage.request();
    print("Storage permission status: $status");
    if (status.isGranted) {
      _pickImage();
    } else {
      print("Permission to access storage denied.");
    }
  }

  void _clearFormFields() {
    // Clear all text fields
    firstNameController.clear();
    middleNameController.clear();
    lastNameController.clear();
    phoneNoController.clear();
    rollNoController.clear();
    departmentController.clear();
    collegeNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    // Reset other fields
    setState(() {
      _isTermsAgreed = false; // Uncheck the terms and conditions checkbox
      selectedRole = ''; // Reset selected role
      _image = null; // Reset selected image
    });

    print("Form fields cleared.");
  }

  bool _isFormValid() {
    // Common validation for all roles
    if (firstNameController.text.isEmpty) {
      print("First name is empty.");
      return false;
    }

    // Skip last name validation if the selected role is 'NGO'
    if (selectedRole != 'NGO' && lastNameController.text.isEmpty) {
      print("Last name is empty.");
      return false;
    }

    if (phoneNoController.text.isEmpty) {
      print("Phone number is empty.");
      return false;
    }

    if (emailController.text.isEmpty) {
      print("Email is empty.");
      return false;
    }

    if (passwordController.text.isEmpty) {
      print("Password is empty.");
      return false;
    }

    if (confirmPasswordController.text.isEmpty) {
      print("Confirm password is empty.");
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      print("Passwords do not match.");
      return false;
    }

    // Role-specific validation
    if (selectedRole == 'Volunteer') {
      if (rollNoController.text.isEmpty) {
        print("Roll number is empty for Volunteer.");
        return false;
      }
      if (departmentController.text.isEmpty) {
        print("Department is empty for Volunteer.");
        return false;
      }
      if (collegeNameController.text.isEmpty) {
        print("College name is empty for Volunteer.");
        return false;
      }
    }

    if (selectedRole == 'NGO') {
      if (collegeNameController.text.isEmpty) {
        print("City is empty for NGO.");
        return false;
      }
      if (firstNameController.text.isEmpty) {
        print("Organization name is empty for NGO.");
        return false;
      }
    }

    print("Form is valid.");
    return true;
  }

  // bool _isFormValid() {
  //   // Add form validation logic
  //   return firstNameController.text.isNotEmpty &&
  //       emailController.text.isNotEmpty &&
  //       passwordController.text == confirmPasswordController.text &&
  //       phoneNoController.text.isNotEmpty &&
  //       (selectedRole == 'NGO' ? true : rollNoController.text.isNotEmpty);
  // }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildVolunteerForm(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldWidget(
          label: 'First Name',
          controller: firstNameController,
          isDarkMode: isDarkMode,
        ),
        TextFieldWidget(
          label: 'Middle Name',
          controller: middleNameController,
          isDarkMode: isDarkMode,
        ),
        TextFieldWidget(
          label: 'Last Name',
          controller: lastNameController,
          isDarkMode: isDarkMode,
        ),
        TextFieldWidget(
          label: 'Email',
          controller: emailController,
          isDarkMode: isDarkMode,
        ),
        TextFieldWidget(
          label: 'Phone Number',
          controller: phoneNoController,
          isDarkMode: isDarkMode,
        ),
        TextFieldWidget(
          label: 'Roll Number',
          controller: rollNoController,
          isDarkMode: isDarkMode,
        ),
        TextFieldWidget(
          label: 'Department',
          controller: departmentController,
          isDarkMode: isDarkMode,
        ),
        TextFieldWidget(
          label: 'College Name',
          controller: collegeNameController,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildNgoForm(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldWidget(
          label: 'Organization Name',
          controller: firstNameController,
          isDarkMode: isDarkMode,
        ),
        TextFieldWidget(
          label: 'Organization Email',
          controller: emailController,
          isDarkMode: isDarkMode,
        ),
        TextFieldWidget(
          label: 'Contact Number',
          controller: phoneNoController,
          isDarkMode: isDarkMode,
        ),
        TextFieldWidget(
          label: 'City',
          controller: collegeNameController,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildConnectingLine() {
    return Container(
      height: 1,
      width: 50,
      color: Colors.grey,
    );
  }
}
