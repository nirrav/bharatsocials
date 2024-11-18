import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/login/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/login/widgets/role_selection.dart'; // Ensure correct import
import 'widgets/password_field_widget.dart'; // Updated password field widget
import 'widgets/upload_button_widget.dart';
import 'widgets/text_field_widget.dart'; // Import your TextField widget
import 'widgets/dot_indicator.dart'; // Assuming DotIndicator is another custom widget

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
  TextEditingController emailController = TextEditingController();

  String passwordStrength = "";
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // New boolean variable to track checkbox state
  bool _isTermsAgreed = false;

  String selectedRole = ''; // Store the selected role

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

  // Show role selection dialog
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
      builder: (BuildContext context) {
        return RoleSelectionDialog(
          onRoleSelected: (role) {
            setState(() {
              selectedRole = role; // Update the selected role
            });
            print('Selected Role: $role');
            Navigator.of(context).pop(); // Close the dialog after selection
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

    // Replace hardcoded colors with AppColors methods
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

                    // Show different form fields based on the selected role
                    if (selectedRole == 'Volunteer')
                      _buildVolunteerForm(isDarkMode),
                    if (selectedRole == 'NGO') _buildNgoForm(isDarkMode),
                    if (selectedRole == 'Admin') _buildAdminForm(isDarkMode),
                    // Password Field
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
                        _checkPasswordStrength(
                            value); // Update strength on change
                      },
                    ),

                    // Confirm Password Field (No strength indicator)
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

                    // Upload Proof Of Identity
                    UploadButtonWidget(
                      label: 'Proof Of Identity (Upload ID Card)',
                      isDarkMode: isDarkMode,
                    ),

                    // Terms and Conditions checkbox (Now functional)
                    Row(
                      children: [
                        Checkbox(
                          value:
                              _isTermsAgreed, // Checkbox state bound to this variable
                          onChanged: (bool? value) {
                            setState(() {
                              _isTermsAgreed =
                                  value ?? false; // Update checkbox state
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

                    // Submit Button using the new SubmitButtonWidget
                    SizedBox(height: screenHeight * 0.05),
                    SubmitButtonWidget(
                      isTermsAgreed: _isTermsAgreed, // Pass the checkbox value
                      onSubmit: _onSubmit,
                      selectedRole: selectedRole, // Pass the selected role here
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

  void _onSubmit() {
    // Proceed with registration
    print("Registration Submitted");
  }

  Widget _buildConnectingLine() {
    return Container(
      width: 80,
      height: 2,
      color: Colors.grey,
    );
  }

  // Role-specific forms (simplified examples)
  Widget _buildVolunteerForm(bool isDarkMode) {
    return Column(
      children: [
        TextFieldWidget(
          label: 'Volunteer Specific Field',
          controller: firstNameController,
          isDarkMode: isDarkMode, // Pass isDarkMode here
        ),
      ],
    );
  }

  Widget _buildNgoForm(bool isDarkMode) {
    return Column(
      children: [
        TextFieldWidget(
          label: 'NGO Specific Field',
          controller: firstNameController,
          isDarkMode: isDarkMode, // Pass isDarkMode here
        ),
      ],
    );
  }

  Widget _buildAdminForm(bool isDarkMode) {
    return Column(
      children: [
        TextFieldWidget(
          label: 'Admin Specific Field',
          controller: firstNameController,
          isDarkMode: isDarkMode, // Pass isDarkMode here
        ),
      ],
    );
  }
}
