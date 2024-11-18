import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/login/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register.dart'; // Import the Register screen

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get theme-dependent colors using the AppColors utility
    Color backgroundColor = AppColors.getBackgroundColor(context);
    Color textColor = AppColors.getTextColor(context);
    Color buttonColor = AppColors.getButtonColor(context);
    Color buttonTextColor = AppColors.getButtonTextColor(context);

    // Get screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor, // Set the background color
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Padding before pagination to ensure content isn't at the top
              SizedBox(height: screenHeight * 0.12),

              // Pagination (Dot) Indicator at the Top
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(
                        isActive: true, context: context), // First dot (active)
                    _buildConnectingLine(context), // Line between dots

                    // Middle Dot wrapped with GestureDetector for navigation
                    GestureDetector(
                      onTap: () {
                        // Navigate to the Registration page when the middle dot is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegistrationPage()),
                        );
                      },
                      child: _buildDot(
                          isActive: false,
                          context: context), // Middle dot (inactive)
                    ),
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
                  borderRadius: BorderRadius.circular(13),
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
                  color: textColor, // Use textColor based on theme
                ),
              ),
              Text(
                'Bharat Socials',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth > 600 ? 40 : 32,
                  fontWeight: FontWeight.bold,
                  color: textColor, // Use textColor based on theme
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // Get Started Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Register page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrationPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, // Button background color
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
                    color: buttonTextColor, // Button text color
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
                          color: textColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage(
                                    userRole: 'null',
                                  )),
                        );
                      },
                      child: Text(
                        'Log In',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: textColor,
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
}
