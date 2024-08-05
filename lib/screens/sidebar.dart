// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:bharatsocials/screens/login-signup/login_popup.dart';
import 'settings.dart';
import 'profile.dart';

class Sidebar extends StatelessWidget {
  final Color backgroundColor;

  const Sidebar({super.key, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    'Bharat Socials',
                    style: TextStyle(color: Colors.black),
                  ),
                  accountEmail: Text(
                    'bharatsocials@example.com',
                    style: TextStyle(color: Colors.black),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 60.0),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFCDEBF7),
                  ),
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.person),
                      Text(
                        ' View Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
                Divider(color: Color.fromARGB(68, 0, 0, 0)),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.settings),
                      Text(
                        ' Settings',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                ),
                Divider(color: Color.fromARGB(68, 0, 0, 0)),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.badge),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: ' Badges',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: ' (Coming soon)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  enabled: false,
                ),
                Divider(color: Color.fromARGB(68, 0, 0, 0)),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.insert_chart),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: ' Statistics',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: ' (Coming soon)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  enabled: false,
                ),
                Divider(color: Color.fromARGB(68, 0, 0, 0)),
              ],
            ),
          ),
          ListTile(
            tileColor: Colors.green,
            title: Row(
              children: [
                Icon(Icons.login, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(
                    onLoginStatusChanged: (bool isLoggedIn) {
                      if (isLoggedIn) {
                        Navigator.pop(context); // Close the LoginPage
                        // Optionally redirect to a specific screen
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => SomeOtherScreen(),
                        //   ),
                        // );
                      }
                    },
                  ),
                ),
              );
            },
          ),
          Divider(color: Color.fromARGB(68, 0, 0, 0)),
          ListTile(
            tileColor: Colors.red,
            title: Row(
              children: [
                Icon(Icons.logout, color: Colors.white),
                Text(
                  ' Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              // Add your logout logic here
            },
          ),
          ListTile(
            title: Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            enabled: false,
          ),
        ],
      ),
    );
  }
}
