import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/colors.dart'; // Import AppColors

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Get the appropriate button and text color based on the current theme
    Color buttonColor = AppColors.getButtonColor(context);
    Color buttonTextColor = AppColors.getButtonTextColor(context);

    return SizedBox(
      height: 60, // Increase the height to ensure the text fits comfortably
      width: double.infinity, // Take full width for the button
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor, // Color remains consistent
          padding: const EdgeInsets.symmetric(vertical: 13), // Adjusted padding
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: Text(
          'Log In',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: buttonTextColor, // Text color remains consistent
          ),
        ),
      ),
    );
  }
}
