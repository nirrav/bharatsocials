import 'widgets/login_button.dart';
import 'widgets/dot_indicator.dart';
import 'package:flutter/material.dart';
import 'widgets/text_field_widget.dart';
import 'package:bharatsocials/colors.dart';
import 'widgets/password_field_widget.dart';
import 'package:bharatsocials/login/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bharatsocials/ngos/ngoDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bharatsocials/volunteers/volDashboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'userData.dart'; // Import the UserData class to use it
import 'package:bharatsocials/admins/UniAdmin/uniDashboard.dart';
import 'package:bharatsocials/admins/CollegeAdmin/caDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Add a state variable for loading
  UserData? _currentUser;

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

    Color backgroundColor = AppColors.appBgColor(context);
    Color textColor = AppColors.defualtTextColor(context);
    Color buttonColor = AppColors.mainButtonColor(context);
    Color subtext = AppColors.subTextColor(context);
    Color buttonTextColor = AppColors.mainButtonTextColor(context);

    return Scaffold(
      backgroundColor: backgroundColor,
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
                              color: subtext,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      _isLoading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(buttonColor),
                            ) // Show the loading spinner when _isLoading is true
                          : LoginButton(
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

  void _onSubmit() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false; // Stop loading
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    try {
      // Sign in with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Store the login state in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', email);

      QuerySnapshot snapshot;
      String userRole = '';

      // Query for volunteer
      snapshot = await FirebaseFirestore.instance
          .collection('volunteers')
          .where('email', isEqualTo: email)
          .get();
      if (snapshot.docs.isNotEmpty) {
        userRole = 'volunteer';
      }

      // Query for NGO
      if (snapshot.docs.isEmpty) {
        snapshot = await FirebaseFirestore.instance
            .collection('ngos')
            .where('email', isEqualTo: email)
            .get();
        if (snapshot.docs.isNotEmpty) {
          userRole = 'ngo';
        }
      }

      // Query for admin
      if (snapshot.docs.isEmpty) {
        snapshot = await FirebaseFirestore.instance
            .collection('admins')
            .where('email', isEqualTo: email)
            .get();
        if (snapshot.docs.isNotEmpty) {
          userRole = 'admin';
        }
      }

      // Check if user exists
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = snapshot.docs.first;

        // Save document ID and role in SharedPreferences
        await prefs.setString('userDocId', userDoc.id);
        await prefs.setString('userRole', userRole);

        // Fetch user data and store it in GlobalUser.currentUser
        UserData currentUser = UserData.fromFirestore(userDoc);
        GlobalUser.currentUser = currentUser;

        // Redirect to respective dashboard
        if (userRole == 'volunteer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const VolunteerDashboard()),
          );
        } else if (userRole == 'ngo') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NgoDashboard()),
          );
        } else if (userRole == 'admin') {
          String adminRole = userDoc['role'] ?? '';
          if (adminRole == 'uni') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UniDashboard()),
            );
          } else if (adminRole == 'college') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CaDashboardScreen()),
            );
          }
        }
      } else {
        setState(() {
          _isLoading = false; // Stop loading on error
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found!')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
