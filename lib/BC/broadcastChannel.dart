import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bharatsocials/BC/CreateEvent.dart';
import 'package:bharatsocials/BC/eventDetails.dart';
import 'package:bharatsocials/ngos/ngoDashboard.dart';

class BroadcastChannel extends StatefulWidget {
  const BroadcastChannel({super.key});

  @override
  _BroadcastChannelState createState() => _BroadcastChannelState();
}

class _BroadcastChannelState extends State<BroadcastChannel> {
  int _selectedIndex = 1;
  final ScrollController _scrollController = ScrollController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      _navigateToBroadcastChannel();
    }
  }

  void _navigateToBroadcastChannel() {
    // Static navigation logic
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NgoDashboard()),
    );
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
        backgroundColor: AppColors.titleColor(context),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Broadcast Channel',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.titleTextColor(context),
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
              child: ListView.builder(
                itemCount: 10, // Hardcoded for 10 events
                itemBuilder: (context, index) {
                  // Hardcoded event data
                  String eventName = 'Event $index';
                  DateTime eventDate =
                      DateTime.now().add(Duration(days: index));
                  String eventLocation = 'Location $index';
                  bool isSelfSent = index % 2 == 0; // Even index is self-sent

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Align(
                      alignment: isSelfSent
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: EventCard(
                        width: screenWidth * 0.70,
                        height: screenHeight * 0.22,
                        textColor: textColor,
                        eventName: eventName,
                        eventDate: eventDate,
                        eventLocation: eventLocation,
                        eventId: 'event$index',
                        isSelfSent: isSelfSent,
                        isReadByUser: false, // Hardcoded as false
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
            icon: FaIcon(
              FontAwesomeIcons.bullhorn,
              color: AppColors.iconColor(context),
              size: 22.0,
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
  final bool isReadByUser;

  const EventCard({
    super.key,
    required this.width,
    required this.height,
    required this.textColor,
    required this.eventName,
    required this.eventDate,
    required this.eventLocation,
    required this.eventId,
    required this.isSelfSent,
    required this.isReadByUser,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor = isSelfSent
        ? AppColors.UpcomingeventCardBgColor(context)
        : AppColors.UpcomingeventCardBgColor(context);

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
              top: isReadByUser || isSelfSent ? 16.0 : 32.0,
            ),
            alignment: cardAlignment,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the event details
                Text(
                  eventName,
                  style: TextStyle(
                    color: AppColors.eventCardTextColor(context),
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
                    color: AppColors.eventCardTextColor(context),
                    fontSize: 16,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Location: $eventLocation',
                  style: TextStyle(
                    color: AppColors.eventCardTextColor(context),
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
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
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
        ],
      ),
    );
  }
}
