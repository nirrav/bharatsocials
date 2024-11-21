import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart'; // Import the AppColors utility

class AchievementPage extends StatelessWidget {
  const AchievementPage({Key? key}) : super(key: key);

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
        title: const Text('Achievement'),
        backgroundColor: buttonTextColor, // Customize AppBar color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Achievement',
              style: TextStyle(
                fontSize: screenWidth * 0.08, // Responsive font size
                fontWeight: FontWeight.bold,
                color: textColor, // Dynamic text color
              ),
            ),
            SizedBox(
                height:
                    screenHeight * 0.05), // Add spacing based on screen height
            ElevatedButton(
              onPressed: () {
                // Your button action here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor, // Dynamic button color
              ),
              child: Text(
                'Celebrate',
                style: TextStyle(
                    color: buttonTextColor), // Dynamic button text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
