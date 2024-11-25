import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/login/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NgoEventDetailsPage extends StatefulWidget {
  final String eventId; // Event ID passed from the previous page

  const NgoEventDetailsPage({super.key, required this.eventId});

  @override
  _NgoEventDetailsPageState createState() => _NgoEventDetailsPageState();
}

class _NgoEventDetailsPageState extends State<NgoEventDetailsPage> {
  late DocumentSnapshot eventDetails;
  bool isLoading = true;
  String? currentUserId;
  String? currentUserRole;
  String? currentAdminRole;
  @override
  void initState() {
    super.initState();
    _loadEventDetails();
    currentUserId = GlobalUser.currentUser?.documentId; // Get current user ID
    currentUserRole = GlobalUser.currentUser?.role; // Get current user ID
    currentAdminRole = GlobalUser.currentUser?.adminRole; // Get current user ID
    print('Current user id is $currentUserId');
    print('Current user role is $currentUserRole');
    print('Current admin role is $currentAdminRole');
  }

  void _showDenyConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to deny this event?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add your deny action here
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void _showAcceptForm(BuildContext context, String eventId) {
    TextEditingController volunteersController = TextEditingController();
    TextEditingController eventHoursController = TextEditingController();
    String selectedEventType = 'Orientation'; // Default event type
    bool sendToVolunteer = false;
    bool hasAlreadySubmitted = false; // Track if the user has already submitted

    // Check if the current user has already expressed interest for this event
    String currentUserId = GlobalUser.currentUser?.documentId ?? '';
    FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .collection('submissions')
        .where('userId', isEqualTo: currentUserId)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        hasAlreadySubmitted = true;
      }
      // Show the dialog after checking submission status
      _showDialog(context, eventId, volunteersController, eventHoursController,
          selectedEventType, sendToVolunteer, hasAlreadySubmitted);
    });
  }

  void _showDialog(
      BuildContext context,
      String eventId,
      TextEditingController volunteersController,
      TextEditingController eventHoursController,
      String selectedEventType,
      bool sendToVolunteer,
      bool hasAlreadySubmitted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fill the Event Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                if (hasAlreadySubmitted)
                  // If the user has already submitted, show a message
                  Text(
                    'You have already expressed interest in this event.',
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                SizedBox(height: 12),
                TextField(
                  controller: volunteersController,
                  decoration: InputDecoration(
                    labelText: 'How many volunteers do you want to send?',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  enabled: !hasAlreadySubmitted, // Disable if already submitted
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: sendToVolunteer,
                      onChanged: hasAlreadySubmitted
                          ? null
                          : (bool? value) {
                              sendToVolunteer = value ?? false;
                            },
                    ),
                    Text('Send to volunteer'),
                  ],
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Event Type',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedEventType,
                  items: [
                    'Orientation',
                    'College Campus',
                    'University',
                    'Community/Adopted Area'
                  ]
                      .map((eventType) => DropdownMenuItem(
                            value: eventType,
                            child: Text(eventType),
                          ))
                      .toList(),
                  onChanged: hasAlreadySubmitted
                      ? null // Disable if already submitted
                      : (String? newValue) {
                          selectedEventType = newValue ?? 'Orientation';
                        },
                ),
                SizedBox(height: 12),
                TextField(
                  controller: eventHoursController,
                  decoration: InputDecoration(
                    labelText: 'Event Hours',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  enabled: !hasAlreadySubmitted, // Disable if already submitted
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: hasAlreadySubmitted
                          ? null // Disable the submit button if already submitted
                          : () {
                              // Fetch the current user info (ID, college)
                              String currentUserId =
                                  GlobalUser.currentUser?.documentId ?? '';
                              String currentAdminCollege =
                                  GlobalUser.currentUser?.collegeName ?? '';

                              // Ensure all fields are filled before submission
                              if (volunteersController.text.isNotEmpty &&
                                  eventHoursController.text.isNotEmpty) {
                                // Call the CollegeSubmission function to save the data
                                CollegeSubmission(
                                  eventId,
                                  currentUserId,
                                  currentAdminCollege,
                                  int.parse(volunteersController.text),
                                  selectedEventType,
                                  int.parse(eventHoursController.text),
                                  sendToVolunteer,
                                );
                              }
                              Navigator.pop(context); // Close the dialog
                            },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void CollegeSubmission(
      String eventId,
      String currentUserId,
      String currentAdminCollege,
      int volunteersCount,
      String eventType,
      int eventHours,
      bool sendToVolunteer) async {
    try {
      // Reference to the 'submissions' sub-collection of the event document
      CollectionReference submissions = FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .collection('submissions');

      // Create a new submission document with the data
      await submissions.add({
        'userId': currentUserId,
        'collegeName': currentAdminCollege,
        'volunteersCount': volunteersCount,
        'eventType': eventType,
        'eventHours': eventHours,
        'sendToVolunteer': sendToVolunteer,
        'status': 'Pending', // You can default to 'Pending' or other status
        'timestamp':
            FieldValue.serverTimestamp(), // Store the time of submission
      });

      print("Submission successfully added!");

      // Reference to the admin document (assuming currentAdminCollege is used to find the admin)
      DocumentReference adminDoc = FirebaseFirestore.instance
          .collection('admins') // Collection that holds admin documents
          .doc(
              currentUserId); // Assuming the admin's document ID is the college name

      // Get the admin document to check for the existing upcomingEvents array
      DocumentSnapshot adminSnapshot = await adminDoc.get();

      // Check if the admin document exists and if it has an upcomingEvents array
      if (adminSnapshot.exists) {
        List<dynamic> upcomingEvents = adminSnapshot['upcomingEvents'] ?? [];

        // Check if the eventId is already in the array, if not, add it
        if (!upcomingEvents.contains(eventId)) {
          upcomingEvents.add(eventId);

          // Update the admin document with the new upcomingEvents array
          await adminDoc.update({
            'upcomingEvents': upcomingEvents,
          });

          print("Admin's upcoming events updated with event ID: $eventId");
        } else {
          print("Event ID is already in the upcoming events array.");
        }
      } else {
        print("Admin document does not exist for the given college.");
      }
    } catch (e) {
      print("Error submitting event details: $e");
    }
  }

  Future<void> _loadEventDetails() async {
    try {
      DocumentSnapshot eventDoc = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
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
          backgroundColor: AppColors.titleColor(context),
          title: Text('Event Details',
              style: TextStyle(color: AppColors.titleTextColor(context))),
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

    final currentUser = GlobalUser.currentUser;
    final isNgo = currentUser?.role == 'ngo';

    return Scaffold(
      backgroundColor: AppColors.titleColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.titleColor(context),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.iconColor(context)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Event Details',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.titleTextColor(context),
          ),
        ),
        centerTitle: true,
        elevation: 8,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(
              color: AppColors.dividerColor(context), thickness: 1, height: 1),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image (Optional: can add if available)
              // You can uncomment the following section if you want to display an event image.
              // Container(
              //   height: 250,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: NetworkImage(eventDetails['eventImage'] ?? 'https://via.placeholder.com/250'),
              //       fit: BoxFit.cover,
              //     ),
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              // ),
              // const SizedBox(height: 20),

              // Primary Event Information
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Event Header Card
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColors.UpcomingeventCardBgColor(context),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 16,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Event: $eventName',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppColors.titleTextColor(context),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: AppColors.iconColor(context)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Location: $eventLocation',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color:
                                          AppColors.defualtTextColor(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    color: AppColors.iconColor(context)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Date: $eventDate',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color:
                                          AppColors.defualtTextColor(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.group,
                                    color: AppColors.iconColor(context)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Required Volunteers: $requiredVolunteers',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color:
                                          AppColors.defualtTextColor(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Additional Details
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColors.UpcomingeventCardBgColor(context),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 16,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Point of Contact Details',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppColors.titleTextColor(context),
                              ),
                            ),
                            _buildDetailRow('Host Name:', hostName),
                            _buildDetailRow('POC Name:', pocFullName),
                            _buildDetailRow('POC Location:', pocLocation),
                            _buildDetailRow('POC Number:', pocNumber),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Additional Details
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColors.UpcomingeventCardBgColor(context),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 16,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Additional Details',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppColors.titleTextColor(context),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildDetailRow('Food Provided:', foodProvided),
                            _buildDetailRow(
                                'Safety Equipment:', safetyEquipment),
                            _buildDetailRow('Water Provided:', waterProvided),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Action buttons for non-NGO users
              if (!isNgo && currentAdminRole != 'uni')
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        context,
                        text: 'Not Interested',
                        color: Colors.red,
                        onPressed: () {
                          print(
                              "Event ID for rejection: ${widget.eventId}"); // Print the event ID
                          _showDenyConfirmationDialog(
                              context); // Show the denial dialog
                        },
                      ),
                      _buildActionButton(
                        context,
                        text: 'Interested',
                        color: Colors.green,
                        onPressed: () {
                          print(
                              "Event ID for acceptance: ${widget.eventId}"); // Print the event ID

                          // Now passing the eventId to the _showAcceptForm method to capture the submission details
                          _showAcceptForm(context,
                              widget.eventId); // Show the accept form dialog
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the detail rows with icons
  Widget _buildDetailRow(String label, dynamic value) {
    IconData icon;
    if (label == 'Food Provided:')
      icon = Icons.restaurant;
    else if (label == 'Safety Equipment:')
      icon = Icons.security;
    else if (label == 'Water Provided:')
      icon = Icons.water_drop;
    else if (label == 'Required Volunteers:')
      icon = Icons.group;
    else
      icon = Icons.info;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.iconColor(context)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label ${value is bool ? (value ? "Yes" : "No") : value}',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: AppColors.defualtTextColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build action buttons
  Widget _buildActionButton(BuildContext context,
      {required String text,
      required Color color,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: Size(120, 50),
      ),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 16)),
    );
  }
}
