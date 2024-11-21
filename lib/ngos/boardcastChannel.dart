import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BroadcastChannelScreen(),
    );
  }
}

class AppColors {
  static Color getBackgroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.grey.shade200;

  static Color getTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black;

  static Color getButtonColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.blue.shade700
          : Colors.blue;

  static Color getButtonTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.white;
}

class BroadcastChannelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get theme-dependent colors using the AppColors utility
    Color backgroundColor = AppColors.getBackgroundColor(context);
    Color textColor = AppColors.getTextColor(context);
    Color buttonColor = AppColors.getButtonColor(context);
    Color buttonTextColor = AppColors.getButtonTextColor(context);

    // Get screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Broadcast Channel', style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            Navigator.pop(context); // Navigate to the previous page
          },
        ),
      ),
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              EventCard(
                width: screenWidth * 0.9,
                height: screenHeight * 0.35,
                textColor: textColor,
              ),
              SizedBox(height: 16),
              EventCard(
                width: screenWidth * 0.9,
                height: screenHeight * 0.35,
                textColor: textColor,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add button press
        },
        backgroundColor: buttonColor,
        child: Icon(Icons.add, color: buttonTextColor),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundColor,
        selectedItemColor: textColor,
        unselectedItemColor: textColor.withOpacity(0.6),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: textColor),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign, color: textColor),
            label: '',
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final double width;
  final double height;
  final Color textColor;

  EventCard({
    required this.width,
    required this.height,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.getBackgroundColor(context),
      elevation: 4,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event Name',
                style: TextStyle(color: textColor, fontSize: 18)),
            SizedBox(height: 8),
            Text('Event Date',
                style: TextStyle(color: textColor, fontSize: 16)),
            SizedBox(height: 8),
            Text('Event Location',
                style: TextStyle(color: textColor, fontSize: 16)),
            Spacer(),
            Text(
              'View More',
              style: TextStyle(
                  color: AppColors.getButtonColor(context), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
