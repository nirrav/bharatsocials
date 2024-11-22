import 'package:bharatsocials/login/userData.dart';
import 'package:intl/intl.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class EventFormPage extends StatefulWidget {
  const EventFormPage({super.key});

  @override
  _EventFormPageState createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Submission'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Host Details',
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  enabled: false,
                  initialValue: currentUser?.role == 'ngo'
                      ? currentUser?.organizationName
                      : currentUser?.adminName,
                  decoration: InputDecoration(
                    labelText: 'Host Name',
                  ),
                ),
                // SizedBox(height: 20),
                // TextFormField(
                //   enabled: false,
                //   initialValue: currentUser
                //       ?.documentId, // Use documentId instead of email
                //   decoration: InputDecoration(
                //     labelText: 'Host ID (Document ID)',
                //   ),
                // ),
                SizedBox(height: 20),
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
                // Event Location TextField
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
                // Date Picker using Flutter's built-in showDatePicker
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

                // Time Picker using Flutter's built-in showTimePicker
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

                // Remaining fields (POC Full Name, Number, etc.)
                SizedBox(height: 20),
                TextFormField(
                  controller: pocFullNameController,
                  decoration: InputDecoration(
                    labelText: 'POC Full Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter point of contact full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: pocNumberController,
                  decoration: InputDecoration(
                    labelText: 'POC Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter point of contact phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: pocLocationController,
                  decoration: InputDecoration(
                    labelText: 'POC Location',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter point of contact location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Removed Google Map location picker, no map UI now.

                // Checkbox options
                Row(
                  children: [
                    Checkbox(
                      value: waterProvided,
                      onChanged: (bool? value) {
                        setState(() {
                          waterProvided = value!;
                        });
                      },
                    ),
                    Text('Water Provided'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: foodProvided,
                      onChanged: (bool? value) {
                        setState(() {
                          foodProvided = value!;
                        });
                      },
                    ),
                    Text('Food Provided'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: safetyEquipment,
                      onChanged: (bool? value) {
                        setState(() {
                          safetyEquipment = value!;
                        });
                      },
                    ),
                    Text('Safety Equipment Provided'),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: requiredVolunteersController,
                  decoration: InputDecoration(
                    labelText: 'Required Volunteers',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of required volunteers';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Collect data and save it to Firestore
                      String hostId =
                          currentUser?.documentId ?? ''; // Use documentId here
                      String userRole = currentUser?.role ?? '';
                      String hostName = currentUser?.role == 'ngo'
                          ? currentUser?.organizationName ?? ''
                          : currentUser?.adminName ?? '';
                      String eventName = eventNameController.text;
                      String eventLocation = eventLocationController.text;
                      String pocFullName = pocFullNameController.text;
                      String pocNumber = pocNumberController.text;
                      String pocLocation = pocLocationController.text;
                      int requiredVolunteers =
                          int.tryParse(requiredVolunteersController.text) ?? 0;

                      // Add event to Firestore
                      DocumentReference eventDocRef = await FirebaseFirestore
                          .instance
                          .collection('events')
                          .add({
                        'hostId': hostId,
                        'role': userRole,
                        'hostName': hostName,
                        'eventName': eventName,
                        'eventLocation': eventLocation,
                        'eventDateTime': eventDateTime ?? Timestamp.now(),
                        'pocFullName': pocFullName,
                        'pocNumber': pocNumber,
                        'pocLocation': pocLocation,
                        'waterProvided': waterProvided,
                        'foodProvided': foodProvided,
                        'safetyEquipment': safetyEquipment,
                        'requiredVolunteers': requiredVolunteers,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Event submitted successfully!')));
                    }
                    // Reset the form fields
                    _formKey.currentState?.reset();
                    eventNameController.clear();
                    eventLocationController.clear();
                    pocFullNameController.clear();
                    pocNumberController.clear();
                    pocLocationController.clear();
                    requiredVolunteersController.clear();
                    eventDateController.clear();
                    eventTimeController.clear();
                    setState(() {
                      waterProvided = false;
                      foodProvided = false;
                      safetyEquipment = false;
                    });
                  },
                  child: Text('Submit Event'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
