import 'package:bharatsocials/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllEventsPage extends StatelessWidget {
  const AllEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonColor = AppColors.getButtonColor(context);

    // EventCard Widget inside AllEventsPage
    Widget eventCard({
      required String eventName,
      required String eventDate,
      required String eventLocation,
      required VoidCallback onViewMore,
    }) {
      return Container(
        margin: const EdgeInsets.only(
            right: 16, bottom: 16), // margin between cards
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9), // Grey background for the event card
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Name
              Text(
                'Name: $eventName',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis, // Handling text overflow
                maxLines: 1, // Limiting to 1 line
              ),
              SizedBox(height: 8),
              // Event Date
              Text(
                'Date: $eventDate',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 8),
              // Event Location
              Text(
                'Location: $eventLocation',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Spacer(), // Pushes the button to the bottom
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: onViewMore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'View More',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.getButtonTextColor(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.getButtonColor(context),
        title: Text(
          'All Events',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: AppColors.getButtonTextColor(context),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: AppColors.getButtonTextColor(
              context), // Set back arrow color to match button text color
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          shrinkWrap: true, // Shrink the grid to fit its children
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Create a 2-column grid
            crossAxisSpacing: 16, // Horizontal space between items
            mainAxisSpacing: 16, // Vertical space between items
            childAspectRatio: 0.75, // Adjust height/width ratio for cards
          ),
          itemCount: 10, // Number of items
          itemBuilder: (context, index) {
            return eventCard(
              eventName: 'Event Name $index', // Example event name
              eventDate: '14th December 2024', // Example event date
              eventLocation: 'Location $index', // Example event location
              onViewMore: () {
                print("View More button pressed for Event $index");
              },
            );
          },
        ),
      ),
    );
  }
}
