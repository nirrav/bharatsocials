import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/volunteers/sidebar.dart';
import 'package:bharatsocials/volunteers/NotiPage.dart';
import 'package:bharatsocials/volunteers/savedPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bharatsocials/common_widgets/event_details.dart';
import 'package:bharatsocials/common_widgets/event_card.dart' as commonWidgets;

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

    if (index == 1) {
      // Navigate to the SavedPage when the saved icon is tapped
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SavedEventsPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.getButtonColor(context),
        centerTitle: true,
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          )
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: FaIcon(
              FontAwesomeIcons.bars,
              color: AppColors.getButtonTextColor(context),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the sidebar
            },
          ),
        ),
      ),
      drawer: const Sidebar(), // Adding the sidebar
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EventDetailsPage(),
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
              _buildEventList(context),
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
        elevation: 8,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 8),
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
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildEventList(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return commonWidgets.EventCard(
            eventName: 'Dummy Event Name $index',
            eventDate: '14th December 2024',
            eventLocation: 'Borivali',
          );
        },
      ),
    );
  }
}
