import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/login/userData.dart';
import 'package:bharatsocials/ngos/CreateEvent.dart';
import 'package:bharatsocials/ngos/Sidebar.dart';
import 'package:bharatsocials/ngos/ngoDashboard.dart';
import 'package:bharatsocials/ngos/ngoEventDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class NgoBroadcastChannelScreen extends StatefulWidget {
  const NgoBroadcastChannelScreen({super.key});

  @override
  _NgoBroadcastChannelScreenState createState() =>
      _NgoBroadcastChannelScreenState();
}

class _NgoBroadcastChannelScreenState extends State<NgoBroadcastChannelScreen> {
  int _selectedIndex = 1;
  String? currentUserId;
  ScrollController _scrollController = ScrollController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      _navigateToNgoBroadcastChannelScreen();
    }
  }

  void _navigateToNgoBroadcastChannelScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NgoDashboard()),
    );
  }

  @override
  void initState() {
    super.initState();
    currentUserId = GlobalUser.currentUser?.documentId; // Get current user ID
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = AppColors.appBgColor(context);
    Color textColor = AppColors.defualtTextColor(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Broadcast Channel',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // Divider height
          child: Divider(
            color: AppColors.dividerColor(context),
            thickness: 1,
            height: 1,
          ),
        ),
      ),
      body: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .orderBy('posted',
                        descending: false) // Sort from oldest to newest
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong!'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No events posted yet.'));
                  }

                  var events = snapshot.data!.docs;

                  // After loading, scroll to the bottom (latest event)
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    }
                  });

                  return ListView(
                    controller: _scrollController,
                    reverse:
                        false, // This makes the ListView scroll from top to bottom
                    children: events.map((event) {
                      bool isSelfSent = event['hostId'] == currentUserId;

                      // Check if the current user has read this event
                      List<dynamic> readBy = event['readBy'] ?? [];
                      bool isReadByUser = readBy.contains(currentUserId);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Align(
                          alignment: isSelfSent
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: EventCard(
                            width: screenWidth * 0.70,
                            height: screenHeight * 0.22,
                            textColor: textColor,
                            eventName: event['eventName'],
                            eventDate: event['eventDateTime'].toDate(),
                            eventLocation: event['eventLocation'],
                            eventId: event.id,
                            isSelfSent: isSelfSent,
                            isReadByUser: isReadByUser, // Pass read status
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
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
    );
  }
}

class EventCard extends StatelessWidget {
  final double width;
  final double height;
  final Color textColor;
  final String eventName;
  final DateTime eventDate;
  final String eventLocation;
  final String eventId;
  final bool isSelfSent;
  final bool isReadByUser; // New parameter

  const EventCard({
    required this.width,
    required this.height,
    required this.textColor,
    required this.eventName,
    required this.eventDate,
    required this.eventLocation,
    required this.eventId,
    required this.isSelfSent,
    required this.isReadByUser, // Initialize isReadByUser
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor = isSelfSent
        ? AppColors.eventCardBgColor(context)
        : AppColors.eventCardBgColor(context);

    Alignment cardAlignment =
        isSelfSent ? Alignment.centerRight : Alignment.centerLeft;

    return Card(
      color: cardColor,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      child: Stack(
        children: [
          // The event card content
          Container(
            width: width,
            height: height,
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: isReadByUser ? 16.0 : 32.0, // Conditionally add top padding
            ),
            alignment: cardAlignment,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the event details
                Text(
                  eventName,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  'Date: ${eventDate.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Location: $eventLocation',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainButtonColor(context),
                    foregroundColor: AppColors.mainButtonTextColor(context),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    // Update 'readBy' array when the user views the event
                    FirebaseFirestore.instance
                        .collection('events')
                        .doc(eventId)
                        .update({
                      'readBy': FieldValue.arrayUnion(
                          [GlobalUser.currentUser?.documentId])
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NgoEventDetailsPage(eventId: eventId),
                      ),
                    );
                  },
                  child: Text(
                    'View More',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Show a "NEW" badge for unread messages
          if (!isReadByUser)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.red, // Red background to indicate unread
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'NEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
