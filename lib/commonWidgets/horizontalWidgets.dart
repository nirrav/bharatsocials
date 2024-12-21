import 'package:flutter/material.dart';

// Sample of a dynamic content class for Upcoming Campaigns

class UpcomingCampaigns extends StatelessWidget {
  const UpcomingCampaigns({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, title: 'Upcoming Campaigns'),
        const SizedBox(height: 8),
        _buildUpcomingEventsHorizontalList(),
        const SizedBox(height: 16),
        _buildSectionHeader(context, title: 'Our Campaigns'),
        const SizedBox(height: 8),
        _buildAllEventsHorizontalList(),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              color: Colors.deepPurple[700],
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            // Placeholder for navigation logic
          },
          child: Text(
            'See More..',
            style: TextStyle(color: Colors.deepPurple, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingEventsHorizontalList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey[100], // Lighter card background
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[700], // Title color
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Event Date: 12 December 2024',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Event Location: Los Angeles',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange, // Button color
                      foregroundColor: Colors.white, // Button text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('View More'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAllEventsHorizontalList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, // Clean white cards
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[700], // Bold title color
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Event Date: 10 December 2024',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Event Location: New York City',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange, // Button color
                      foregroundColor: Colors.white, // Button text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('View More'),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
