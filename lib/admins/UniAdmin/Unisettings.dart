import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/volunteers/volDashboard.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Unisettings(),
    );
  }
}

class Unisettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get theme-dependent colors using the AppColors utility
    Color backgroundColor = AppColors.appBgColor(context);
    Color textColor = AppColors.defualtTextColor(context);
    Color buttonColor = AppColors.mainButtonColor(context);
    Color buttonTextColor = AppColors.mainButtonTextColor(context);

    // Get screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VolunteerDashboard()),
            );
          },
        ),
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Theme'),
            onTap: () {
              // Add navigation to Theme settings here
            },
          ),
          ListTile(
            title: Text('Report Bug'),
            onTap: () {
              // Add navigation to Report Bug page here
            },
          ),
          ListTile(
            title: Text('Contact Us'),
            onTap: () {
              // Add navigation to Contact Us page here
            },
          ),
          ListTile(
            title: Text('Log Out'),
            onTap: () {
              // Add log out logic here
            },
          ),
        ],
      ),
    );
  }
}
