import 'package:bharatsocials/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class VolunteerDashboard extends StatelessWidget {
  const VolunteerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(
          context), // Dynamic background color based on theme
      appBar: AppBar(
        backgroundColor:
            AppColors.getButtonColor(context), // Dynamic AppBar color
        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: AppColors.getButtonTextColor(
                context), // Dynamic text color for title
          ),
        ),
        actions: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.bell,
              color:
                  AppColors.getButtonTextColor(context), // Dynamic icon color
            ),
            onPressed: () {
              // Handle notification icon press
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
            // Handle menu icon press
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
              Text(
                'Upcoming Events',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: AppColors.getTextColor(
                      context), // Dynamic text color for section title
                ),
              ),
              SizedBox(height: 8),
              _buildEventList(
                  context), // Horizontal ListView for upcoming events
              SizedBox(height: 16),
              Text(
                'Attended Events',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: AppColors.getTextColor(
                      context), // Dynamic text color for section title
                ),
              ),
              SizedBox(height: 8),
              _buildEventList(
                  context), // Horizontal ListView for attended events
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            AppColors.getButtonColor(context), // Dynamic BottomNavBar color
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.house,
              color:
                  AppColors.getButtonTextColor(context), // Dynamic icon color
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.bookmark,
              color:
                  AppColors.getButtonTextColor(context), // Dynamic icon color
            ),
            label: 'Bookmarks',
          ),
        ],
      ),
    );
  }

  Widget _buildEventList(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return _buildEventCard(context); // Each event card
        },
      ),
    );
  }

  Widget _buildEventCard(BuildContext context) {
    // Use dynamic button color from AppColors
    final buttonColor = AppColors.getButtonColor(context);

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: const Color(
            0xFFD9D9D9), // Static grey background for the event card
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
            Text(
              'Name: Dummy Event Name',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.getButtonTextColor(
                    context), // Dynamic text color for event name
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Date: 14th December 2024',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.getButtonTextColor(
                    context), // Dynamic text color for date
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Location: Borivali',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.getButtonTextColor(
                    context), // Dynamic text color for location
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  // Handle "View More" button press
                  print("View More button pressed");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      buttonColor, // Dynamic background color for button
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'View More',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.getButtonTextColor(
                        context), // Dynamic text color for button text
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
