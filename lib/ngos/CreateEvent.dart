import 'package:bharatsocials/colors.dart';
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

  TextEditingController hostNameController =
      TextEditingController(); // Added controller for Host Name

  bool waterProvided = false;
  bool foodProvided = false;
  bool safetyEquipment = false;

  DateTime? eventDateTime;

  @override
  void initState() {
    super.initState();
    // Set the host name based on the current user when the page is initialized
    final currentUser = GlobalUser.currentUser;
    if (currentUser != null) {
      hostNameController.text = currentUser.role == 'ngo'
          ? currentUser.organizationName ?? ''
          : currentUser.adminName ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = GlobalUser.currentUser;

    // Ensure only non-volunteer users can access this page
    if (currentUser?.role == 'volunteer') {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Access Denied'),
        ),
        body: Center(
          child: Text(
            'You do not have permission to access this page.',
            style: GoogleFonts.poppins(fontSize: 18),
          ),
        ),
      );
    }

    print('Current user organization name: ${currentUser?.organizationName}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Events'),
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
                  'Create Events',
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Use the hostNameController for the Host Name field
                TextFormField(
                  enabled: false, // Keep the field disabled
                  controller: hostNameController, // Use the controller here
                  decoration: InputDecoration(
                    labelText: 'Host Name',
                    labelStyle: TextStyle(
                      color: AppColors.defualtTextColor(
                          context), // Set the label text color
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.defualtTextColor(
                            context), // Set the border color
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.dividerColor(
                            context), // Set the border color on focus
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: AppColors.defualtTextColor(
                        context), // Set the text color
                  ),
                ),

                const SizedBox(height: 20),
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
                // Event Location TextField
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
                      decoration: const InputDecoration(
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
                      decoration: const InputDecoration(
                        labelText: 'Event Time',
                      ),
                    ),
                  ),
                ),

                // Remaining fields (POC Full Name, Number, etc.)
                const SizedBox(height: 20),
                TextFormField(
                  controller: pocFullNameController,
                  decoration: const InputDecoration(
                    labelText: 'POC Full Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter point of contact full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: pocNumberController,
                  decoration: const InputDecoration(
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: pocLocationController,
                  decoration: const InputDecoration(
                    labelText: 'POC Location',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter point of contact location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
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
                    const Text('Water Provided'),
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
                    const Text('Food Provided'),
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
                    const Text('Safety Equipment Provided'),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: requiredVolunteersController,
                  decoration: const InputDecoration(
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
                const SizedBox(height: 20),
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

                      // Add event to Firestore with 'posted' timestamp
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
                        'readBy':
                            [], // Adding an empty array for 'readBy' field
                        'posted':
                            Timestamp.now(), // Add the posted timestamp here
                      });

                      // Get the event's document ID
                      String eventId = eventDocRef.id;

                      // After event is created, update the eventsPosted field in the host's document
                      if (userRole == 'ngo' || userRole == 'admin') {
                        // Determine collection name based on user role
                        String collectionName =
                            userRole == 'ngo' ? 'ngos' : 'admins';

                        // Get the reference to the host document
                        DocumentReference hostDocRef = FirebaseFirestore
                            .instance
                            .collection(collectionName)
                            .doc(hostId);

                        // Fetch the host document to update the eventsPosted array
                        await hostDocRef.get().then((hostDoc) async {
                          if (hostDoc.exists) {
                            // Update the 'eventsPosted' array in the host document
                            await hostDocRef.update({
                              'eventsPosted': FieldValue.arrayUnion(
                                  [eventId]) // Add the event ID to the array
                            });
                          } else {
                            // If the host document doesn't exist (shouldn't happen), handle this case
                            print("Host document not found!");
                          }
                        });
                      }

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Event submitted successfully!')));

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
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
