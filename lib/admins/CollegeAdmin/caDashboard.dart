import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bharatsocials/login/userData.dart';
import 'package:bharatsocials/BC/CreateEvent.dart';
import 'package:bharatsocials/BC/eventDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bharatsocials/BC/broadcastChannel.dart';
import 'package:bharatsocials/admins/adminSidebar.dart';
import 'package:bharatsocials/volunteers/NotiPage.dart';
import 'package:intl/intl.dart'; // Import Notification Page
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      MaterialPageRoute(builder: (context) => const BroadcastChannel()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentUserId =
        GlobalUser.currentUser?.documentId; // Get current user ID
    var currentUserRole = GlobalUser.currentUser?.role; // Get current user ID
    var currentAdminRole =
        GlobalUser.currentUser?.adminRole; // Get current user ID
    print('Current user id is $currentUserId');
    print('Current user role is $currentUserRole');
    print('Current admin role is $currentAdminRole');
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
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      drawer: AdminSidebar(), // Use the SlideBar widget here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Event Section
            _buildSectionHeader(context, title: 'Upcoming Campaigns'),
            SizedBox(height: 8),
            _buildUpcomingEventsHorizontalList(),
            SizedBox(height: 16),

            // Activity Section
            _buildSectionHeader(context, title: 'Our Campaigns'),
            SizedBox(height: 8),
            _buildAllEventsHorizontalList(),
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
          BottomNavigationBarItem(
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
            MaterialPageRoute(builder: (context) => const EventFormPage()),
          );
        },
        child: Icon(Icons.add, color: AppColors.eventCardTextColor(context)),
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
                    builder: (context) => const UpcomingCampaignsPage()),
              );
            } else if (title == 'Our Campaigns') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AllCampaignsPage()),
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
    // Get the current user ID
    var currentUserId =
        GlobalUser.currentUser?.documentId; // Get current user ID

    if (currentUserId == null) {
      return const Center(child: Text('User is not logged in.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where('hostId', isEqualTo: currentUserId) // Filter events by hostId
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
                        eventName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.eventCardTextColor(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Event Date: $eventDate',
                        style: TextStyle(
                          color: AppColors.eventCardTextColor(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Event Location: $eventLocation',
                        style: TextStyle(
                          color: AppColors.eventCardTextColor(context),
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainButtonColor(context),
                          foregroundColor:
                              AppColors.mainButtonTextColor(context),
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

    // Check if the currentUser is available
    if (GlobalUser.currentUser == null) {
      return const Center(child: Text('User data not available.'));
    }

    // Get the upcoming events from the current user's data
    List<String> upcomingEventIds = GlobalUser.currentUser!.eventsPosted;

    if (upcomingEventIds.isEmpty) {
      return const Center(child: Text('No upcoming campaigns available.'));
    }

    // Fetch events based on event IDs from Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where(FieldPath.documentId,
              whereIn: upcomingEventIds) // Fetch events by IDs
          .snapshots(), // Listen for changes in the events collection for these specific event IDs
      builder: (context, eventSnapshot) {
        if (eventSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (eventSnapshot.hasError) {
          return const Center(child: Text('Error loading upcoming events'));
        }

        if (!eventSnapshot.hasData || eventSnapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No upcoming campaigns available.'));
        }

        var events = eventSnapshot.data!.docs;

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
                        eventName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.eventCardTextColor(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Event Date: $eventDate',
                        style: TextStyle(
                            color: AppColors.eventCardTextColor(context)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Event Location: $eventLocation',
                        style: TextStyle(
                            color: AppColors.eventCardTextColor(context)),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainButtonColor(context),
                          foregroundColor:
                              AppColors.mainButtonTextColor(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('View More'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NgoEventDetailsPage(
                                  eventId: event.id), // Pass the event ID
                            ),
                          );
                        },
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
    // Get the current user ID
    var currentUserId =
        GlobalUser.currentUser?.documentId; // Get current user ID

    if (currentUserId == null) {
      return const Center(child: Text('User is not logged in.'));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.titleColor(context),
        elevation: 8,
        title: Text('All Campaigns',
            style: TextStyle(color: AppColors.titleTextColor(context))),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .where('hostId', isEqualTo: currentUserId) // Filter by hostId
            .orderBy('posted',
                descending: false) // Order by 'posted' field, oldest first
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
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Card(
                  color: AppColors.AlleventCardBgColor(context),
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
                                  eventId: event.id, // Pass the event ID
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                AppColors.mainButtonTextColor(context),
                            backgroundColor: AppColors.mainButtonColor(
                                context), // Set text color
                          ),
                          child: Text('View More'),
                        )
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
        backgroundColor: AppColors.UpcomingeventCardBgColor(context),
        onPressed: () {
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

class UpcomingCampaignsPage extends StatefulWidget {
  const UpcomingCampaignsPage({super.key});

  @override
  _UpcomingCampaignsPageState createState() => _UpcomingCampaignsPageState();
}

class _UpcomingCampaignsPageState extends State<UpcomingCampaignsPage> {
  @override
  Widget build(BuildContext context) {
    DateTime currentDateTime = DateTime.now();

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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .orderBy('eventDateTime', descending: false)
            .snapshots(),
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

          var events = snapshot.data!.docs.where((event) {
            if (event['eventDateTime'] != null) {
              Timestamp timestamp = event['eventDateTime'];
              DateTime eventDateTime = timestamp.toDate();
              return eventDateTime.isAfter(currentDateTime);
            }
            return false;
          }).toList();

          return ListView.builder(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: events.length,
            itemBuilder: (context, index) {
              DocumentSnapshot event = events[index];

              String eventName = event['eventName'] ?? 'Event Name';
              String eventLocation = event['eventLocation'] ?? 'Event Location';
              String eventDate = 'Event Date';
              if (event['eventDateTime'] != null) {
                Timestamp timestamp = event['eventDateTime'];
                DateTime eventDateTime = timestamp.toDate();
                eventDate =
                    DateFormat('d MMMM yyyy, h:mm a').format(eventDateTime);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NgoEventDetailsPage(eventId: event.id),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: AppColors.UpcomingeventCardBgColor(context),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event Title
                          Text(
                            eventName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColors.titleTextColor(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Event Date
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: AppColors.iconColor(context)),
                              const SizedBox(width: 8),
                              Text(
                                eventDate,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.titleTextColor(context)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Event Location
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: AppColors.iconColor(context)),
                              const SizedBox(width: 8),
                              Text(
                                eventLocation,
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        AppColors.eventCardTextColor(context)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // "View More" Button
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NgoEventDetailsPage(eventId: event.id),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.mainButtonColor(context),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              label: Text(
                                'View More',
                                style: TextStyle(
                                  color: AppColors.mainButtonTextColor(context),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              icon: Icon(Icons.arrow_forward,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
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
