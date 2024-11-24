import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/volunteers/volDashboard.dart';
// import 'package:bharatsocials/common_widgets/event_details.dart';

class SavedEventsApp extends StatelessWidget {
  const SavedEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SavedEventsPage(),
    );
  }
}

class SavedEventsPage extends StatelessWidget {
  const SavedEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Events',
          style: TextStyle(color: AppColors.titleTextColor(context)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.iconColor(context)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const VolunteerDashboard()),
            );
          },
        ),
        backgroundColor: AppColors.titleColor(context),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // Divider height
          child: Divider(
            color:
                AppColors.dividerColor(context), // Divider color based on theme
            thickness: 1,
            height: 1,
          ),
        ),
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
  const EventCard({super.key});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _isSaved = false; // This will track the state of the bookmark

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.eventCardBgColor(
            context), // Using white for the card background
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 5,
            offset: const Offset(0, 3),
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
                color:
                    AppColors.eventCardTextColor(context), // White text color
              ),
            ),
            SizedBox(height: size.height * 0.005),
            Text(
              'Event Date',
              style: TextStyle(
                fontSize: size.width * 0.04,
                color:
                    AppColors.eventCardTextColor(context), // White text color
              ),
            ),
            SizedBox(height: size.height * 0.005),
            Text(
              'Event Location',
              style: TextStyle(
                fontSize: size.width * 0.04,
                color:
                    AppColors.eventCardTextColor(context), // White text color
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
                        ? AppColors.iconColor(context)
                        : AppColors.iconColor(
                            context), // Change color based on state
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
                    backgroundColor:
                        AppColors.mainButtonColor(context), // Blue button color
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Placeholder(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        'View More',
                        style: TextStyle(
                          color: AppColors.mainButtonTextColor(
                              context), // White text for the button
                          fontSize: size.width * 0.04,
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.iconColor(
                            context), // White icon for the button
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
