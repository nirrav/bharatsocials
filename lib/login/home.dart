import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/login/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/login/ngoRegister.dart';
import 'package:bharatsocials/login/admin_register.dart';
import 'package:bharatsocials/login/volunteerRegister.dart';
// import 'package:bharatsocials/login/ngoRegister.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor:
          AppColors.appBgColor(context), // Set the background color
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Padding before pagination to ensure content isn't at the top
              SizedBox(height: screenHeight * 0.06),

              // Pagination (Dot) Indicator at the Top
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(
                        isActive: true, context: context), // First dot (active)
                    _buildConnectingLine(context), // Line between dots
                    _buildDot(
                        isActive: false,
                        context: context), // Last dot (inactive)
                    _buildConnectingLine(context), // Line between dots

                    _buildDot(
                        isActive: false,
                        context: context), // Last dot (inactive)
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.18),

              // Logo Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/app_icon.png', // Path to your logo asset
                    width: screenWidth * 0.45,
                    height: screenWidth * 0.45,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // Welcome Text Section
              Text(
                'Welcome To',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth > 600 ? 28 : 24,
                  fontWeight: FontWeight.w500,
                  color: AppColors.defualtTextColor(
                      context), // Use textColor based on theme
                ),
              ),
              Text(
                'Bharat Socials',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth > 600 ? 40 : 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.defualtTextColor(
                      context), // Use textColor based on theme
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // Get Started Button
              ElevatedButton(
                onPressed: () {
                  _showRoleSelectionDialog(
                      context); // Show the role selection dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainButtonColor(
                      context), // Button background color
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.15,
                    vertical: 16,
                  ),
                  elevation: 4, // Adding shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: AppColors.mainButtonTextColor(
                        context), // Button text color
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Row for "Already Member?" and "Log In" Text Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Already Member?',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: AppColors.defualtTextColor(context),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: Text(
                        'Log In',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: AppColors.defualtTextColor(context),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build a single dot
  Widget _buildDot({required bool isActive, required BuildContext context}) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        color: AppColors.getDotColor(context,
            isActive: isActive), // Correctly pass context here
        shape: BoxShape.circle,
      ),
    );
  }

  // Method to build the line connecting dots
  Widget _buildConnectingLine(BuildContext context) {
    return Container(
      width: 80,
      height: 2,
      color: AppColors.getLineColor(context), // Correctly pass context here
    );
  }

  void _showRoleSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return RoleSelectionDialog(
          onRoleSelected: (role) {
            Navigator.of(context).pop(); // Close the dialog after selection

            // Redirect based on role selection
            if (role == 'Admin') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminRegisterPage(),
                ),
              );
            } else if (role == 'Volunteer') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VolunteerRegistrationPage(),
                  // builder: (context) => const volunteer.VolunteerRegistrationPage(),    New Method to call the page
                ),
              );
            } else if (role == 'NGO') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // builder: (context) => const NgoRegestrationPage(),
                  builder: (context) => const NgoRegistrationPage(),
                ),
              );
            }
          },
        );
      },
    );
  }
}

// Role Selection Dialog Widget
class RoleSelectionDialog extends StatelessWidget {
  final Function(String) onRoleSelected;

  const RoleSelectionDialog({required this.onRoleSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Who are you?', style: GoogleFonts.poppins()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRoleOption(context, 'Volunteer'),
          _buildRoleOption(context, 'NGO'),
          _buildRoleOption(context, 'Admin'),
        ],
      ),
    );
  }

  // Build the role option widget
  Widget _buildRoleOption(BuildContext context, String role) {
    return ListTile(
      leading: const Icon(Icons.account_circle),
      title: Text(role, style: GoogleFonts.poppins(fontSize: 18)),
      onTap: () {
        onRoleSelected(role); // Notify parent widget about role selection
      },
    );
  }
}
