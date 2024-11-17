import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register.dart'; // Import the Register screen

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is dark mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Set background, text, and button colors based on the theme
    Color backgroundColor = isDarkMode ? const Color(0xFF333333) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color buttonColor = isDarkMode ? Colors.white : Colors.black;
    Color buttonTextColor = isDarkMode ? Colors.black : Colors.white;

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
              SizedBox(
                  height: screenHeight *
                      0.12), // Space at the top (12% of screen height)

              // Pagination (Dot) Indicator at the Top
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(
                        isActive: true,
                        isDarkMode: isDarkMode), // First dot (inactive)
                    _buildConnectingLine(), // Line between dots

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
                          isDarkMode: isDarkMode), // Middle dot (inactive)
                    ),
                    _buildConnectingLine(), // Line between dots

                    _buildDot(
                        isActive: false,
                        isDarkMode: isDarkMode), // Last dot (inactive)
                  ],
                ),
              ),
              SizedBox(
                  height: screenHeight *
                      0.18), // Space after pagination (18% of screen height)

              // Logo Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(16), // Apply rounded corners
                  child: Image.asset(
                    'assets/app_icon.png', // Path to your logo asset
                    width: screenWidth * 0.45, // 45% of screen width for logo
                    height: screenWidth * 0.45, // Maintain aspect ratio
                    fit: BoxFit
                        .cover, // Ensure the image scales well within the rounded container
                  ),
                ),
              ),
              SizedBox(
                  height: screenHeight *
                      0.05), // Space after logo (5% of screen height)

              // Welcome Text Section
              Text(
                'Welcome To',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth > 600
                      ? 28
                      : 24, // Larger font for wider screens
                  fontWeight: FontWeight.w500,
                  color: textColor, // Set text color based on theme
                ),
              ),
              Text(
                'Bharat Socials',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth > 600
                      ? 40
                      : 32, // Larger font for wider screens
                  fontWeight: FontWeight.bold,
                  color: textColor, // Set text color based on theme
                ),
              ),
              SizedBox(
                  height: screenHeight *
                      0.05), // Space after text (5% of screen height)

              // Get Started Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Register page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const RegistrationPage(), // RegisterPage is the registration screen
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      buttonColor, // Button background color based on theme
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.15, // Button width responsive
                    vertical: 16,
                  ),
                  elevation: 4, // Adding shadow for a modern feel
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Rounded button corners
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: buttonTextColor, // Button text color opposite of bg
                  ),
                ),
              ),
              SizedBox(
                  height: screenHeight *
                      0.02), // Space after button (2% of screen height)

              // Row for "Already Member?" and "Log In" Text Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Your navigation logic or any logic for the home page
                      },
                      child: Text(
                        'Already Member?',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: textColor, // Set text color based on theme
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Your navigation logic or any logic for the home page
                      },
                      child: Text(
                        'Log In',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: textColor, // Set text color based on theme
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: screenHeight *
                      0.05), // Space after text buttons (5% of screen height)
            ],
          ),
        ),
      ),
    );
  }

  // Method to build a single dot
  Widget _buildDot({required bool isActive, required bool isDarkMode}) {
    return Container(
      width: 15, // Width of the dot
      height: 15, // Height of the dot
      decoration: BoxDecoration(
        color: isActive
            ? (isDarkMode
                ? Colors.white
                : Colors.black) // Active dot color changes based on theme
            : Colors.grey, // Inactive dot color (always grey)
        shape: BoxShape.circle, // Make the shape round
      ),
    );
  }

  // Method to build the line connecting dots
  Widget _buildConnectingLine() {
    return Container(
      width: 80, // Width of the line between dots
      height: 2, // Height of the line (thin)
      color: Colors.grey, // Line color (light grey for inactive state)
    );
  }
}
