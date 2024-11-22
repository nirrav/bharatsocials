import 'package:flutter/material.dart';

// Enhanced colors.dart with existing variables

class AppColors {
  // Background Colors
  static Color appBgColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color.fromARGB(255, 89, 89, 89) // Dark mode color
        : Colors.white; // Light mode color
  }

  // Text Colors
  static Color defualtTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color.fromARGB(255, 255, 255, 255)
        : const Color.fromARGB(255, 0, 0,
            0); // Softer white for dark mode, deep black for light mode
  }

  static Color titleTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color.fromARGB(255, 255, 255, 255)
        : const Color.fromARGB(255, 0, 0, 0); // Reverse logic for contrast
  }

  // Button Colors

  static Color titleColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color.fromARGB(
            255, 62, 62, 62) // Dark mode color (rgba(62, 62, 62, 1))
        : const Color.fromARGB(255, 255, 255, 255); // Light mode color (white)
  }

  static Color mainButtonColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color.fromARGB(255, 0, 0, 0)
        : const Color.fromARGB(
            255, 0, 0, 0); // Lighter text for dark mode, bright white for light
  }

  static Color mainButtonTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color.fromARGB(255, 255, 255, 255)
        : const Color.fromARGB(
            255, 255, 255, 255); // Muted white for readability in dark mode
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
        ? const Color.fromARGB(255, 4, 234, 255)
        : const Color.fromARGB(255, 0, 187, 255); // Softer greys for lines
  }

  static Color dividerColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color.fromARGB(0, 255, 255, 255)
        : const Color.fromARGB(255, 179, 175, 175); // Softer greys for lines
  }

  static Color eventCardBgColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color.fromARGB(
            255, 117, 117, 117) // Dark mode color (rgba(117, 117, 117, 1))
        : const Color.fromARGB(
            255, 217, 217, 217); // Light mode color (rgba(217, 217, 217, 1))
  }

  static Color eventCardTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color.fromARGB(
            255, 255, 255, 255) // Dark mode color (rgba(117, 117, 117, 1))
        : const Color.fromARGB(
            255, 0, 0, 0); // Light mode color (rgba(217, 217, 217, 1))
  }

  static Color acceptButtonColor(BuildContext context) {
    return const Color.fromARGB(189, 2, 235,
        37); // Same color for both light and dark modes (rgba(2, 235, 37, 0.74))
  }

  static Color acceptButtonTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color.fromARGB(
            255, 255, 255, 255) // Dark mode color (rgba(117, 117, 117, 1))
        : const Color.fromARGB(
            255, 0, 0, 0); // Light mode color (rgba(217, 217, 217, 1))
  }

  static Color rejectButtonTextColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color.fromARGB(
            255, 255, 255, 255) // Dark mode color (rgba(117, 117, 117, 1))
        : const Color.fromARGB(
            255, 0, 0, 0); // Light mode color (rgba(217, 217, 217, 1))
  }

  static Color rejectButtonColor(BuildContext context) {
    return const Color.fromARGB(189, 255, 116,
        116); // Same color for both light and dark modes (rgba(255, 116, 116, 0.74))
  }

  static Color iconColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color.fromARGB(
            255, 255, 255, 255) // Dark mode color (rgba(117, 117, 117, 1))
        : const Color.fromARGB(
            255, 0, 0, 0); // Light mode color (rgba(217, 217, 217, 1))
  }

  // Line Colors
  static Color getLineColor(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode
        ? const Color(0xFF616161)
        : const Color(0xFFCCCCCC); // Softer greys for lines
  }
}
