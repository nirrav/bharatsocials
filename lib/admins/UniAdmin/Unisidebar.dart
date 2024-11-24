import 'package:flutter/material.dart';
import 'package:bharatsocials/admins/UniAdmin/UniProfile.dart';
import 'package:bharatsocials/admins/UniAdmin/Unisettings.dart';
import 'package:bharatsocials/admins/UniAdmin/UniDashboard.dart';

class SlideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.person, color: Colors.white, size: 50),
                SizedBox(height: 8),
                Text(
                  'Hello, User!',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  'user@example.com',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          // Drawer Items
          ListTile(
            leading: Icon(Icons.home, color: Colors.black),
            title: Text('View Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UniProfile()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.black),
            title: Text('Permission'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.black),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UniAdmins()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Unisettings()),
              );
            },
          ),
        ],
      ),
    );
  }
}
