import 'package:flutter/material.dart';

// Enhanced colors.dart with existing variables

class AppColors {
  // Background Colors
  static Color appBgColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0xFF18171C) // Dark mode color
        : Colors.white; // Light mode color
  }

  // Text Colors
  static Color defualtTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0xFFFFFFFF)
        : const Color(
            0xFF000000); // Softer white for dark mode, deep black for light mode
  }

  static Color titleTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF000000); // Reverse logic for contrast
  }

  // Button Colors
  static Color titleColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0xFF2A2A34) // Dark mode color (rgba(62, 62, 62, 1))
        : const Color(0xFFDEDEDE); // Light mode color (white)
  }

  static Color mainButtonColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0xFF000000)
        : const Color(
            0xFF000000); // Lighter text for dark mode, bright white for light
  }

  static Color FAB(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0xFFFFFFFF) // Dark mode color (rgba(117, 117, 117, 1))
        : const Color(0xFF9B9898); // Light mode color (rgba(217, 217, 217, 1))
  }

  static Color mainButtonTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0xFFFFFFFF)
        : const Color(0xFFFFFFFF); // Muted white for readability in dark mode
  }

  // Dot Colors
  static Color getDotColor(BuildContext context, {required bool isActive}) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isActive
        ? (isDarkMode
            ? const Color(0xFFFFFFFF)
            : const Color(
                0xFF000000)) // Active dots: white in dark, black in light
        : const Color(0xFFBDBDBD); // Inactive dots are grey
  }

  static Color subTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0xFFD34E2D)
        : const Color(0xFFD34E2D); // Softer greys for lines
  }

  static Color dividerColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0x00000000) // Transparent in dark mode
        : const Color(0xFFB3AFAF); // Softer greys for lines
  }

  static Color UpcomingeventCardBgColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0xFFEFE5FF) // Dark mode color (rgba(117, 117, 117, 1))
        : const Color(0xFFEFE5FF); // Light mode color (rgba(217, 217, 217, 1))
  }

  static Color AlleventCardBgColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0xFFFFF7A9) // Dark mode color (rgba(117, 117, 117, 1))
        : const Color(0xFFFFF7A9); // Light mode color (rgba(217, 217, 217, 1))
  }

  static Color eventCardTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0xFF000000) // Dark mode color (rgba(117, 117, 117, 1))
        : const Color(0xFF000000); // Light mode color (rgba(217, 217, 217, 1))
  }

  static Color acceptButtonColor(BuildContext context) {
    return const Color(
        0xFF02EB25); // Same color for both light and dark modes (rgba(2, 235, 37, 0.74))
  }

  static Color acceptButtonTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0xFFFFFFFF) // Dark mode color (rgba(117, 117, 117, 1))
        : const Color(0xFF000000); // Light mode color (rgba(217, 217, 217, 1))
  }

  static Color rejectButtonTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0xFFFFFFFF) // Dark mode color (rgba(117, 117, 117, 1))
        : const Color(0xFF000000); // Light mode color (rgba(217, 217, 217, 1))
  }

  static Color rejectButtonColor(BuildContext context) {
    return const Color(
        0xFFFD7474); // Same color for both light and dark modes (rgba(255, 116, 116, 0.74))
  }

  static Color iconColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0xFFFFFFFF) // Dark mode color (rgba(117, 117, 117, 1))
        : const Color(0xFF000000); // Light mode color (rgba(217, 217, 217, 1))
  }

  // Line Colors
  static Color getLineColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0xFF616161)
        : const Color(0xFFCCCCCC); // Softer greys for lines
  }
}

