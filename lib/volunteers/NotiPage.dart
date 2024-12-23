import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NotificationPage(),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get theme-dependent colors using the AppColors utility
    Color backgroundColor = AppColors.getBackgroundColor(context);
    Color textColor = AppColors.getTextColor(context);
    Color defautlTextColor = AppColors.getDefaultTextColor(context);
    Color buttonColor = AppColors.getButtonColor(context);
    Color buttonTextColor = AppColors.getButtonTextColor(context);
    Color cardTextColor = AppColors.getCardTextColor(context);

    // Get screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(color: textColor)),
        centerTitle: true,
        backgroundColor:
            buttonColor, // Using button color for AppBar background
      ),
      body: Container(
        color: backgroundColor, // Set background color
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(
                    title: 'Unread', defautlTextColor: defautlTextColor),
                NotificationRow(),
                NotificationRow(),
                NotificationRow(),
                NotificationRow(),
                SizedBox(height: 20),
                SectionTitle(
                    title: 'Today', defautlTextColor: defautlTextColor),
                NotificationRow(),
                NotificationRow(),
                SizedBox(height: 20),
                SectionTitle(title: 'Date', defautlTextColor: defautlTextColor),
                NotificationRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final Color defautlTextColor; // Added defautlTextColor parameter

  SectionTitle({required this.title, required this.defautlTextColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: defautlTextColor), // Apply text color
      ),
    );
  }
}

class NotificationRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[
              300], // You might want to replace this with a color from AppColors
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'Notification Message', // Example text
            style: TextStyle(
                color: AppColors.getTextColor(
                    context)), // Use text color from AppColors
          ),
        ),
      ),
    );
  }
}
