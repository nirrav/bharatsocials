import 'package:flutter/material.dart';
import 'package:bharatsocials/ngos/CreateEvent.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bharatsocials/ngos/Sidebar.dart'; // Import the sidebar file
import 'package:bharatsocials/volunteers/NotiPage.dart'; // Import Notification Page
import 'package:bharatsocials/ngos/boardcastChannel.dart'; // Import BroadcastChannelScreen



class CaDashboardScreen extends StatefulWidget {
  @override
  _CaDashboardScreenState createState() => _CaDashboardScreenState();
}

class _CaDashboardScreenState extends State<CaDashboardScreen> {
  // Variable to track selected tab
  int _selectedIndex = 0;

  // Pages to show based on selected index
  final List<Widget> _pages = [
    // Home Page (Placeholder for now)
    Scaffold(body: Center(child: Text('Home Page'))),
    // Notifications Page (NotiPage)
    NotificationPage(),
  ];

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
      MaterialPageRoute(builder: (context) => BroadcastChannelScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the title
          children: [
            Text(
              'Dashboard',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          // Announcement Icon, navigate to NotificationPage
          IconButton(
            icon: const Icon(
              Icons.notifications_active,
              color: Colors.black, // Bullhorn icon color
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      drawer: SlideBar(), // Use the SlideBar widget here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Event Section
            _buildSectionHeader(context, title: 'Upcoming Event'),
            SizedBox(height: 8),
            _buildHorizontalList(),
            SizedBox(height: 16),

            // Activity Section
            _buildSectionHeader(context, title: 'Activity'),
            SizedBox(height: 8),
            _buildHorizontalList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Handle tab selection
        onTap: _onItemTapped, // Function to handle tab selection
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.bullhorn, // Bullhorn icon from FontAwesome
              color: Colors.black,
            ),
            label: 'Announcements', // Updated label
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.white,
      //   onPressed: () {
      //    Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => MyCustomForm()),
      //     );
      //   }, // Add functionality for FAB
      //   child: Icon(Icons.add, color: Colors.black),
      // ),
    );
  }

  // Section Header Widget
  Widget _buildSectionHeader(BuildContext context, {required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        GestureDetector(
          onTap: () {}, // Add functionality here
          child: Text(
            'See More..',
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
        ),
      ],
    );
  }

  // Horizontal List Widget
  Widget _buildHorizontalList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 250,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(2, 2),
                    blurRadius: 4,
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
                      color:
                          Color.fromARGB(255, 45, 45, 45), // Updated text color
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Event Date',
                    style: TextStyle(
                      color: Colors.black, // Updated text color
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Event Location',
                    style: TextStyle(
                      color: Colors.black, // Updated text color
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {}, // Add functionality
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
