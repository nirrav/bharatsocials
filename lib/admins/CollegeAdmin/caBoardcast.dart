import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';

class BroadcastChannelPage extends StatelessWidget {
  // Function to show the confirmation dialog
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

  // Function to show the accept form
  void _showAcceptForm(BuildContext context) {
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
              mainAxisSize: MainAxisSize
                  .min, // To make the dialog take only required space
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
                TextField(
                  decoration: InputDecoration(
                    labelText: 'How many volunteers do you want to send?',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(value: false, onChanged: (bool? value) {}),
                    Text('Send to volunteer'),
                  ],
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Event Type',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Conference', 'Workshop', 'Seminar', 'Webinar']
                      .map((eventType) => DropdownMenuItem(
                            value: eventType,
                            child: Text(eventType),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {},
                ),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Event Hours',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
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
                      onPressed: () {
                        // Handle the form submission
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Broadcast Channel"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Back navigation
          },
        ),
        elevation: 8, // Adding elevation to AppBar for shadow
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 0.0, horizontal: 16.0), // Body padding added
        child: ListView(
          children: [
            EventCard(
              eventName: "Blood Donation",
              eventDate: "15/10/2024",
              eventLocation: "Community Hall",
              onDeny: () {
                _showDenyConfirmationDialog(
                    context); // Pass context to EventCard
              },
              onAccept: () {
                _showAcceptForm(
                    context); // Show the accept form when "Accept" is clicked
              },
            ),
            EventCard(
              eventName: "Tree Plantation",
              eventDate: "20/10/2024",
              eventLocation: "City Park",
              onDeny: () {
                _showDenyConfirmationDialog(
                    context); // Pass context to EventCard
              },
              onAccept: () {
                _showAcceptForm(
                    context); // Show the accept form when "Accept" is clicked
              },
            ),
            EventCard(
              eventName: "Charity Run",
              eventDate: "25/10/2024",
              eventLocation: "Downtown Square",
              onDeny: () {
                _showDenyConfirmationDialog(
                    context); // Pass context to EventCard
              },
              onAccept: () {
                _showAcceptForm(
                    context); // Show the accept form when "Accept" is clicked
              },
            ),
            EventCard(
              eventName: "Food Drive",
              eventDate: "30/10/2024",
              eventLocation: "City Plaza",
              onDeny: () {
                _showDenyConfirmationDialog(
                    context); // Pass context to EventCard
              },
              onAccept: () {
                _showAcceptForm(
                    context); // Show the accept form when "Accept" is clicked
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: '',
          ),
        ],
        selectedItemColor: AppColors.titleTextColor(context),
        unselectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality for FAB here
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String eventName;
  final String eventDate;
  final String eventLocation;
  final VoidCallback onDeny;
  final VoidCallback onAccept;

  const EventCard({
    required this.eventName,
    required this.eventDate,
    required this.eventLocation,
    required this.onDeny,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8, // Add drop shadow to the card
      borderRadius: BorderRadius.circular(10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: AppColors.eventCardBgColor(context),
        margin: EdgeInsets.symmetric(vertical: 12.0),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eventName.isNotEmpty)
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.eventCardTextColor(context)),
                    children: [
                      const TextSpan(
                        text: "Event Name: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: eventName),
                    ],
                  ),
                ),
              SizedBox(height: 8),
              if (eventDate.isNotEmpty)
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.eventCardTextColor(context)),
                    children: [
                      const TextSpan(
                        text: "Event Date: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: eventDate),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              if (eventLocation.isNotEmpty)
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 16, color: AppColors.titleTextColor(context)),
                    children: [
                      const TextSpan(
                        text: "Event Location: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: eventLocation),
                    ],
                  ),
                ),
              SizedBox(height: 12),
              Text(
                "View More",
                style: TextStyle(
                  color: AppColors.subTextColor(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Deny Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onDeny, // Call the passed in deny method
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appBgColor(context),
                        side: BorderSide(
                            color: AppColors.acceptButtonColor(
                                context)), // Red border
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Deny',
                        style: TextStyle(
                            color: AppColors.acceptButtonTextColor(context)),
                      ),
                    ),
                  ),
                  SizedBox(width: 16), // Add spacing between the buttons
                  // Accept Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept, // Call the passed in accept method
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appBgColor(context),
                        side: BorderSide(
                            color: AppColors.acceptButtonColor(context)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Accept',
                        style: TextStyle(
                            color: AppColors.acceptButtonTextColor(context)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
