import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For toast message

class VolunteerEventDetailsPage extends StatefulWidget {
  final String eventId; // Event ID passed from the previous page

  const VolunteerEventDetailsPage({super.key, required this.eventId});

  @override
  _VolunteerEventDetailsPageState createState() =>
      _VolunteerEventDetailsPageState();
}

class _VolunteerEventDetailsPageState extends State<VolunteerEventDetailsPage> {
  DocumentSnapshot? eventDetails;
  List<Map<String, dynamic>> interestedColleges = [];
  bool isLoading = true;
  bool receiveAlerts = false; // To track if the user wants to receive alerts

  @override
  void initState() {
    super.initState();
    _loadEventDetails();
  }

  // Fetch event details from Firestore
  Future<void> _loadEventDetails() async {
    try {
      DocumentSnapshot eventDoc = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .get();

      if (eventDoc.exists) {
        setState(() {
          eventDetails = eventDoc;
          isLoading = false;
        });
        // Fetch the interested colleges from the subcollection
        await _loadInterestedColleges();
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'Event not found');
      }
    } catch (e) {
      print("Error loading event details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch interested colleges from the subcollection
  Future<void> _loadInterestedColleges() async {
    try {
      QuerySnapshot submissionsSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .collection('submissions')
          .get();

      interestedColleges = submissionsSnapshot.docs.map((doc) {
        return {
          'collegeName': doc['collegeName'] ?? 'No College Name',
          'volunteers': doc['volunteers'] ?? 0,
        };
      }).toList();

      setState(() {}); // Update UI after fetching the colleges
    } catch (e) {
      print("Error loading interested colleges: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.titleColor(context),
        appBar: AppBar(
          backgroundColor: AppColors.titleColor(context),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: AppColors.defualtTextColor(context)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Event Details',
            style: GoogleFonts.poppins(
                fontSize: 20,
                color: AppColors.titleTextColor(context),
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 8,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Divider(
                color: AppColors.dividerColor(context),
                thickness: 1,
                height: 1),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Check if the document exists
    if (eventDetails == null || !eventDetails!.exists) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.titleColor(context),
          title: Text('Event Details',
              style: TextStyle(color: AppColors.titleTextColor(context))),
        ),
        body: const Center(
            child: Text('Event not found', style: TextStyle(fontSize: 20))),
      );
    }

    // Extract event details for display
    String eventName = eventDetails!['eventName'] ?? 'No Event Name';
    String eventLocation =
        eventDetails!['eventLocation'] ?? 'No Event Location';
    String eventDate = 'Event Date not available';

    if (eventDetails!['eventDate'] != null) {
      Timestamp timestamp = eventDetails!['eventDate']; // Firestore timestamp
      DateTime eventDateTime = timestamp.toDate(); // Convert to DateTime
      eventDate = DateFormat('d MMMM yyyy, h:mm a')
          .format(eventDateTime); // Format the date
    }

    bool foodProvided = eventDetails!['foodProvided'] ?? false;
    bool safetyEquipment = eventDetails!['safetyEquipment'] ?? false;
    bool waterProvided = eventDetails!['waterProvided'] ?? false;

    String hostName = eventDetails!['hostName'] ?? 'No Host Name';
    String pocFullName = eventDetails!['pocFullName'] ?? 'No Contact Name';
    String pocLocation = eventDetails!['pocLocation'] ?? 'No Contact Location';
    String pocNumber = eventDetails!['pocPhone'] ?? 'No Contact Number';
    int requiredVolunteers = eventDetails!['requiredVolunteers'] ?? '0';

    return Scaffold(
      backgroundColor: AppColors.titleColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.titleColor(context),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: AppColors.defualtTextColor(context)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Event Details',
          style: GoogleFonts.poppins(
              fontSize: 20,
              color: AppColors.titleTextColor(context),
              fontWeight: FontWeight.bold),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        offset: const Offset(0, 6),
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
                          fontWeight: FontWeight.w700,
                          color: AppColors.eventCardTextColor(context),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.black),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Location: $eventLocation',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: AppColors.eventCardTextColor(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.black),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Date: $eventDate',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: AppColors.eventCardTextColor(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.group, color: Colors.black),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Required Volunteers: $requiredVolunteers',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: AppColors.eventCardTextColor(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Additional Details: Point of Contact
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.UpcomingeventCardBgColor(context),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Point of Contact',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.eventCardTextColor(context),
                        ),
                      ),
                      const SizedBox(height: 5),
                      _buildDetailRow('Name:', pocFullName),
                      _buildDetailRow('Location:', pocLocation),
                      _buildDetailRow('Phone:', pocNumber),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Additional Details: Event
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.UpcomingeventCardBgColor(context),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
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
                          fontWeight: FontWeight.w700,
                          color: AppColors.eventCardTextColor(context),
                        ),
                      ),
                      const SizedBox(height: 5),
                      _buildDetailRow('Food Provided:', foodProvided),
                      const SizedBox(height: 5),
                      _buildDetailRow('Safety Equipment:', safetyEquipment),
                      const SizedBox(height: 5),
                      _buildDetailRow('Water Provided:', waterProvided),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Buttons for Interested and Not Interested
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Show deny confirmation dialog when the "Not Interested" button is pressed
                        showDenyConfirmationDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.rejectButtonColor(context),
                        foregroundColor:
                            AppColors.rejectButtonTextColor(context),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 12),
                      ),
                      child: const Text('Not Interested',
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                        onPressed: () {
                          // Show accept form dialog when the "Interested" button is pressed
                          showAcceptForm(context,
                              widget.eventId); // Correctly passing eventId
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.acceptButtonColor(context),
                          foregroundColor:
                              AppColors.acceptButtonTextColor(context),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 65, vertical: 12),
                        ),
                        child: const Text('Interested',
                            style: TextStyle(
                              fontSize: 16,
                            )))
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to build the detail rows with icons
  Widget _buildDetailRow(String label, dynamic value) {
    IconData icon;
    if (label == 'Food Provided:') {
      icon = Icons.restaurant;
    } else if (label == 'Safety Equipment:') {
      icon = Icons.security;
    } else if (label == 'Water Provided:') {
      icon = Icons.water_drop;
    } else if (label == 'Required Volunteers:') {
      icon = Icons.group;
    } else {
      icon = Icons.info;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label ${value is bool ? (value ? "Yes" : "No") : value}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: AppColors.eventCardTextColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
} //@nirrav click karna button pe zara view more

void showDenyConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to deny this event?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}

void showAcceptForm(BuildContext context, String eventId) {
  // Show the dialog with the new fields
  _showDialog(context, eventId);
}

void _showDialog(BuildContext context, String eventId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AcceptFormDialog(eventId: eventId);
    },
  );
}

class AcceptFormDialog extends StatefulWidget {
  final String eventId;

  const AcceptFormDialog({super.key, required this.eventId});

  @override
  _AcceptFormDialogState createState() => _AcceptFormDialogState();
}

class _AcceptFormDialogState extends State<AcceptFormDialog> {
  bool receiveAlerts = false; // To track if the user wants to receive alerts

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [Colors.white, Colors.blue.shade50],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          color: AppColors.appBgColor(context),
          borderRadius: BorderRadius.circular(20),
          // border: Border.all(color: Colors.blueAccent, width: 2),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Do You Want To Receive Alerts?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.defualtTextColor(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: receiveAlerts,
                  onChanged: (bool? value) {
                    setState(() {
                      receiveAlerts = value ?? false;
                    });
                  },
                ),
                Text(
                  'Yes, I Want To Receive Alerts',
                  style: TextStyle(
                      fontSize: 14, color: AppColors.defualtTextColor(context)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appBgColor(context),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: AppColors.defualtTextColor(context),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.UpcomingeventCardBgColor(context),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Handle submission logic here
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        color: AppColors.mainButtonColor(context),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showSuccessMessage(BuildContext context) {
  // Placeholder for a success message, e.g., a snackbar or toast.
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Submission successful!')),
  );
}
