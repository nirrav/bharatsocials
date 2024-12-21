import 'package:flutter/material.dart';
import 'package:bharatsocials/UserData.dart';
import 'package:bharatsocials/commonWidgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import Font Awesome

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserData().fetchUserData(), // Fetch user data asynchronously
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading user data'));
        }

        // Once the user data is fetched, we can get the data locally
        var user = UserData();
        String name = user.name ?? "Guest"; // Display 'Guest' if name is null
        String email =
            user.email ?? "Not available"; // Display fallback if email is null

        return Drawer(
          child: Material(
            color: Colors.white, // Set the background color for the drawer
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                // DrawerHeader with a solid background
                Container(
                  color: Colors.deepPurple, // Set a solid background color
                  child: DrawerHeader(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors
                              .white, // Set background color for the avatar
                          child: user.imageUrl != null
                              ? ClipOval(
                                  child: Image.network(
                                    user.imageUrl!,
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  ),
                                )
                              : FaIcon(
                                  FontAwesomeIcons
                                      .user, // Font Awesome icon as fallback
                                  size: 40,
                                  color: Colors.deepPurple, // Icon color
                                ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // List items below the DrawerHeader
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Dashboard'),
                  onTap: () {
                    // Navigate to dashboard (if required)
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    // Placeholder for settings page
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () async {
                    // Show a message that the user has logged out
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('You have logged out successfully')),
                    );
                    Logout.logout(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
