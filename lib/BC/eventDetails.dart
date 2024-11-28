import 'package:flutter/material.dart';

class NgoEventDetailsPage extends StatefulWidget {
  final String eventId; // Event ID passed from the previous page

  const NgoEventDetailsPage({super.key, required this.eventId});

  @override
  _NgoEventDetailsPageState createState() => _NgoEventDetailsPageState();
}

class _NgoEventDetailsPageState extends State<NgoEventDetailsPage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Event details UI components (showing the event info)
                  // Example event name for display
                  const Text(
                    'Event Name: Example Event',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      _showAcceptForm(context, 'eventId123'); // Example event ID
                    },
                    child: const Text('Express Interest'),
                  ),
                ],
              ),
            ),
    );
  }

  void _showAcceptForm(BuildContext context, String eventId) {
    TextEditingController volunteersController = TextEditingController();
    TextEditingController eventHoursController = TextEditingController();
    String selectedEventType = 'Orientation'; // Default event type
    bool sendToVolunteer = false;
    bool hasAlreadySubmitted = false; // Track if the user has already submitted

    // Show the dialog after checking submission status
    _showDialog(context, eventId, volunteersController, eventHoursController,
        selectedEventType, sendToVolunteer, hasAlreadySubmitted);
  }

  void _showDialog(
    BuildContext context,
    String eventId,
    TextEditingController volunteersController,
    TextEditingController eventHoursController,
    String selectedEventType,
    bool sendToVolunteer,
    bool hasAlreadySubmitted,
  ) {
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
                const Text(
                  'Fill the Event Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (hasAlreadySubmitted)
                  // If the user has already submitted, show a message
                  const Text(
                    'You have already expressed interest in this event.',
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 12),
                TextField(
                  controller: volunteersController,
                  decoration: const InputDecoration(
                    labelText: 'How many volunteers do you want to send?',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  enabled: !hasAlreadySubmitted, // Disable if already submitted
                ),
                const SizedBox(height: 12),
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
                    const Text('Send to volunteer'),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
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
                const SizedBox(height: 12),
                TextField(
                  controller: eventHoursController,
                  decoration: const InputDecoration(
                    labelText: 'Event Hours',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  enabled: !hasAlreadySubmitted, // Disable if already submitted
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: hasAlreadySubmitted
                          ? null // Disable the submit button if already submitted
                          : () {
                              Navigator.pop(context); // Close the dialog
                            },
                      child: const Text('Submit'),
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
}
