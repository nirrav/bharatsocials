import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/volunteers/NotiPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bharatsocials/broadcastChannel/CreateEvent.dart';
import 'package:bharatsocials/admins/UniAdmin/pendingVolScrens.dart';
import 'package:bharatsocials/admins/CollegeAdmin/CollegeAdminSidebar.dart';

class CaDashboardScreen extends StatefulWidget {
  const CaDashboardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CaDashboardScreenState createState() => _CaDashboardScreenState();
}

class _CaDashboardScreenState extends State<CaDashboardScreen> {
  // Variable to track selected tab
  int _selectedIndex = 0;

  // Function to handle BottomNavigationBar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Check if the bullhorn icon (index 1) is tapped
    if (index == 1) {
      // Simulate the onPressed behavior for the bullhorn icon
      _navigateToBroadcastChannelScreen();
    }
  }

  // Function to navigate to BroadcastChannelScreen
  void _navigateToBroadcastChannelScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('Broadcast Channel')))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.titleColor(context),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the title
          children: [
            Text(
              'College Admin Dashboard',
              style: TextStyle(color: AppColors.titleTextColor(context)),
            ),
          ],
        ),
        actions: [
          // Announcement Icon, navigate to NotificationPage
          IconButton(
            icon: Icon(
              Icons.notifications_active,
              color: AppColors.iconColor(context), // Bullhorn icon color
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationPage()),
              );
            },
          ),
        ],
      ),
      drawer: const AdminSidebar(), // Use the SlideBar widget here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Event Section
            _buildSectionHeader(context, title: 'Upcoming Campaigns'),
            const SizedBox(height: 8),
            _buildUpcomingEventsHorizontalList(),
            const SizedBox(height: 16),

            // Activity Section
            _buildSectionHeader(context, title: 'Our Campaigns'),
            const SizedBox(height: 8),
            _buildAllEventsHorizontalList(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHorizontalButton(
                  'Pending Volunteers',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PendingVolunteerScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Handle tab selection
        onTap: _onItemTapped, // Function to handle tab selection
        backgroundColor: AppColors.titleColor(context),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: AppColors.iconColor(context)),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.bullhorn, // Bullhorn icon from FontAwesome
              color: Colors.black,
            ),
            label: 'Announcements', // Updated label
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.UpcomingeventCardBgColor(context),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Scaffold(
                    body: Center(child: Text('Event Form Page')))),
          );
        },
        child: Icon(Icons.add, color: AppColors.eventCardTextColor(context)),
      ),
    );
  }

  Widget _buildHorizontalButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainButtonColor(context),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Set border radius to 20
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.mainButtonTextColor(
              context), // Text color based on theme
          fontWeight: FontWeight.w600, // Bold text for emphasis
          inherit: true, // Ensure consistent inheritance
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              color: AppColors.defualtTextColor(context), fontSize: 18),
        ),
        GestureDetector(
          onTap: () {
            if (title == 'Upcoming Campaigns') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Scaffold(
                        body: Center(child: Text('Upcoming Campaigns Page')))),
              );
            } else if (title == 'Our Campaigns') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Scaffold(
                        body: Center(child: Text('All Campaigns Page')))),
              );
            }
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
                color: AppColors.AlleventCardBgColor(context),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
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
                      color: AppColors.eventCardTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Event Date: 10 December 2024',
                    style: TextStyle(
                      color: AppColors.eventCardTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Event Location: New York City',
                    style: TextStyle(
                      color: AppColors.eventCardTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainButtonColor(context),
                      foregroundColor: AppColors.mainButtonTextColor(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
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
                color: AppColors.UpcomingeventCardBgColor(context),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
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
                      color: AppColors.eventCardTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Event Date: 12 December 2024',
                    style:
                        TextStyle(color: AppColors.eventCardTextColor(context)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Event Location: Los Angeles',
                    style:
                        TextStyle(color: AppColors.eventCardTextColor(context)),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainButtonColor(context),
                      foregroundColor: AppColors.mainButtonTextColor(context),
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
}

class AllCampaignsPage extends StatelessWidget {
  const AllCampaignsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.titleColor(context),
        elevation: 8,
        title: Text('All Campaigns',
            style: TextStyle(color: AppColors.titleTextColor(context))),
      ),
      body: const Center(
        child: Text('Display All Campaigns Here'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.UpcomingeventCardBgColor(context),
        onPressed: () {
          // Navigate to event creation page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventFormPage()),
          );
        },
        child: Icon(Icons.add, color: AppColors.iconColor(context)),
      ),
    );
  }
}

class UpcomingCampaignsPage extends StatelessWidget {
  const UpcomingCampaignsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor(context),
        title: Text(
          'Upcoming Campaigns',
          style: TextStyle(
            color: AppColors.titleTextColor(context),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevation: 10,
      ),
      body: const Center(
        child: Text('Display Upcoming Campaigns Here'),
      ),
    );
  }
}
