import 'package:bharatsocials/common_widgets/event_details.dart';
import 'package:bharatsocials/login/userData.dart';
import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EventFormAndUpcomingPage extends StatefulWidget {
  const EventFormAndUpcomingPage({super.key});

  @override
  _EventFormAndUpcomingPageState createState() =>
      _EventFormAndUpcomingPageState();
}

class _EventFormAndUpcomingPageState extends State<EventFormAndUpcomingPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  TextEditingController pocFullNameController = TextEditingController();
  TextEditingController pocNumberController = TextEditingController();
  TextEditingController pocLocationController = TextEditingController();
  TextEditingController requiredVolunteersController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();
  TextEditingController eventTimeController = TextEditingController();

  bool waterProvided = false;
  bool foodProvided = false;
  bool safetyEquipment = false;

  DateTime? eventDateTime;

  @override
  Widget build(BuildContext context) {
    final currentUser = GlobalUser.currentUser;

    // Ensure only non-volunteer users can access this page
    if (currentUser?.role == 'volunteer') {
      return Scaffold(
        appBar: AppBar(
          title: Text('Access Denied'),
        ),
        body: Center(
          child: Text(
            'You do not have permission to access this page.',
            style: GoogleFonts.poppins(fontSize: 18),
          ),
        ),
      );
    }

    // EventCard Widget inside UpcomingEventsNgo
    Widget eventCard({
      required String eventName,
      required String eventDate,
      required String eventLocation,
      required VoidCallback onViewMore,
    }) {
      return Container(
        margin: const EdgeInsets.only(
            right: 16, bottom: 16), // margin between cards
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9), // Grey background for the event card
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Name
              Text(
                'Name: $eventName',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis, // Handling text overflow
                maxLines: 1, // Limiting to 1 line
              ),
              SizedBox(height: 8),
              // Event Date
              Text(
                'Date: $eventDate',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 8),
              // Event Location
              Text(
                'Location: $eventLocation',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Spacer(), // Pushes the button to the bottom
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: onViewMore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainButtonColor(context),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'View More',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.mainButtonTextColor(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.titleColor(context),
        title: Text(
          'Event Submission & Upcoming Events',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: AppColors.titleTextColor(context),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: AppColors.iconColor(
              context), // Set back arrow color to match button text color
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Form Section
            Text(
              'Host Details',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Host Name (NGO or Admin)
                  TextFormField(
                    enabled: false,
                    initialValue: currentUser?.role == 'ngo'
                        ? currentUser?.organizationName
                        : currentUser?.adminName,
                    decoration: InputDecoration(
                      labelText: 'Host Name',
                    ),
                  ),
                  SizedBox(height: 20),
                  // Event Name
                  TextFormField(
                    controller: eventNameController,
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter event name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Event Location
                  TextFormField(
                    controller: eventLocationController,
                    decoration: InputDecoration(
                      labelText: 'Event Location',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter event location';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Date Picker
                  GestureDetector(
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: eventDateTime ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          eventDateTime = selectedDate;
                          eventDateController.text =
                              DateFormat('yyyy-MM-dd').format(selectedDate);
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: eventDateController,
                        decoration: InputDecoration(
                          labelText: 'Event Date',
                        ),
                      ),
                    ),
                  ),
                  // Time Picker
                  GestureDetector(
                    onTap: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: eventDateTime == null
                            ? TimeOfDay.now()
                            : TimeOfDay.fromDateTime(eventDateTime!),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          eventDateTime = DateTime(
                            eventDateTime?.year ?? DateTime.now().year,
                            eventDateTime?.month ?? DateTime.now().month,
                            eventDateTime?.day ?? DateTime.now().day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                          eventTimeController.text =
                              DateFormat('HH:mm').format(eventDateTime!);
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: eventTimeController,
                        decoration: InputDecoration(
                          labelText: 'Event Time',
                        ),
                      ),
                    ),
                  ),
                  // Submit Button
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Collect data and save it to Firestore
                        String hostId = currentUser?.documentId ?? '';
                        String userRole = currentUser?.role ?? '';
                        String hostName = currentUser?.role == 'ngo'
                            ? currentUser?.organizationName ?? ''
                            : currentUser?.adminName ?? '';
                        String eventName = eventNameController.text;
                        String eventLocation = eventLocationController.text;
                        String pocFullName = pocFullNameController.text;
                        String pocNumber = pocNumberController.text;
                        String pocLocation = pocLocationController.text;
                        String requiredVolunteers =
                            requiredVolunteersController.text;

                        // Save to Firestore
                        FirebaseFirestore.instance.collection('events').add({
                          'hostId': hostId,
                          'userRole': userRole,
                          'hostName': hostName,
                          'eventName': eventName,
                          'eventLocation': eventLocation,
                          'eventDate': eventDateController.text,
                          'eventTime': eventTimeController.text,
                          'pocFullName': pocFullName,
                          'pocNumber': pocNumber,
                          'pocLocation': pocLocation,
                          'requiredVolunteers': requiredVolunteers,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Event submitted successfully!')),
                        );
                      }
                    },
                    child: Text('Submit Event'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Display Upcoming Events
            Text(
              'Upcoming Events',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Fetch upcoming events from Firestore for the logged-in user
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('events')
                    .where('hostId', isEqualTo: currentUser?.documentId)
                    .where('eventDate', isGreaterThanOrEqualTo: DateTime.now())
                    .orderBy('eventDate')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No upcoming events.'));
                  } else {
                    List<QueryDocumentSnapshot> eventDocs = snapshot.data!.docs;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      itemCount: eventDocs.length,
                      itemBuilder: (context, index) {
                        var event = eventDocs[index];
                        String eventName = event['eventName'];
                        String eventDate = event['eventDate'];
                        String eventLocation = event['eventLocation'];
                        return eventCard(
                          eventName: eventName,
                          eventDate: eventDate,
                          eventLocation: eventLocation,
                          onViewMore: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventDetailsPage(
                                  event: {
                                    'eventName': event['eventName'],
                                    'eventDate': event['eventDate'],
                                    'eventLocation': event['eventLocation'],
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
