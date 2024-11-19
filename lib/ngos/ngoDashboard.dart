// lib/screens/ngo_dashboard.dart

import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/common_widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class NGODashboard extends StatefulWidget {
  const NGODashboard({super.key});

  @override
  _NGODashboardState createState() => _NGODashboardState();
}

class _NGODashboardState extends State<NGODashboard> {
  int _selectedIndex = 0; // Tracking the selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.getBackgroundColor(context), // Dynamic background color
      appBar: AppBar(
        backgroundColor:
            AppColors.getButtonColor(context), // Dynamic AppBar color
        title: Text(
          'NGO Dashboard',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: AppColors.getButtonTextColor(
                context), // Dynamic text color for title
          ),
        ),
        centerTitle: true, // This will center the title in the AppBar
        actions: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.bell,
              color:
                  AppColors.getButtonTextColor(context), // Dynamic icon color
            ),
            onPressed: () {
              print("Notification icon pressed");
            },
          ),
        ],
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.bars,
            color: AppColors.getButtonTextColor(context), // Dynamic icon color
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
                    'Upcoming Campaigns',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: AppColors.getTextColor(
                          context), // Dynamic text color for section title
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("View All... Upcoming Campaigns tapped");
                    },
                    child: Text(
                      'View All...',
                      style: TextStyle(
                        color: Colors.blue, // Blue color for "View All..."
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildEventList(
                  context), // Horizontal ListView for upcoming events
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Our Campaigns',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: AppColors.getTextColor(
                          context), // Dynamic text color for section title
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("View All... Attended Campaigns tapped");
                    },
                    child: Text(
                      'View All...',
                      style: TextStyle(
                        color: Colors.blue, // Blue color for "View All..."
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildEventList(
                  context), // Horizontal ListView for attended events
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.getButtonColor(context),
        elevation: 8, // Adding elevation for modern effect
        shape: CircularNotchedRectangle(), // Optional: rounded corners
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 48.0, vertical: 8), // Adjusted padding
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

  // Build the horizontal list for events
  Widget _buildEventList(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return EventCard(
            eventName: 'Dummy Event Name', // Pass your event name here
            eventDate: '14th December 2024', // Pass your event date here
            eventLocation: 'Borivali', // Pass your event location here
            onViewMore: () {
              print("View More button pressed");
            },
          ); // Using the EventCard widget
        },
      ),
    );
  }
}
