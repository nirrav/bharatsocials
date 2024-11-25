import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/BC/CreateEvent.dart';
import 'package:bharatsocials/BC/eventDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bharatsocials/BC/broadcastChannel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bharatsocials/ngos/Sidebar.dart'; // Import the sidebar file
import 'package:bharatsocials/volunteers/NotiPage.dart'; // Import Notification Page
import 'package:bharatsocials/ngos/ngoBroaddcastChannel.dart'; // Import NgoBroadcastChannelScreen

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
      MaterialPageRoute(builder: (context) => BroadcastChannel()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.titleColor(context),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NGO Dashboard',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.titleTextColor(context),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_active_outlined,
              color: AppColors.iconColor(context),
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
      drawer: NgoSlideBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, title: 'Upcoming Campaigns'),
              const SizedBox(height: 18),
              _buildUpcomingEventsHorizontalList(),
              const SizedBox(height: 16),
              _buildSectionHeader(context, title: 'Our Campaigns'),
              const SizedBox(height: 16),
              _buildAllEventsHorizontalList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: AppColors.titleColor(context),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
              color: AppColors.iconColor(context),
              size: 32.0,
            ),
            // icon: Icon(
            //   Icons.home_outlined,
            //   color: AppColors.iconColor(context),
            //   size: 32.0,
            // ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.cell_tower_rounded,
              color: AppColors.iconColor(context),
              size: 32.0,
            ),
            // icon: Icon(
            //   Icons.cell_tower_outlined,
            //   color: AppColors.iconColor(context),
            //   size: 32.0,
            // ),
            label: 'Broadcast Channel',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.titleColor(context),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventFormPage()),
          );
        },
        child: Icon(Icons.add, color: AppColors.titleTextColor(context)),
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
              fontWeight: FontWeight.w800,
              color: AppColors.defualtTextColor(context),
              fontSize: 20),
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
          child: Text(
            'View More..',
            style: TextStyle(
              color: AppColors.subTextColor(context),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
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
                    color: AppColors.AlleventCardBgColor(context),
                    borderRadius: BorderRadius.circular(20),
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
                      SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainButtonColor(context),
                          foregroundColor:
                              AppColors.mainButtonTextColor(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
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
                    color: AppColors.UpcomingeventCardBgColor(context),
                    borderRadius: BorderRadius.circular(20),
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
                            borderRadius: BorderRadius.circular(16),
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
            .orderBy('posted',
                descending: false) // Order by the 'posted' field, oldest first
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
        backgroundColor: AppColors.appBgColor(context),
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
                      borderRadius: BorderRadius.circular(20.0),
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
                                  borderRadius: BorderRadius.circular(16.0),
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
