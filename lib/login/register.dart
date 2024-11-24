import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/login/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bharatsocials/login/admin_register.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bharatsocials/login/widgets/dot_indicator.dart';
import 'package:bharatsocials/login/widgets/submit_button.dart';
import 'package:bharatsocials/login/widgets/role_selection.dart';
import 'package:bharatsocials/login/widgets/text_field_widget.dart';
import 'package:bharatsocials/login/widgets/upload_button_widget.dart';
import 'package:bharatsocials/login/widgets/password_field_widget.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
// Declare controllers for all the fields
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

// Controllers for NGO form
  TextEditingController organizationNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  String passwordStrength = "";
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _isTermsAgreed = false;

  String selectedRole = '';
  File? _image; // Variable to hold the selected image
  @override
  void dispose() {
    // Dispose all controllers
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
    organizationNameController.dispose();
    contactNumberController.dispose();
    cityController.dispose();

    super.dispose();
  }

  // Function to handle the image selected in the UploadButtonWidget
  void _onImageSelected(File? image) {
    setState(() {
      _image = image; // Update the selected image
    });
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

  void _showRoleSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Allow dismissal by tapping outside
      builder: (BuildContext context) {
        return RoleSelectionDialog(
          onRoleSelected: (role) {
            setState(() {
              selectedRole = role; // Update the selected role
            });
            Navigator.of(context).pop(); // Close the dialog after selection

            // Debugging log to ensure the selected role is being updated
            print("Role selected: $selectedRole");

            // Redirect based on role selection
            if (role == 'admin') {
              // If the user selects 'Admin', navigate to the Admin registration page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const AdminRegisterPage(), // Admin registration page
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

    Color backgroundColor = AppColors.appBgColor(context);
    Color textColor = AppColors.defualtTextColor(context);
    Color buttonColor = AppColors.mainButtonColor(context);
    Color buttonTextColor = AppColors.mainButtonTextColor(context);

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
                    // Add debugging print statements for role
                    if (selectedRole == 'volunteer')
                      _buildVolunteerForm(isDarkMode),
                    if (selectedRole == 'ngo') _buildNgoForm(isDarkMode),
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
                      label: selectedRole == 'ngo'
                          ? 'Proof Of Identity (Upload Government ID)'
                          : 'Proof Of Identity (Upload ID Card)',
                      isDarkMode: isDarkMode,
                      onImageSelected: _onImageSelected, // Pass callback here
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
                      selectedRole: selectedRole,
                      onSubmit: _onSubmit, // Pass the _onSubmit function here
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

    // Check if proof of identity (image) is provided
    if (_image == null) {
      _showErrorSnackbar('Please upload a proof of identity.');
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
          return;
        }
      }

      // Firestore data save
      Map<String, dynamic> userData = {
        'email': emailController.text,
        'image': imageUrl,
        'isVerified': false,
        'fcmToken': fcmToken, // Store the FCM token
      };

      // Store user data based on the role
      if (selectedRole == 'volunteer') {
        userData.addAll({
          'first_name': firstNameController.text,
          'middle_name': middleNameController.text,
          'last_name': lastNameController.text,
          'phone': phoneNoController.text,
          'roll_no': rollNoController.text,
          'department': departmentController.text,
          'college_name': collegeNameController.text,
          'role': "volunteer",
        });
        await FirebaseFirestore.instance.collection('volunteers').add(userData);
      } else if (selectedRole == 'ngo') {
        userData.addAll({
          'organization_name': organizationNameController.text,
          'contact_number': contactNumberController.text,
          'city': cityController.text,
          'role': "ngo",
        });
        await FirebaseFirestore.instance.collection('ngos').add(userData);
      }

      // Navigate to the Login Page first
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) =>
                const LoginPage()), // Adjust the LoginPage constructor if necessary
      );

      // After a short delay, show the Snackbar
      Future.delayed(const Duration(seconds: 1), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("You've registered successfully. Now, please login.")),
        );
      });

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

    // Reset NGO form fields
    organizationNameController.clear();
    contactNumberController.clear();
    cityController.clear();

    // Reset other fields
    setState(() {
      _isTermsAgreed = false; // Uncheck the terms and conditions checkbox
      selectedRole = ''; // Reset selected role
      _image = null; // Reset selected image
    });

    print("Form fields cleared.");
  }

  bool _isFormValid() {
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
    if (selectedRole == 'volunteer') {
      // Volunteer specific validation
      if (firstNameController.text.isEmpty) {
        print("First name is empty for Volunteer.");
        return false;
      }
      if (lastNameController.text.isEmpty) {
        print("Last name is empty for Volunteer.");
        return false;
      }
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

    if (selectedRole == 'ngo') {
      // NGO specific validation
      if (organizationNameController.text.isEmpty) {
        print("Organization name is empty for NGO.");
        return false;
      }
      if (contactNumberController.text.isEmpty) {
        print("Contact number is empty for NGO.");
        return false;
      }
      if (cityController.text.isEmpty) {
        print("City is empty for NGO.");
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
          controller: organizationNameController,
          isDarkMode: isDarkMode,
        ),
        TextFieldWidget(
          label: 'Organization Email',
          controller: emailController,
          isDarkMode: isDarkMode,
        ),
        TextFieldWidget(
          label: 'Contact Number',
          controller: contactNumberController,
          isDarkMode: isDarkMode,
        ),
        TextFieldWidget(
          label: 'City',
          controller: cityController,
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
