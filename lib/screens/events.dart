import 'package:flutter/material.dart';

// Define the reusable RoundedRectangleCard widget
class RoundedRectangleCard extends StatelessWidget {
  final String event;
  final String ngo;
  final String date;
  final String venue;

  const RoundedRectangleCard({
    super.key,
    required this.event,
    required this.ngo,
    required this.date,
    required this.venue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 8.0), // Spacing between rectangles
      width: double.infinity, // Full width of the parent
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
              AssetImage('assets/texture.jpg'), // Replace with your image path
          fit: BoxFit.cover, // Ensure the image covers the entire container
        ),
        color: Color.fromARGB(255, 196, 177, 70), // Background color

        borderRadius: BorderRadius.circular(16.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 8, 7, 7)
                .withOpacity(0.2), // Shadow color
            spreadRadius: 1, // Spread radius
            blurRadius: 4, // Blur radius
            offset: const Offset(6, 6), // Shadow position (x, y)
          ),
        ],
        border: Border.all(
          color: const Color.fromARGB(255, 128, 131, 136)
              .withOpacity(1), // Border color
          width: 0.9, // Border width
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 20.0), // Padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event,
              style: const TextStyle(
                fontSize: 20.0, // Font size
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 6.0), // Spacing between text
            Text(
              ngo,
              style: const TextStyle(
                fontSize: 20.0, // Font size
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 8.0), // Spacing between text
            Text(
              date,
              style: const TextStyle(
                fontSize: 20.0, // Font size
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 6.0), // Spacing between text
            Text(
              venue,
              style: const TextStyle(
                fontSize: 20.0, // Font size
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Define the EventsScreen
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Optional: Background image can be added here

          // Foreground content
          Padding(
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Use the reusable widget for each event
                  RoundedRectangleCard(
                    event: 'Event: Charity Run',
                    ngo: 'NGO: Helping Hands',
                    date: 'Date: 12th March 2023',
                    venue: 'Venue: City Park',
                  ),
                  RoundedRectangleCard(
                    event: 'Event: Food Drive',
                    ngo: 'NGO: Food for All',
                    date: 'Date: 25th April 2023',
                    venue: 'Venue: Community Center',
                  ),
                  RoundedRectangleCard(
                    event: 'Event: Environmental Cleanup',
                    ngo: 'NGO: Green Earth',
                    date: 'Date: 15th May 2023',
                    venue: 'Venue: Beachside',
                  ),
                  RoundedRectangleCard(
                    event: 'Event: Blood Donation Camp',
                    ngo: 'NGO: Red Cross',
                    date: 'Date: 10th June 2023',
                    venue: 'Venue: Hospital',
                  ),
                  RoundedRectangleCard(
                    event: 'Event: Education Drive',
                    ngo: 'NGO: Educate All',
                    date: 'Date: 20th July 2023',
                    venue: 'Venue: School',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
