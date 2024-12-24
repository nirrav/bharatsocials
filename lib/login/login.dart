import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/login/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/api/login_method.dart';
import 'package:bharatsocials/commonWidgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Do not check login status automatically; user must log in manually
  }

  // Function to show snackbars
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Handle login
  void _onLogin() {
    LoginHelper(
      context: context,
      emailController: emailController,
      passwordController: passwordController,
      isLoading: _isLoading,
      setLoading: (bool isLoading) {
        setState(() {
          _isLoading = isLoading;
        });
      },
      showSnackBar: _showSnackBar,
    ).onLogin();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.appBgColor(context),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          return false;
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
                          color: AppColors.defualtTextColor(context),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Enter your details to log in to your account',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth > 600 ? 16 : 14,
                          color: AppColors.defualtTextColor(context),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      TextFieldWidget(
                        label: 'Email',
                        controller: emailController,
                        isDarkMode: isDarkMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          // Check if the email contains '@' and '.com'
                          if (!value.contains('@') || !value.contains('.com')) {
                            return 'Email must contain "@" and ".com"';
                          }
                          return null;
                        },
                        inputFormatters: const [
                          // FilteringTextInputFormatter.,
                          // LengthLimitingTextInputFormatter(10),
                        ],
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
                              color: AppColors.subTextColor(context),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      _isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.defualtTextColor(context)),
                            )
                          : LoginButton(
                              onPressed: _onLogin,
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

  Widget _buildConnectingLine() {
    return Container(
      width: 80,
      height: 2,
      color: Colors.grey,
    );
  }
}
