import 'dart:ui';
import 'package:bharatsocials/common_widgets/upcoming_events_page.dart';
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
      backgroundColor: AppColors.appBgColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.titleColor(context),
        centerTitle: true,
        title: Text(
          'Vol Dashboard',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: AppColors.titleTextColor(context),
          ),
        ),
        actions: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.bell,
              color: AppColors.titleTextColor(context),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationPage()),
              );
            },
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: FaIcon(
              FontAwesomeIcons.bars,
              color: AppColors.iconColor(context),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the sidebar
            },
          ),
        ),
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

      drawer: const VolunteerSidebar(), // Adding the sidebar
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
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
                      color: AppColors.defualtTextColor(context),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllEventsPage(),
                        ),
                      );
                    },
                    child: Text(
                      'View All...',
                      style: TextStyle(
                        color: AppColors.subTextColor(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildEventList(context),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Attended Events',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: AppColors.defualtTextColor(context),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("View All... Attended Events tapped");
                    },
                    child: Text(
                      'View All...',
                      style: TextStyle(
                        color: AppColors.subTextColor(context),
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Divider with conditional color based on theme
          Divider(
            color: AppColors.dividerColor(context), // Color based on theme
            thickness: 1,
            height: 1,
          ),
          BottomAppBar(
            color: AppColors.titleColor(context),
            shape: const CircularNotchedRectangle(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 8),
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
        ],
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
                ? AppColors.iconColor(context)
                : AppColors.iconColor(context).withOpacity(0.6),
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
