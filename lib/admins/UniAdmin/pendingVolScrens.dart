import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:bharatsocials/admins/UniAdmin/pendingOperations.dart'; // Import the reject method

class PendingVolunteerScreen extends StatefulWidget {
  const PendingVolunteerScreen({super.key});

  @override
  _PendingVolunteerScreenState createState() => _PendingVolunteerScreenState();
}

class _PendingVolunteerScreenState extends State<PendingVolunteerScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PendingVolunteer(),
    const AcceptedVolunteer(),
    const RejectedVolunteer(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Volunteer Management"),
        backgroundColor: AppColors.titleColor(context),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Accepted',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            label: 'Rejected',
          ),
        ],
      ),
    );
  }
}

class PendingVolunteer extends StatelessWidget {
  const PendingVolunteer({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('volunteers')
          .where('isVerified',
              isEqualTo: false) // Filter for unverified volunteers
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final volunteers = snapshot.data?.docs ?? [];

        // Filter out rejected volunteers (those with 'isRejected' field)
        final pendingVolunteers = volunteers.where((volunteer) {
          final volunteerData =
              volunteer.data() as Map<String, dynamic>?; // Cast to Map
          final isRejected = volunteerData != null &&
                  volunteerData.containsKey('isRejected')
              ? volunteerData['isRejected']
              : false; // Default to false if 'isRejected' is null or not present

          return isRejected ==
              false; // Only include those that are not rejected
        }).toList();

        if (pendingVolunteers.isEmpty) {
          return const Center(child: Text('No Pending Volunteers to show.'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: pendingVolunteers.length,
            itemBuilder: (context, index) {
              final volunteer = pendingVolunteers[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(volunteer['name'] ?? 'Volunteer Name'),
                  subtitle: const Text("Pending Approval"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () async {
                          await onVolunteerVerify(volunteer.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () async {
                          await onVolunteerReject(context, volunteer.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class AcceptedVolunteer extends StatelessWidget {
  const AcceptedVolunteer({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('volunteers')
          .where('isVerified', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final volunteers = snapshot.data?.docs ?? [];

        if (volunteers.isEmpty) {
          return const Center(child: Text('No Accepted Volunteers to show.'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: volunteers.length,
            itemBuilder: (context, index) {
              final volunteer = volunteers[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(volunteer['name'] ?? 'Volunteer Name'),
                  subtitle: const Text("Accepted"),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () async {
                      await onVolunteerReject(context, volunteer.id);
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class RejectedVolunteer extends StatelessWidget {
  const RejectedVolunteer({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('volunteers')
          .where('isRejected', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final volunteers = snapshot.data?.docs ?? [];

        if (volunteers.isEmpty) {
          return const Center(child: Text('No Rejected Volunteers to show.'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: volunteers.length,
            itemBuilder: (context, index) {
              final volunteer = volunteers[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(volunteer['name'] ?? 'Volunteer Name'),
                  subtitle: const Text("Rejected"),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
