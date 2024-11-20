import 'package:bharatsocials/login/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/colors.dart'; // Import AppColors
class SubmitButtonWidget extends StatelessWidget {
  final bool isTermsAgreed;
  final VoidCallback onSubmit;
  final String selectedRole; // Add selectedRole as a parameter

  const SubmitButtonWidget({super.key, 
    required this.isTermsAgreed,
    required this.onSubmit,
    required this.selectedRole, // Receive the role
  });

  @override
  Widget build(BuildContext context) {
    // Get the appropriate button and text color based on the current theme
    Color buttonColor =
        AppColors.getButtonColor(context); // Default button color
    Color buttonTextColor = AppColors.getButtonTextColor(context); // Text color

    return SizedBox(
      height: 60, // Increase the height to ensure the text fits comfortably
      width: double.infinity, // Take full width for the button
      child: ElevatedButton(
        onPressed: isTermsAgreed
            ? () {
                // Call the onSubmit function
                onSubmit();

                // Navigate to the LoginPage with the selected role
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(
                        userRole: selectedRole), // Pass the selected role
                  ),
                );
              }
            : null, // Only disable functionality, not color
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor, // Color remains consistent
          padding: const EdgeInsets.symmetric(vertical: 13), // Adjusted padding
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: Text(
          'Submit',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: buttonTextColor, // Text color remains consistent
          ),
        ),
      ),
    );
  }
}
