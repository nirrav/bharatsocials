import 'package:bharatsocials/login/home.dart';
import 'package:bharatsocials/login/register.dart';
import 'package:bharatsocials/ngos/ngoDashboard.dart';
import 'package:bharatsocials/volunteers/volDashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/colors.dart';
import 'widgets/text_field_widget.dart';
import 'widgets/password_field_widget.dart';
import 'widgets/dot_indicator.dart';
import 'widgets/login_button.dart';

class LoginPage extends StatefulWidget {
  final String userRole; // Add a field to store the role

  const LoginPage({super.key, required this.userRole});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
      body: WillPopScope(
        // Wrap the Scaffold with WillPopScope to handle back press
        onWillPop: () async {
          // Handle back navigation and send the user to HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          return false; // Prevent the default back navigation
        },
        child: SafeArea(
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
                      DotIndicator(isActive: false, isDarkMode: isDarkMode),
                      _buildConnectingLine(),
                      DotIndicator(isActive: true, isDarkMode: isDarkMode),
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
                        'LOGIN',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth > 600 ? 30 : 26,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Enter your details to log in to your account',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth > 600 ? 16 : 14,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      TextFieldWidget(
                        label: 'Email',
                        controller: emailController,
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      PasswordFieldWidget(
                        label: 'Password',
                        isDarkMode: isDarkMode,
                        controller: passwordController,
                        showStrengthIndicator: false,
                        isPasswordVisible: _isPasswordVisible,
                        togglePasswordVisibility: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        passwordStrength: "",
                        onPasswordChanged: (value) {},
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Handle forget password
                          },
                          child: Text(
                            'Forget Password?',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth > 600 ? 16 : 14,
                              color: buttonColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      LoginButton(
                        onPressed: _onSubmit,
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
    );
  }

  void _onSubmit() {
    // Print the user role passed from the RegistrationPage
    print("User Role: ${widget.userRole}");

    // Proceed with login logic
    String email = emailController.text;
    String password = passwordController.text;

    // Validate email and password (basic validation example)
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    // Simulate login logic (this can be replaced with real authentication)
    print("Login Submitted");

    // Navigate based on the user role
    if (widget.userRole == 'Volunteer') {
      // Navigate to Volunteer Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VolunteerDashboard()),
      );
    } else if (widget.userRole == 'NGO') {
      // Navigate to NGO Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NGODashboard()),
      );
    } else if (widget.userRole == 'Admin') {
      // Navigate to Admin Dashboard (or placeholder for Admin)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Placeholder()),
      );
    } else {
      // If no role or an unknown role is passed, show a placeholder or error
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegistrationPage()),
      );
    }
  }

  Widget _buildConnectingLine() {
    return Container(
      width: 80,
      height: 2,
      color: Colors.grey,
    );
  }
}
