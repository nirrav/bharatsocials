import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bharatsocials/T&C.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/login/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bharatsocials/api/register_method.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bharatsocials/login/admin_register.dart';
import 'package:bharatsocials/commonWidgets/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required String role});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
// Declare controllers for all the fields
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();

  TextEditingController phoneNoController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController collegeNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  List<String> collegeNames = [];

// Controllers for NGO form
  TextEditingController organizationNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  String passwordStrength = "";
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isTermsAgreed = false;
  bool _isLoading = false;
  String selectedRole = '';
  File? _image; // Variable to hold the selected image
  @override
  void dispose() {
    // Dispose all controllers
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();

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
    _fetchCollegeNames();

    Future.delayed(Duration.zero, () {
      _showRoleSelectionDialog();
    });
  }

  void _fetchCollegeNames() async {
    try {
      // Query the 'users' collection with 'adminRole' == 'college' and 'collegeName' not null
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('adminRole', isEqualTo: 'college') // Filter for colleges
          .where('collegeName',
              isNotEqualTo: null) // Ensure collegeName is not null
          .get(); // Fetch the data

      // Extract college names from the query snapshot
      List<String> collegeList =
          snapshot.docs.map((doc) => doc['collegeName'] as String).toList();

      // Update the state with the college names list
      setState(() {
        collegeNames =
            collegeList; // Assign the list to the collegeNames state variable
      });
    } catch (e) {
      print('Error fetching college names: $e');
    }
  }

  void _showRoleSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return RoleSelectionDialog(
          onRoleSelected: (role) {
            setState(() {
              selectedRole = role; // Update the selected role
            });
            Navigator.of(context).pop(); // Close the dialog

            // Redirect based on role selection
            if (role == 'admin') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminRegisterPage(),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RegistrationPage(role: role),
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

    return Scaffold(
      backgroundColor: AppColors.appBgColor(context),
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
                        color: AppColors.defualtTextColor(context),
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
                          activeColor: AppColors.mainButtonColor(context),
                        ),
                        Expanded(
                          child: Text(
                            'I Agree To Term And Condition',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth > 600 ? 16 : 14,
                              color: AppColors.defualtTextColor(context),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                             Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TermsAndConditions()), // Notification page
              );
                          },
                          child: Text(
                            '(READ T&C)',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth > 600 ? 16 : 14,
                              color: AppColors.defualtTextColor(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    if (_isLoading)
                      Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mainButtonColor(
                              context), // You can customize the color
                        ),
                      ),
                    SizedBox(height: screenHeight * 0.05),
                    SubmitButtonWidget(
                      isTermsAgreed: _isTermsAgreed,
                      selectedRole: selectedRole,
                      onSubmit: _onRegister, // Pass the _onSubmit function here
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

  void _onRegister() {
    RegistrationHelper(
      context: context,
      isTermsAgreed: _isTermsAgreed,
      image: _image,
      isFormValid: _isFormValid,
      showErrorSnackbar: _showErrorSnackbar,
      clearFormFields: _clearFormFields,
      emailController: emailController,
      passwordController: passwordController,
      selectedRole: selectedRole,
      firstNameController: firstNameController,
      phoneNoController: phoneNoController,
      rollNoController: rollNoController,
      departmentController: departmentController,
      collegeNameController: collegeNameController,
      organizationNameController: organizationNameController,
      contactNumberController: contactNumberController,
      cityController: cityController,
    ).onRegister();
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
          label: 'Full Name',
          controller: firstNameController,
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
        _buildCollegeNameDropdown(isDarkMode),
        TextFieldWidget(
          label: 'Department',
          controller: departmentController,
          isDarkMode: isDarkMode,
        ),
        TextFieldWidget(
          label: 'Roll Number',
          controller: rollNoController,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildCollegeNameDropdown(bool isDarkMode) {
    if (collegeNames.isEmpty) {
      return const Text("No colleges found");
    }

    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        // Show suggestions only when the user starts typing
        if (textEditingValue.text.isEmpty) {
          return [];
        }
        // Return filtered college names based on user input
        return collegeNames.where((college) {
          return college
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        }).toList();
      },
      onSelected: (String selectedCollege) {
        // Set the selected college name in the controller
        collegeNameController.text = selectedCollege;
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return Column(
          children: [
            TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'College Name',
                labelStyle: TextStyle(
                  color: AppColors.defualtTextColor(context),
                  height: 1.5,
                ),
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.getLineColor(context),
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.getLineColor(context),
                  ),
                ),
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        );
      },
    );
  }

  Widget _buildNgoForm(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldWidget(
          label: 'NGO Name',
          controller: organizationNameController,
          isDarkMode: isDarkMode,
        ),
        TextFieldWidget(
          label: 'NGO Email',
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
