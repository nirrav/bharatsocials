import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:bharatsocials/volunteers/noticeCard.dart';
import 'package:bharatsocials/volunteers/volViewMore.dart';
import 'package:bharatsocials/volunteers/volunteerData.dart';

class EventCard extends StatelessWidget {
  final String eventName;
  final String eventId;
  final String eventDate;
  final String eventTime;
  final String eventLocation;
  final Color cardColor;
  final BuildContext context;

  const EventCard({
    super.key,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.cardColor,
    required this.context,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
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
              style: TextStyle(color: AppColors.eventCardTextColor(context)),
            ),
            const SizedBox(height: 4),
            Text(
              'Event Time: $eventTime',
              style: TextStyle(color: AppColors.eventCardTextColor(context)),
            ),
            const SizedBox(height: 4),
            Text(
              'Event Location: $eventLocation',
              style: TextStyle(color: AppColors.eventCardTextColor(context)),
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
                  MaterialPageRoute(builder: (context) => const Placeholder()),
                );
              },
              child: const Text('View More'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildNoticeBoardFromAdmin(BuildContext context) {
  return FutureBuilder<List<Widget>>(
    future: fetchPostedEventsFromAdmin(context),
    builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16.0), // Add left and right margin to the text
          child: Center(child: CircularProgressIndicator()),
        );
      } else if (snapshot.hasError) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 5.0), // Add left and right margin to the text
          child: Center(child: Text('Error: ${snapshot.error}')),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 5.0), // Add left and right margin to the text
          child: Center(child: Text('No posted events.')),
        );
      } else {
        // Create a list of event widgets
        List<Widget> eventWidgets = snapshot.data!;

        // Find the first NoticeCard (card with date) in the list
        Widget? dateCard;
        for (var widget in eventWidgets) {
          if (widget is NoticeCard) {
            dateCard = widget;
            break;
          }
        }

        // If a dateCard is found, move it to the top of the list
        if (dateCard != null) {
          eventWidgets
              .remove(dateCard); // Remove the card from the original position
          eventWidgets.insert(0, dateCard); // Insert it at the top
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal:
                  0.0), // Remove horizontal margin around the scroll view
          child: SingleChildScrollView(
            child: Column(
              children:
                  eventWidgets, // This will display events vertically in a column
            ),
          ),
        );
      }
    },
  );
}

Future<List<Widget>> fetchPostedEventsFromAdmin(BuildContext context) async {
  // Step 1: Fetch the current user's volunteer data
  VolunteerData? volunteerData = await VolunteerData.fetchVolunteerData();
  if (volunteerData == null) {
    return []; // If the user data is not found, return an empty list
  }

  String collegeName = volunteerData.collegeName;

  // Step 2: Fetch the admin document that matches the collegeName
  QuerySnapshot adminSnapshot = await FirebaseFirestore.instance
      .collection('admins')
      .where('collegeName', isEqualTo: collegeName)
      .get();

  if (adminSnapshot.docs.isEmpty) {
    return []; // If no admin is found for the collegeName, return an empty list
  }

  // Assuming the first matching admin document is the one to use
  String adminId = adminSnapshot.docs.first.id;

  // Step 3: Fetch events hosted by this admin (matching hostId)
  QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
      .collection('events')
      .where('hostId', isEqualTo: adminId)
      .get();

  List<Widget> eventCards = [];

  // Step 4: Loop through the fetched events and create event cards
  for (DocumentSnapshot eventSnapshot in eventSnapshot.docs) {
    DateTime eventDateTime = (eventSnapshot['eventDate'] as Timestamp).toDate();
    String eventTime = eventSnapshot['eventTime'] ?? 'Unknown Time';

    // Add the event card for this event to the list
    eventCards.add(
      Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFAD65), // Hex color for the first gradient color
              Color(0xFFFF7E62), // Hex color for the second gradient color
            ],
            begin:
                Alignment.bottomRight, // Gradient starts from the bottom-right
            end: Alignment.topLeft, // Gradient ends at the top-left
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.3),
              offset: const Offset(0, 10),
              blurRadius: 9,
            ),
          ],
          borderRadius: BorderRadius.circular(25.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Date Section
            Container(
              decoration: BoxDecoration(
                color: AppColors.appBgColor(context),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    offset: const Offset(0, 10),
                    blurRadius: 9,
                  ),
                ],
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('dd').format(eventDateTime),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.titleTextColor(context),
                    ),
                  ),
                  Text(
                    DateFormat('MMMM').format(eventDateTime),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainButtonTextColor(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16), // Space between date and event info
            // Event Info Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventSnapshot['eventName'] ?? 'Unknown Event',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    'Time: $eventTime',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    'Location: ${eventSnapshot['eventLocation'] ?? 'Unknown Location'}',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10),
              child: ElevatedButton(
                onPressed: () {
                  print("Event ${eventSnapshot['eventName']} pressed");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VolunteerEventDetailsPage(
                          eventId: eventSnapshot
                              .id), //Iss me konsa page add karna hai @nirrav  eventId: eventSnapshot.id //wait  okk Got it
                    ),
                  ); //asmit make a new volView more  jiskeo andar show details and the 2 buttons for interedted and not interested ill add te logic later
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.mainButtonColor(context),
                  // backgroundColor:
                  //     AppColors.mainButtonTextColor(context), // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 25 / 2.0, horizontal: 12 / 2.0),
                ),
                child: Icon(Icons.arrow_forward_ios,
                    color: AppColors.iconColor(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  return eventCards; // Return the list of event cards
}
