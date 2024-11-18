import 'package:bharatsocials/colors.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller; // The controller for the text field

  const TextFieldWidget({
    required this.label,
    required this.controller, required bool isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    // Use AppColors methods to get the correct colors for the current theme
    Color textColor = AppColors.getTextColor(context);
    Color borderColor =
        AppColors.getLineColor(context); // Use getLineColor for the border

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: textColor), // Set text color using AppColors
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: textColor, // Set label color using AppColors
            height: 1.5,
          ),
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: borderColor), // Set border color using AppColors
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: borderColor), // Set border color using AppColors
          ),
        ),
      ),
    );
  }
}
