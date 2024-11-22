import 'package:bharatsocials/login/userData.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bharatsocials/ngos/Sidebar.dart';
import 'package:bharatsocials/volunteers/NotiPage.dart';
import 'package:bharatsocials/ngos/boardcastChannel.dart';
import 'package:bharatsocials/ngos/CreateEvent.dart';
import 'package:intl/intl.dart'; // To format the event date

class NgoDashboard extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<NgoDashboard> {
  int _selectedIndex = 0;
  List<DocumentSnapshot> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchUpcomingEvents();
  }

  // Fetch upcoming events from Firestore based on the current user
  Future<void> _fetchUpcomingEvents() async {
    if (GlobalUser.currentUser == null) {
      // Handle the case where there is no current user
      return;
    }

    final currentUser = GlobalUser.currentUser!;

    // Get today's date in timestamp format
    DateTime now = DateTime.now();
    Timestamp timestampNow = Timestamp.fromDate(now);

    // Fetch events from Firestore for the current NGO and with future dates
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('organizationName',
            isEqualTo:
                currentUser.organizationName) // Filter by the current NGO
        .where('eventDateTime',
            isGreaterThanOrEqualTo: timestampNow) // Only future events
        .orderBy('eventDateTime') // Sort by event date
        .get();

    setState(() {
      _events = querySnapshot.docs;
    });
  }

  // Function to handle BottomNavigationBar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NGO Dashboard',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_active,
              color: Colors.black,
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
      drawer: SlideBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Event Section
            _buildSectionHeader(context, title: 'Upcoming Event'),
            SizedBox(height: 8),
            _buildUpcomingEventsList(),
            SizedBox(height: 16),

            // Activity Section (for other use)
            _buildSectionHeader(context, title: 'Activity'),
            SizedBox(height: 8),
            _buildHorizontalList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: Colors.black),
            label: 'Announcements',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventFormPage()),
          );
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
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
          onTap: () {
            // Redirect to a separate page to view all upcoming events
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllUpcomingEventsPage()),
            );
          },
          child: Text(
            'See More..',
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
        ),
      ],
    );
  }

  // Display Upcoming Events
  Widget _buildUpcomingEventsList() {
    if (_events.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          _events.length > 3
              ? 3
              : _events.length, // Show only the first 3 events
          (index) {
            final event = _events[index];
            final eventDateTime =
                (event['eventDateTime'] as Timestamp).toDate();
            final eventDate = DateFormat('yyyy-MM-dd').format(eventDateTime);
            final eventTime = DateFormat('HH:mm').format(eventDateTime);

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
                    Text(
                      event['eventName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 45, 45, 45),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$eventDate at $eventTime',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 4),
                    Text(
                      event['eventLocation'],
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Add functionality for viewing more details about the event
                      },
                      child: Text('View More'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Activity Section Widget (Other content)
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
                  Text(
                    'Activity $index',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 45, 45, 45),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Description of Activity',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: Text('View More'),
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

class AllUpcomingEventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Upcoming Events"),
      ),
      body: Center(
        child: Text('List of all upcoming events will be shown here.'),
      ),
    );
  }
}
