import 'package:bharatsocials/login/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import for Google Fonts

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bharat Socials',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white, // Light mode background color
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.poppins(
            // Apply Poppins Medium font style for light mode text
            color: Colors.black,
            fontWeight: FontWeight.w500, // Medium weight
            fontSize: 16,
          ),
        ),
        useMaterial3: true, // Use Material 3
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor:
            const Color(0xFF333333), // Charcoal gray background for dark mode
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.poppins(
            // Apply Poppins Medium font style for dark mode text
            color: Colors.white,
            fontWeight: FontWeight.w500, // Medium weight
            fontSize: 16,
          ),
        ),
        useMaterial3: true, // Use Material 3
      ),
      themeMode: ThemeMode
          .system, // Auto-switch between light/dark based on system theme
      home:
          const HomePage(), // Placeholder for now, you can replace it with your home screen later
    );
  }
}
