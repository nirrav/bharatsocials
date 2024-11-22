import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleSelectionDialog extends StatelessWidget {
  final Function(String) onRoleSelected; // Callback to return the selected role

  const RoleSelectionDialog({super.key, required this.onRoleSelected});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Use AppColors methods to get the correct colors for the current theme
    Color backgroundColor = AppColors.appBgColor(context);
    Color textColor = AppColors.defualtTextColor(context);
    Color buttonColor = AppColors.mainButtonColor(context);
    Color buttonTextColor = AppColors.mainButtonTextColor(context);

    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text(
        'Who are you?',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRoleOption(context, 'Volunteer', buttonColor, buttonTextColor),
          _buildRoleOption(context, 'NGO', buttonColor, buttonTextColor),
          _buildRoleOption(context, 'Admin', buttonColor, buttonTextColor),
        ],
      ),
    );
  }

  Widget _buildRoleOption(BuildContext context, String role, Color buttonColor,
      Color buttonTextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          onRoleSelected(role); // Pass the selected role back to the callback
          // Don't pop the dialog here; we want to stay on the current screen
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13), // Set border radius to 13
          ),
        ),
        child: Text(
          role,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: buttonTextColor, // Using the updated button text color
          ),
        ),
      ),
    );
  }
}
