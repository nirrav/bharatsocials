import 'dart:io'; // For File handling
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bharatsocials/T&C.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/login/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bharatsocials/api/register_method.dart';
import 'package:bharatsocials/commonWidgets/widgets.dart';

class AdminRegisterPage extends StatefulWidget {
  const AdminRegisterPage({super.key});

  @override
  _AdminRegisterPageState createState() => _AdminRegisterPageState();
}

class TextFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isDarkMode;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const TextFieldWidget({
    Key? key,
    required this.label,
    required this.controller,
    required this.isDarkMode,
    this.inputFormatters,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
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
  final bool _isLoading = false; // Track the loading state

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

  bool _isFormValid() {
    // Check that no field is empty and validate the password & confirm password
    return adminNameController.text.isNotEmpty &&
        adminEmailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        // _isPasswordValid() && // Ensure password validity
        _isPasswordsMatch(); // Ensure passwords match
  }

// Check if the password is valid
// bool _isPasswordValid() {
//   final String passwordRegex = r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:\'",<>\./?\\|`~]).{8,}$';
//   final RegExp regex = RegExp(passwordRegex);

//   // Make sure all the parentheses and curly braces are correctly closed
// }

// Check if the passwords match
  bool _isPasswordsMatch() {
    // Compare password and confirm password
    return passwordController.text == confirmPasswordController.text;
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearFormFields() {
    adminNameController.clear();
    adminEmailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    adminPhoneController.clear();
    collegeFieldController.clear();
    universityFieldController.clear();
  }

  void _onAdminRegister() {
    AdminRegistrationHelper(
      context: context,
      isLoading: _isLoading,
      isFormValid: _isFormValid,
      showErrorSnackbar: _showErrorSnackbar,
      clearFormFields: _clearFormFields,
      image: _image,
      adminNameController: adminNameController,
      adminEmailController: adminEmailController,
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
      adminPhoneController: adminPhoneController,
      passwordStrength: passwordStrength,
      selectedRole: selectedRole,
      collegeFieldController: collegeFieldController,
      universityFieldController: universityFieldController,
    ).onAdminRegister();
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Register as Admin',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
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
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(
                                r'[a-zA-Z\s]')), // Allow only alphabetic characters and spaces
                            // LengthLimitingTextInputFormatter(10), // Limit input length to 10 characters
                          ],
                        ),

                        TextFieldWidget(
                          label: 'Email',
                          controller: adminEmailController,
                          isDarkMode: isDarkMode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!value.contains('@')) {
                              return 'Email must contain "@"';
                            }
                            if (!value.endsWith('.com')) {
                              return 'Email must end with ".com"';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(
                                r'[a-zA-Z0-9@.]')), // Only allow alphanumeric characters, @ and .
                          ],
                        ),
                        TextFieldWidget(
                          label: 'Contact Number',
                          controller: adminPhoneController,
                          isDarkMode: isDarkMode,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Restrict input to digits only
                            LengthLimitingTextInputFormatter(10),
                          ],
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TermsAndConditions()),
                                );
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
                                onSubmit: _onAdminRegister,
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

  // Helper method to create a connecting line
  Widget _buildConnectingLine() {
    return Container(
      width: 80,
      height: 2,
      color: Colors.grey,
    );
  }
}
