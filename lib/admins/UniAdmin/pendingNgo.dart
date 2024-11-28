import 'package:bharatsocials/admins/UniAdmin/pendingOperations.dart'; // Import the reject method
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:bharatsocials/colors.dart';

class PendingNgoScreen extends StatefulWidget {
  const PendingNgoScreen({super.key});

  @override
  _PendingNgoScreenState createState() => _PendingNgoScreenState();
}

class _PendingNgoScreenState extends State<PendingNgoScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PendingNgo(),
    const AcceptedNgo(),
    const RejectedNgo(),
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
        title: Text("NGO Management"),
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

class PendingNgo extends StatelessWidget {
  const PendingNgo({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ngos')
          .where('isVerified', isEqualTo: false)
          .where('isRejected',
              isEqualTo: false) // Add this line to filter out rejected NGOs
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final ngos = snapshot.data?.docs ?? [];

        if (ngos.isEmpty) {
          return const Center(child: Text('No Pending NGOs to show.'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: ngos.length,
            itemBuilder: (context, index) {
              final ngo = ngos[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(ngo['name'] ?? 'NGO Name'),
                  subtitle: const Text("Pending Approval"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () async {
                          await onNgoVerify(ngo.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () async {
                          await onNgoReject(context, ngo.id);
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

class AcceptedNgo extends StatelessWidget {
  const AcceptedNgo({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ngos')
          .where('isVerified', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final ngos = snapshot.data?.docs ?? [];

        if (ngos.isEmpty) {
          return const Center(child: Text('No Accepted NGOs to show.'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: ngos.length,
            itemBuilder: (context, index) {
              final ngo = ngos[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(ngo['name'] ?? 'NGO Name'),
                  subtitle: const Text("Accepted"),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () async {
                      await onNgoReject(context, ngo.id);
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

class RejectedNgo extends StatelessWidget {
  const RejectedNgo({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ngos')
          .where('isRejected', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final ngos = snapshot.data?.docs ?? [];

        if (ngos.isEmpty) {
          return const Center(child: Text('No Rejected NGOs to show.'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: ngos.length,
            itemBuilder: (context, index) {
              final ngo = ngos[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(ngo['name'] ?? 'NGO Name'),
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
