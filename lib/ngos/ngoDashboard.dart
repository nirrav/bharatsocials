import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/BC/CreateEvent.dart';
import 'package:bharatsocials/BC/eventDetails.dart';
import 'package:bharatsocials/BC/broadcastChannel.dart';
import 'package:intl/intl.dart'; // Import NgoBroadcastChannelScreen
import 'package:bharatsocials/ngos/Sidebar.dart'; // Import the sidebar file
import 'package:bharatsocials/volunteers/NotiPage.dart'; // Import Notification Page
// import 'package:bharatsocials/ngos/ngoBroaddcastChannel.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      MaterialPageRoute(builder: (context) => const BroadcastChannel()),
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
      drawer: const NgoSlideBar(),
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
              const SizedBox(height: 16),
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
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.cell_tower_rounded,
              color: AppColors.iconColor(context),
              size: 32.0,
            ),
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
                    'Event Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.eventCardTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Event Date: 12 December 2024, 5:00 PM',
                    style:
                        TextStyle(color: AppColors.eventCardTextColor(context)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Event Location: New York',
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const NgoEventDetailsPage(eventId: 'eventId'),
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
                    'Event Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.eventCardTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Event Date: 12 December 2024, 5:00 PM',
                    style:
                        TextStyle(color: AppColors.eventCardTextColor(context)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Event Location: New York',
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const NgoEventDetailsPage(eventId: 'eventId'),
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
    // Hardcoded event data
    var events = [
      {
        'eventName': 'Event 1',
        'eventLocation': 'New York',
        'eventDateTime': DateTime(2024, 12, 12, 17, 0),
      },
      {
        'eventName': 'Event 2',
        'eventLocation': 'Los Angeles',
        'eventDateTime': DateTime(2024, 12, 15, 18, 30),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.titleColor(context),
        elevation: 8,
        title: Text('All Campaigns',
            style: TextStyle(color: AppColors.titleTextColor(context))),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: events.length,
        itemBuilder: (context, index) {
          var event = events[index];

          // Safely handle eventDateTime and ensure it's a DateTime
          String eventDate = 'Event Date';
          if (event['eventDateTime'] != null) {
            // Check if event['eventDateTime'] is already a DateTime object
            DateTime eventDateTime = event['eventDateTime'] is DateTime
                ? event['eventDateTime'] as DateTime // Cast safely to DateTime
                : DateTime.tryParse(event['eventDateTime'].toString()) ??
                    DateTime.now(); // Fallback to now if parsing fails
            eventDate = DateFormat('d MMMM yyyy, h:mm a').format(eventDateTime);
          }

          // Safely cast eventName and eventLocation to String and provide default values if null
          String eventName = event['eventName'] as String? ?? 'Event Name';
          String eventLocation =
              event['eventLocation'] as String? ?? 'Event Location';

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
                            builder: (context) => const NgoEventDetailsPage(
                                eventId: 'eventId'), // Pass the event ID
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.mainButtonTextColor(context),
                        backgroundColor: AppColors.mainButtonColor(
                            context), // Set text color
                      ),
                      child: const Text('View More'),
                    ),
                  ],
                ),
              ),
            ),
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

    // Hardcoded event data
    var events = [
      {
        'eventName': 'Upcoming Event 1',
        'eventLocation': 'New York',
        'eventDateTime': DateTime(2024, 12, 12, 17, 0),
      },
      {
        'eventName': 'Upcoming Event 2',
        'eventLocation': 'Los Angeles',
        'eventDateTime': DateTime(2024, 12, 15, 18, 30),
      },
    ];

    // Filter upcoming events
    var upcomingEvents = events.where((event) {
      DateTime eventDateTime = event['eventDateTime'] is DateTime
          ? event['eventDateTime'] as DateTime
          : DateTime.tryParse(event['eventDateTime'].toString()) ??
              DateTime.now();
      return eventDateTime.isAfter(currentDateTime);
    }).toList();

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
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: upcomingEvents.length,
        itemBuilder: (context, index) {
          var event = upcomingEvents[index];

          // Safely handle eventDateTime and ensure it's a DateTime
          String eventDate = 'Event Date';
          if (event['eventDateTime'] != null) {
            DateTime eventDateTime = event['eventDateTime'] is DateTime
                ? event['eventDateTime'] as DateTime
                : DateTime.tryParse(event['eventDateTime'].toString()) ??
                    DateTime.now();
            eventDate = DateFormat('d MMMM yyyy, h:mm a').format(eventDateTime);
          }

          // Safely cast eventName and eventLocation to String and provide default values if null
          String eventName = event['eventName'] as String? ?? 'Event Name';
          String eventLocation =
              event['eventLocation'] as String? ?? 'Event Location';

          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NgoEventDetailsPage(
                        eventId: 'eventId'), // Pass the event ID
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
                      Text(
                        eventName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.titleTextColor(context),
                        ),
                      ),
                      const SizedBox(height: 8),
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
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: AppColors.iconColor(context)),
                          const SizedBox(width: 8),
                          Text(
                            eventLocation,
                            style: TextStyle(
                                fontSize: 18,
                                color: AppColors.eventCardTextColor(context)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NgoEventDetailsPage(
                                    eventId: 'eventId'), // Pass the event ID
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainButtonColor(context),
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
                          icon: const Icon(Icons.arrow_forward,
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
      ),
    );
  }
}
