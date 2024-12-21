import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/commonWidgets/widgets.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: AppColors.titleTextColor(context)),
        ),
        backgroundColor: AppColors.titleColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.iconColor(context)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Placeholder()),
            );
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Theme'),
            onTap: () {
              // Add navigation to Theme settings here
            },
          ),
          ListTile(
            title: const Text('Report Bug'),
            onTap: () {
              // Add navigation to Report Bug page here
            },
          ),
          ListTile(
            title: const Text('Contact Us'),
            onTap: () {
              // Add navigation to Contact Us page here
            },
          ),
          ListTile(
            title: const Text('Log Out'),
            onTap: () {
              // Call the logout method
              Logout.logout(
                  context); // This will handle the logout and redirect
            },
          ),
        ],
      ),
    );
  }
}
