import 'package:flutter/material.dart';
// colors.dart

class AppColors {
  static Color getBackgroundColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? const Color(0xFF333333) : Colors.white;
  }

  static Color getTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.white : Colors.black;
  }

  static Color getDefaultTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.black : Colors.white;
  }

  static Color getButtonColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.white : Colors.black;
  }

  static Color getButtonTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.black : Colors.white;
  }

  static Color getCardTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.white : Colors.black;
  }

  // Optional: Define other colors (e.g., dot colors, line colors)
  static Color getDotColor(BuildContext context, {required bool isActive}) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isActive
        ? (isDarkMode ? Colors.white : Colors.black)
        : Colors.grey; // Inactive dots are grey
  }

  static Color getLineColor(BuildContext context) {
    return Colors
        .grey; // You can also customize this depending on the theme if needed
  }
}
