import 'package:flutter/material.dart';
import 'package:bharatsocials/volunteers/volDashboard.dart';
import 'package:bharatsocials/common_widgets/event_details.dart';

class SavedEventsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SavedEventsPage(),
    );
  }
}

class SavedEventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define custom colors directly
    Color backgroundColor = Color(0xFF1F1F1F); // Dark background color
    Color textColor = Color(0xFFFFFFFF); // White text color
    Color buttonColor = Color(0xFF2196F3); // Blue button color
    Color buttonTextColor = Color(0xFFFFFFFF); // White text for button
    Color cardTextColor = Color(0xFFFFFFFF);

    // Get screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Events',
          style: TextStyle(color: textColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VolunteerDashboard()),
            );
          },
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02), // Gap between AppBar and body
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Number of event cards
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.02),
                    child: EventCard(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatefulWidget {
  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _isSaved = false; // This will track the state of the bookmark

  @override
  Widget build(BuildContext context) {
    // Define custom colors directly
    Color backgroundColor = Color(0xFF1F1F1F); // Dark background color
    Color textColor = Color(0xFFFFFFFF); // White text color
    Color buttonColor = Color(0xFF1F1F1F); // Blue button color
    Color buttonTextColor = Color(0xFFFFFFFF); // Black text for button
    Color cardTextColor = Color(0xFF1F1F1F); // Black text for Card

    // Get screen size for responsive design
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: textColor, // Using white for the card background
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: backgroundColor,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Name',
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.bold,
                color: cardTextColor, // White text color
              ),
            ),
            SizedBox(height: size.height * 0.005),
            Text(
              'Event Date',
              style: TextStyle(
                fontSize: size.width * 0.04,
                color: cardTextColor, // White text color
              ),
            ),
            SizedBox(height: size.height * 0.005),
            Text(
              'Event Location',
              style: TextStyle(
                fontSize: size.width * 0.04,
                color: cardTextColor, // White text color
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    _isSaved
                        ? Icons.bookmark
                        : Icons
                            .bookmark_border, // Toggle between filled and unfilled bookmark
                    size: size.width * 0.06,
                    color: _isSaved
                        ? backgroundColor
                        : Colors.grey, // Change color based on state
                  ),
                  onPressed: () {
                    setState(() {
                      _isSaved = !_isSaved; // Toggle the bookmark state
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: buttonColor, // Blue button color
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventDetailsPage(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        'View More',
                        style: TextStyle(
                          color: buttonTextColor, // White text for the button
                          fontSize: size.width * 0.04,
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Icon(
                        Icons.arrow_forward,
                        color: buttonTextColor, // White icon for the button
                        size: size.width * 0.05,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
