import 'package:flutter/material.dart';
import 'package:bharatsocials/admins/UniAdmin/UniProfile.dart';
import 'package:bharatsocials/admins/UniAdmin/Unisettings.dart';
import 'package:bharatsocials/admins/UniAdmin/uniAdminData.dart';

class SlideBar extends StatefulWidget {
  const SlideBar({super.key});

  @override
  _SlideBarState createState() => _SlideBarState();
}

class _SlideBarState extends State<SlideBar> {
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _fetchAdminData();
  }

  // Fetch Admin data
  Future<void> _fetchAdminData() async {
    AdminData? adminData = await AdminData.fetchAdminData();
    if (adminData != null) {
      setState(() {
        userName = adminData.name;
        userEmail = adminData.email;
      });
    } else {
      setState(() {
        userName = 'Unknown';
        userEmail = 'user@example.com';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.person, color: Colors.white, size: 50),
                const SizedBox(height: 8),
                // Display the user's name and email
                Text(
                  'Hello, $userName',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  userEmail,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          // Drawer Items
          ListTile(
            leading: const Icon(Icons.home, color: Colors.black),
            title: const Text('View Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UniProfile()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.black),
            title: const Text('Permission'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.black),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Placeholder()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Unisettings()),
              );
            },
          ),
        ],
      ),
    );
  }
}
