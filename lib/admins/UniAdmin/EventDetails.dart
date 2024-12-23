import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart'; // Import AppColors from a separate file
import 'package:bharatsocials/admins/UniAdmin/ColName.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EventDetailsScreen(),
    );
  }
}

class EventDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get theme-dependent colors using the AppColors utility
    Color backgroundColor = AppColors.getBackgroundColor(context);
    Color textColor = AppColors.getTextColor(context);
    Color buttonColor = AppColors.getButtonColor(context);
    Color buttonTextColor = AppColors.getButtonTextColor(context);

    // Get screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details', style: TextStyle(color: textColor)),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // "Purpose of Event" card
              Card(
                color: backgroundColor,
                elevation: 4,
                child: Container(
                  width: screenWidth * 0.9,
                  height:
                      150, // Increased height for the "Purpose of Event" card
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Purpose Of Event',
                      style: TextStyle(color: textColor, fontSize: 16),
                      overflow: TextOverflow
                          .ellipsis, // Ensures long text doesn't overflow
                      maxLines: 3, // Allows up to 3 lines for the text
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // "Event Details" card
              Card(
                color: backgroundColor,
                elevation: 4,
                child: Container(
                  width: screenWidth * 0.9,
                  height: 130, // Adjusted height for event details
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Event Name',
                        style: TextStyle(color: textColor, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Event Date',
                        style: TextStyle(color: textColor, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Event Location',
                        style: TextStyle(color: textColor, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2, // Allows up to 2 lines for location
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              // "Attended" button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CollegePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  fixedSize: Size(screenWidth * 0.8, 50),
                ),
                child: Text('Attended',
                    style: TextStyle(color: buttonTextColor, fontSize: 16)),
              ),
              SizedBox(height: 16),
              // "Volunteer" button
              ElevatedButton(
                onPressed: () {
                  // Handle 'Volunteer' button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  side: BorderSide(color: textColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  fixedSize: Size(screenWidth * 0.8, 50),
                ),
                child: Text('Volunteer',
                    style: TextStyle(color: textColor, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add button press
        },
        backgroundColor: AppColors.getBackgroundColor(context),
        child: Icon(Icons.add, color: textColor),
      ),
    );
  }
}
