import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/ngos/ngoData.dart';
import 'package:bharatsocials/ngos/ngoProfile.dart';
import 'package:bharatsocials/commonWidgets/widgets.dart';

class NgoSlideBar extends StatefulWidget {
  const NgoSlideBar({super.key});

  @override
  _NgoSlideBarState createState() => _NgoSlideBarState();
}

class _NgoSlideBarState extends State<NgoSlideBar> {
  Future<NgoData?> _fetchNgoData() async {
    return await NgoData.fetchNgoData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NgoData?>(
      future: _fetchNgoData(),
      builder: (BuildContext context, AsyncSnapshot<NgoData?> snapshot) {
        // If data is still loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If data is fetched successfully
        if (snapshot.hasData && snapshot.data != null) {
          NgoData ngoData = snapshot.data!; // Unwrap the data

          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Drawer Header
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.UpcomingeventCardBgColor(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.person,
                          color: AppColors.eventCardTextColor(context),
                          size: 50),
                      const SizedBox(height: 8),
                      Text(
                        'Hello, ${ngoData.name}!',
                        style: TextStyle(
                            color: AppColors.eventCardTextColor(context),
                            fontSize: 18),
                      ),
                      Text(
                        ngoData.email,
                        style: TextStyle(
                            color: AppColors.eventCardTextColor(context),
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // Drawer Items
                ListTile(
                  leading:
                      Icon(Icons.person, color: AppColors.iconColor(context)),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NGOProfileScreen()),
                    );
                  },
                ),
                ListTile(
                  leading:
                      Icon(Icons.settings, color: AppColors.iconColor(context)),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Placeholder()),
                    );
                  },
                ),
                ListTile(
                  leading:
                      Icon(Icons.info, color: AppColors.iconColor(context)),
                  title: const Text('About'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Placeholder()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Log Out'),
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
          );
        }

        // If there's an error or no data available
        return const Center(
            child: Text('Failed to load NGO data. Please try again.'));
      },
    );
  }
}
