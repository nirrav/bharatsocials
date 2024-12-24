import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';

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
        _buildUpcomingEventsHorizontalList(context),
        const SizedBox(height: 16),
        _buildSectionHeader(context, title: 'Our Campaigns'),
        const SizedBox(height: 8),
        _buildAllEventsHorizontalList(context),
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
              color: AppColors.defualtTextColor(context),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            // Placeholder for navigation logic
          },
          child: Text(
            'See More..',
            style:
                TextStyle(color: AppColors.subTextColor(context), fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingEventsHorizontalList(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
          vertical: 8.0), // Add padding to prevent cutting
      child: Row(
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.UpcomingeventCardBgColor(
                    context), // Lighter card background
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Event Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Title color
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Event Date: 12 December 2024',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Event Location: Los Angeles',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.mainButtonColor(context), // Button color
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

  Widget _buildAllEventsHorizontalList(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
          vertical: 8.0), // Add padding to prevent cutting
      child: Row(
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    AppColors.AlleventCardBgColor(context), // Clean white cards
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Event Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Bold title color
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Event Date: 10 December 2024',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Event Location: New York City',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.mainButtonColor(context), // Button color
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
