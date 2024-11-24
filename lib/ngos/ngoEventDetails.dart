import 'package:bharatsocials/volunteers/NotiPage.dart'; // If any specific imports are required
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NgoEventDetailsPage extends StatefulWidget {
  final String eventId; // Event ID passed from the previous page

  const NgoEventDetailsPage(
      {super.key, required this.eventId}); // Constructor to accept event ID

  @override
  _NgoEventDetailsPageState createState() => _NgoEventDetailsPageState();
}

class _NgoEventDetailsPageState extends State<NgoEventDetailsPage> {
  late DocumentSnapshot
      eventDetails; // To store the event details fetched from Firestore
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEventDetails();
  }

  // Fetch the event details from Firestore based on the eventId
  Future<void> _loadEventDetails() async {
    try {
      DocumentSnapshot eventDoc = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId) // Using the eventId passed to the page
          .get();

      setState(() {
        eventDetails = eventDoc;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading event details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Event Details', style: TextStyle(color: Colors.black)),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Extract event details for display
    String eventName = eventDetails['eventName'] ?? 'No Event Name';
    String eventLocation = eventDetails['eventLocation'] ?? 'No Event Location';
    String eventDate = 'Event Date not available';
    if (eventDetails['eventDateTime'] != null) {
      Timestamp timestamp = eventDetails['eventDateTime'];
      DateTime eventDateTime = timestamp.toDate();
      eventDate = DateFormat('d MMMM yyyy, h:mm a').format(eventDateTime);
    }

    bool foodProvided = eventDetails['foodProvided'] ?? false;
    bool safetyEquipment = eventDetails['safetyEquipment'] ?? false;
    bool waterProvided = eventDetails['waterProvided'] ?? false;

    String hostName = eventDetails['hostName'] ?? 'No Host Name';
    String pocFullName = eventDetails['pocFullName'] ?? 'No Contact Name';
    String pocLocation = eventDetails['pocLocation'] ?? 'No Contact Location';
    String pocNumber = eventDetails['pocNumber'] ?? 'No Contact Number';
    int requiredVolunteers = eventDetails['requiredVolunteers'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Event Details', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eventName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Location: $eventLocation',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Text(
                'Date: $eventDate',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              Divider(height: 32, color: Colors.grey[400]),

              // Contact Information Section
              const Text(
                'Contact Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Point of Contact: $pocFullName'),
              Text('Location: $pocLocation'),
              Text('Phone: $pocNumber'),
              const SizedBox(height: 16),

              // Host Information Section
              const Text(
                'Host Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Host: $hostName'),
              const SizedBox(height: 16),

              // Event Specific Details Section
              const Text(
                'Event Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Required Volunteers: $requiredVolunteers'),
              Text('Food Provided: ${foodProvided ? "Yes" : "No"}'),
              Text('Safety Equipment: ${safetyEquipment ? "Yes" : "No"}'),
              Text('Water Provided: ${waterProvided ? "Yes" : "No"}'),
            ],
          ),
        ),
      ),
    );
  }
}
