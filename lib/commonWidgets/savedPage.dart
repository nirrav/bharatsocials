import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
// import 'package:bharatsocials/common_widgets/event_details.dart';

class SavedEventsPage extends StatelessWidget {
  const SavedEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 1.0), // Add padding to the sides
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02), // Gap between AppBar and body
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Number of event cards
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.02),
                    child: const EventCard(),
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
      margin: const EdgeInsets.symmetric(
          horizontal: 16.0), // Add margin to the card
      decoration: BoxDecoration(
        color: AppColors.UpcomingeventCardBgColor(
            context), // Using white for the card background
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(4, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event yenna poda',
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
