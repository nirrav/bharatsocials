import 'package:bharatsocials/login/home.dart';
import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/ngos/ngoDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bharatsocials/volunteers/volDashboard.dart';
import 'package:bharatsocials/login/widgets/login_button.dart';
import 'package:bharatsocials/login/widgets/dot_indicator.dart';
import 'package:bharatsocials/admins/UniAdmin/uniDashboard.dart';
import 'package:bharatsocials/login/widgets/text_field_widget.dart';
import 'package:bharatsocials/admins/CollegeAdmin/caDashboard.dart';
import 'package:bharatsocials/login/widgets/password_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging

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
    _checkLoginStatus(); // Check login status when the page is initialized
  }

  // Check if the user is already logged in
  void _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // If logged in, navigate based on the user role
      _navigateToHomeScreen(user);
    }
  }

  void _navigateToHomeScreen(User user) async {
    String role = '';
    String? adminRole;

    try {
      final volunteerSnapshot = await FirebaseFirestore.instance
          .collection('volunteers')
          .where('email', isEqualTo: user.email)
          .get();

      if (volunteerSnapshot.docs.isNotEmpty) {
        role = 'volunteer';
        print('User is a volunteer');
      } else {
        final ngoSnapshot = await FirebaseFirestore.instance
            .collection('ngos')
            .where('email', isEqualTo: user.email)
            .get();

        if (ngoSnapshot.docs.isNotEmpty) {
          role = 'ngo';
          print('User is an NGO');
        } else {
          final adminSnapshot = await FirebaseFirestore.instance
              .collection('admins')
              .where('email', isEqualTo: user.email)
              .get();

          if (adminSnapshot.docs.isNotEmpty) {
            role = 'admin';
            DocumentSnapshot userDoc = adminSnapshot.docs.first;
            adminRole = userDoc['adminRole'];
            print('User is an admin, adminRole: $adminRole');
          }
        }
      }

      // Once we have the user role, generate a new FCM token and update it in Firestore
      await _updateFcmToken(user);

      // Navigate based on role
      onSuccess(role, adminRole);
    } catch (e) {
      print('Error checking user role: $e');
    }
  }

  // Function to update FCM token
  Future<void> _updateFcmToken(User user) async {
    try {
      // Get the new FCM token
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken != null) {
        // Get the collection based on user role and update the FCM token
        if (user.email != null) {
          final volunteerSnapshot = await FirebaseFirestore.instance
              .collection('volunteers')
              .where('email', isEqualTo: user.email)
              .get();

          if (volunteerSnapshot.docs.isNotEmpty) {
            await FirebaseFirestore.instance
                .collection('volunteers')
                .doc(volunteerSnapshot.docs.first.id)
                .update({'fcmToken': fcmToken});
            print('FCM Token updated for Volunteer');
          } else {
            final ngoSnapshot = await FirebaseFirestore.instance
                .collection('ngos')
                .where('email', isEqualTo: user.email)
                .get();

            if (ngoSnapshot.docs.isNotEmpty) {
              await FirebaseFirestore.instance
                  .collection('ngos')
                  .doc(ngoSnapshot.docs.first.id)
                  .update({'fcmToken': fcmToken});
              print('FCM Token updated for NGO');
            } else {
              final adminSnapshot = await FirebaseFirestore.instance
                  .collection('admins')
                  .where('email', isEqualTo: user.email)
                  .get();

              if (adminSnapshot.docs.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('admins')
                    .doc(adminSnapshot.docs.first.id)
                    .update({'fcmToken': fcmToken});
                print('FCM Token updated for Admin');
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error updating FCM token: $e');
    }
  }

  void onSuccess(String role, String? adminRole) {
    if (role == 'volunteer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const VolunteerDashboard()), // Replace with volunteer screen
      );
    } else if (role == 'ngo') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NgoDashboard()),
      );
    } else if (role == 'admin') {
      if (adminRole == 'uni') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UniAdminDashboard()),
        );
      } else if (adminRole == 'college') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CaDashboardScreen()),
        );
      }
    }
  }

  void onLogin({
    required String email,
    required String password,
    required Function(bool) setLoading,
    required Function(String) showSnackBar,
    required Function(String, String?) onSuccess,
  }) async {
    try {
      setLoading(true);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Once logged in, call _navigateToHomeScreen
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _navigateToHomeScreen(user);
      }
      setLoading(false);
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      showSnackBar(e.message ?? 'Login failed');
    }
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
                              onPressed: () => onLogin(
                                email: emailController.text,
                                password: passwordController.text,
                                setLoading: (isLoading) {
                                  setState(() {
                                    _isLoading = isLoading;
                                  });
                                },
                                showSnackBar: (message) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                                },
                                onSuccess: (role, adminRole) {
                                  // Navigate based on the user role
                                  if (role == 'volunteer') {
                                    print('User is Volunteer');
                                  } else if (role == 'ngo') {
                                    print('User is NGO');
                                  } else if (role == 'admin') {
                                    print('User is Admin');
                                    print('Admin Role: $adminRole');
                                  }
                                },
                              ),
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
