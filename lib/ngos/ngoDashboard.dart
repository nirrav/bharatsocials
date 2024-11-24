import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/login/userData.dart';
import 'package:bharatsocials/ngos/ngoEventDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bharatsocials/ngos/Sidebar.dart'; // Import the sidebar file
import 'package:bharatsocials/volunteers/NotiPage.dart'; // Import Notification Page
import 'package:bharatsocials/ngos/ngoBroaddcastChannel.dart'; // Import NgoBroadcastChannelScreen
import 'package:bharatsocials/ngos/CreateEvent.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NgoDashboard extends StatefulWidget {
  const NgoDashboard({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<NgoDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Scaffold(body: Center(child: Text('Home Page'))),
    const NotificationPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      _navigateToNgoBroadcastChannelScreen();
    }
  }

  void _navigateToNgoBroadcastChannelScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NgoBroadcastChannelScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dashboard',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
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
                MaterialPageRoute(
                    builder: (context) => const NotificationPage()),
              );
            },
          ),
        ],
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
      drawer: const SlideBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.bullhorn,
              color: Colors.black,
            ),
            label: 'Broadcast Channel',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventFormPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
        GestureDetector(
          onTap: () {
            if (title == 'Upcoming Campaigns') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpcomingCampaignsPage()),
              );
            } else if (title == 'Our Campaigns') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllCampaignsPage()),
              );
            }
          },
          child: const Text(
            'See More..',
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildAllEventsHorizontalList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .snapshots(), // Listen for changes in the 'events' collection
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading events'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No events found.'));
        }

        var events = snapshot.data!.docs.take(3).toList(); // Take only 3 events

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(events.length, (index) {
              DocumentSnapshot event = events[index];

              // Fetch and handle event details
              String eventName = event['eventName'] ?? 'Event Name';
              String eventLocation = event['eventLocation'] ?? 'Event Location';
              String eventDate = 'Event Date';
              if (event['eventDateTime'] != null) {
                Timestamp timestamp =
                    event['eventDateTime']; // Get the timestamp
                DateTime eventDateTime =
                    timestamp.toDate(); // Convert to DateTime
                eventDate = DateFormat('d MMMM yyyy, h:mm a')
                    .format(eventDateTime); // Format the date
              }

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
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
                        eventName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 45, 45, 45),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Event Date: $eventDate',
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Event Location: $eventLocation',
                        style: const TextStyle(color: Colors.black),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NgoEventDetailsPage(
                                  eventId: event.id), // Pass the event ID
                            ),
                          );
                        },
                        child: const Text('View More'),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildUpcomingEventsHorizontalList() {
    DateTime currentDateTime = DateTime.now();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .snapshots(), // Listen for changes in the 'events' collection
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading upcoming events'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No upcoming campaigns available.'));
        }

        // Filter events for upcoming ones
        var events = snapshot.data!.docs.take(3).where((event) {
          if (event['eventDateTime'] != null) {
            Timestamp timestamp = event['eventDateTime']; // Get the timestamp
            DateTime eventDateTime = timestamp.toDate(); // Convert to DateTime
            return eventDateTime.isAfter(currentDateTime); // Only future events
          }
          return false; // Exclude events without a valid date
        }).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(events.length, (index) {
              DocumentSnapshot event = events[index];

              // Fetch and handle event details
              String eventName = event['eventName'] ?? 'Event Name';
              String eventLocation = event['eventLocation'] ?? 'Event Location';
              String eventDate = 'Event Date';
              if (event['eventDateTime'] != null) {
                Timestamp timestamp =
                    event['eventDateTime']; // Get the timestamp
                DateTime eventDateTime =
                    timestamp.toDate(); // Convert to DateTime
                eventDate = DateFormat('d MMMM yyyy, h:mm a')
                    .format(eventDateTime); // Format the date
              }

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
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
                        eventName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 45, 45, 45),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Event Date: $eventDate',
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Event Location: $eventLocation',
                        style: const TextStyle(color: Colors.black),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NgoEventDetailsPage(
                                  eventId: event.id), // Pass the event ID
                            ),
                          );
                        },
                        child: const Text('View More'),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}


class AllCampaignsPage extends StatefulWidget {
  const AllCampaignsPage({super.key});

  @override
  _AllCampaignsPageState createState() => _AllCampaignsPageState();
}

class _AllCampaignsPageState extends State<AllCampaignsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('All Campaigns', style: TextStyle(color: Colors.black)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .orderBy('posted', descending: false) // Order by the 'posted' field, oldest first
            .snapshots(), // Listen for changes in the 'events' collection
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading events'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No events found.'));
          }

          var events = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: events.length,
            itemBuilder: (context, index) {
              DocumentSnapshot event = events[index];

              // Fetch and handle the event details
              String eventName = event['eventName'] ?? 'Event Name';
              String eventLocation = event['eventLocation'] ?? 'Event Location';

              // Handle eventDateTime (timestamp)
              String eventDate = 'Event Date';
              if (event['eventDateTime'] != null) {
                Timestamp timestamp =
                    event['eventDateTime']; // Get the timestamp
                DateTime eventDateTime =
                    timestamp.toDate(); // Convert to DateTime
                eventDate = DateFormat('d MMMM yyyy, h:mm a')
                    .format(eventDateTime); // Format the date
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Card(
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eventName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Event Date: $eventDate'),
                        const SizedBox(height: 8),
                        Text('Event Location: $eventLocation'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to event details or perform any other action
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NgoEventDetailsPage(
                                    eventId: event.id), // Pass the event ID
                              ),
                            );
                          },
                          child: const Text('View More'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventFormPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}



class UpcomingCampaignsPage extends StatefulWidget {
  const UpcomingCampaignsPage({super.key});

  @override
  _UpcomingCampaignsPageState createState() => _UpcomingCampaignsPageState();
}

class _UpcomingCampaignsPageState extends State<UpcomingCampaignsPage> {
  @override
  Widget build(BuildContext context) {
    // Get the current date and time
    DateTime currentDateTime = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Upcoming Campaigns',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .orderBy('eventDateTime', descending: false) // Order events by eventDateTime (ascending)
            .snapshots(), // Listen for changes in the 'events' collection
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading upcoming events'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No upcoming campaigns available.'));
          }

          // Filter the events to show only upcoming ones
          var events = snapshot.data!.docs.where((event) {
            if (event['eventDateTime'] != null) {
              Timestamp timestamp = event['eventDateTime']; // Get the timestamp
              DateTime eventDateTime =
                  timestamp.toDate(); // Convert to DateTime
              return eventDateTime.isAfter(currentDateTime); // Only future events
            }
            return false; // Exclude events without a valid date
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: events.length,
            itemBuilder: (context, index) {
              DocumentSnapshot event = events[index];

              // Fetch and handle the event details
              String eventName = event['eventName'] ?? 'Event Name';
              String eventLocation = event['eventLocation'] ?? 'Event Location';

              // Handle eventDateTime (timestamp)
              String eventDate = 'Event Date';
              if (event['eventDateTime'] != null) {
                Timestamp timestamp =
                    event['eventDateTime']; // Get the timestamp
                DateTime eventDateTime =
                    timestamp.toDate(); // Convert to DateTime
                eventDate = DateFormat('d MMMM yyyy, h:mm a')
                    .format(eventDateTime); // Format the date
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Card(
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eventName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Event Date: $eventDate'),
                        const SizedBox(height: 8),
                        Text('Event Location: $eventLocation'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to event details or perform any other action
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NgoEventDetailsPage(
                                    eventId: event.id), // Pass the event ID
                              ),
                            );
                          },
                          child: const Text('View More'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
