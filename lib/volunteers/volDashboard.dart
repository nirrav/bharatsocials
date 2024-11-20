// lib/screens/volunteer_dashboard.dart

import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/common_widgets/event_card.dart';
import 'package:bharatsocials/common_widgets/upcoming_events_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class VolunteerDashboard extends StatefulWidget {
  const VolunteerDashboard({super.key});

  @override
  _VolunteerDashboardState createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  int _selectedIndex = 0; // Tracking the selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.getButtonColor(context),
        centerTitle: true, // Centering the title in the AppBar
        title: Text(
          'Vol Dashboard',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: AppColors.getButtonTextColor(context),
          ),
        ),
        actions: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.bell,
              color: AppColors.getButtonTextColor(context),
            ),
            onPressed: () {
              print("Notification icon pressed");
            },
          ),
        ],
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.bars,
            color: AppColors.getButtonTextColor(context),
          ),
          onPressed: () {
            print("Menu icon pressed");
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Events',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: AppColors.getTextColor(context),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to AllEventsPage when View All is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllEventsPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'View All...',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildEventList(context), // Show top 4 events here
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Attended Events',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: AppColors.getTextColor(context),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("View All... Attended Events tapped");
                    },
                    child: const Text(
                      'View All...',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildEventList(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.getButtonColor(context),
        elevation: 8, // Adding elevation for modern effect
        shape: const CircularNotchedRectangle(), // Optional: rounded corners
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                icon: FontAwesomeIcons.house,
                index: 0,
              ),
              _buildNavItem(
                icon: FontAwesomeIcons.bookmark,
                index: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the navigation item (without text)
  Widget _buildNavItem({
    required IconData icon,
    required int index,
  }) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            icon,
            color: isSelected
                ? AppColors.getButtonTextColor(context)
                : AppColors.getButtonTextColor(context).withOpacity(0.6),
            size: 28, // Increased size for a modern look
          ),
        ],
      ),
    );
  }

  // Build the horizontal list for events (showing top 4 events here)
  Widget _buildEventList(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4, // Show only top 4 events
        itemBuilder: (context, index) {
          return EventCard(
            eventName: 'Dummy Event Name $index', // Example event name
            eventDate: '14th December 2024', // Example date
            eventLocation: 'Borivali', // Example location
            onViewMore: () {
              print("View More button pressed for Event $index");
            },
          ); // Using the EventCard widget
        },
      ),
    );
  }
}
