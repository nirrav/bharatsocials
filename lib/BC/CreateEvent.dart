import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Add this import

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
  Widget build(BuildContext context) {
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
                  decoration: const InputDecoration(
                    labelText: 'Host Name',
                    labelStyle: TextStyle(
                      color: Colors.black, // Set the label text color
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black, // Set the border color
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey, // Set the border color on focus
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black, // Set the text color
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
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Display success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Event submitted successfully!')),
                      );

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
