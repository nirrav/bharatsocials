import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Retained for frontend
// Retained for frontend

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
    // eventCard Widget inside UpcomingEventsNgo
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
          boxShadow: const [
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
              const SizedBox(height: 8),
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
              const SizedBox(height: 8),
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
              const Spacer(), // Pushes the button to the bottom
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: onViewMore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Placeholder color
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'View More',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white, // Placeholder text color
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
        backgroundColor: Colors.blue, // Placeholder color
        title: Text(
          'Event Submission & Upcoming Events',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white, // Placeholder text color
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white, // Placeholder icon color
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Divider height
          child: Divider(
            color: Colors.grey, // Placeholder divider color
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
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Host Name (NGO or Admin)
                  TextFormField(
                    enabled: false,
                    initialValue: "Host Name", // Placeholder for host name
                    decoration: const InputDecoration(
                      labelText: 'Host Name',
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Event Name
                  TextFormField(
                    controller: eventNameController,
                    decoration: const InputDecoration(
                      labelText: 'Event Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter event name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Event Location
                  TextFormField(
                    controller: eventLocationController,
                    decoration: const InputDecoration(
                      labelText: 'Event Location',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter event location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
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
                        decoration: const InputDecoration(
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
                        decoration: const InputDecoration(
                          labelText: 'Event Time',
                        ),
                      ),
                    ),
                  ),
                  // Submit Button
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Event submitted successfully!')),
                        );
                      }
                    },
                    child: const Text('Submit Event'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Display Upcoming Events
            Text(
              'Upcoming Events',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Placeholder for Upcoming Events section
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: 5, // Placeholder for number of upcoming events
                itemBuilder: (context, index) {
                  return eventCard(
                    eventName: 'Event Name $index',
                    eventDate: '2024-12-01',
                    eventLocation: 'Event Location $index',
                    onViewMore: () {
                      // Placeholder for View More action
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
