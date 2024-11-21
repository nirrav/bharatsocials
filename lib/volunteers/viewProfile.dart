import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/volunteers/volDashboard.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ViewProfilePage(),
    );
  }
}

class ViewProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get theme-dependent colors using the AppColors utility
    Color backgroundColor = AppColors.getBackgroundColor(context);
    Color textColor = AppColors.getTextColor(context);
    Color buttonColor = AppColors.getButtonColor(context);
    Color buttonTextColor = AppColors.getButtonTextColor(context);

    // Get screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VolunteerDashboard(),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            // Name
            const TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: UnderlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            // College Name
            const TextField(
              decoration: InputDecoration(
                labelText: 'College Name',
                border: UnderlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            // Email
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: UnderlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            // Roll No
            const TextField(
              decoration: InputDecoration(
                labelText: 'Roll No',
                border: UnderlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            // Department
            const TextField(
              decoration: InputDecoration(
                labelText: 'Department',
                border: UnderlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 20),
            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                // Add your edit profile logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
