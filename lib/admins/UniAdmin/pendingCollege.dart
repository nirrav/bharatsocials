import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/admins/UniAdmin/pendingOperations.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package

class PendingColleges extends StatefulWidget {
  const PendingColleges({super.key});

  @override
  _PendingCollegesState createState() => _PendingCollegesState();
}

class _PendingCollegesState extends State<PendingColleges> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PendingCollege(),
    const AcceptedCollege(),
    const RejectedCollege(),
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
        title: const Text("College Management"),
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

class PendingCollege extends StatelessWidget {
  const PendingCollege({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('admins')
          .where('adminRole', isEqualTo: 'college')
          .where('isVerified',
              isEqualTo: false) // Filter for unverified colleges
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final admins = snapshot.data?.docs ?? [];

        // Filter out rejected colleges (those with 'isRejected' field)
        final pendingAdmins = admins.where((admin) {
          // Safely check if 'isRejected' field exists and handle it properly
          final adminData =
              admin.data() as Map<String, dynamic>?; // Cast to Map
          final isRejected = adminData != null &&
                  adminData.containsKey('isRejected')
              ? adminData['isRejected']
              : false; // Default to false if 'isRejected' is null or not present

          // Filter out the rejected ones, considering 'isRejected' as null or false
          return isRejected ==
              false; // Only include those that are not rejected
        }).toList();

        if (pendingAdmins.isEmpty) {
          return const Center(
              child: Text('No Pending College Requests to show.'));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            itemCount: pendingAdmins.length,
            itemBuilder: (context, index) {
              final admin = pendingAdmins[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(admin['name'] ?? 'College Name'),
                  subtitle: const Text("Pending Approval"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () async {
                          // Handle approval logic
                          await onCollegeVerify(admin.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () async {
                          // Handle rejection logic
                          await onCollegeReject(context, admin.id);
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

class AcceptedCollege extends StatelessWidget {
  const AcceptedCollege({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('admins')
          .where('adminRole', isEqualTo: 'college')
          .where('isVerified',
              isEqualTo: true) // Filter accepted colleges (isVerified == true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final admins = snapshot.data?.docs ?? [];

        if (admins.isEmpty) {
          return const Center(
              child: Text('No Accepted College Requests to show.'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: admins.length,
            itemBuilder: (context, index) {
              final admin = admins[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(admin['name'] ?? 'NGO Name'),
                  subtitle: const Text("Accepted"),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () async {
                      await onCollegeReject(context, admin.id);
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

class RejectedCollege extends StatelessWidget {
  const RejectedCollege({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('admins')
          .where('adminRole', isEqualTo: 'college')
          .where('isRejected',
              isEqualTo: true) // Filter rejected colleges (isRejected == true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final admins = snapshot.data?.docs ?? [];

        if (admins.isEmpty) {
          return const Center(
              child: Text('No Rejected College Requests to show.'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: admins.length,
            itemBuilder: (context, index) {
              final admin = admins[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(admin['name'] ?? 'College Name'),
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
