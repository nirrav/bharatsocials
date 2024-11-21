import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/colors.dart'; // Import AppColors

class SubmitButtonWidget extends StatelessWidget {
  final bool isTermsAgreed;
  final VoidCallback onSubmit; // Define the onSubmit callback
  final String selectedRole; // Add selectedRole as a parameter

  const SubmitButtonWidget({
    super.key,
    required this.isTermsAgreed,
    required this.onSubmit,
    required this.selectedRole,
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
            ? onSubmit // Use the passed onSubmit function
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
