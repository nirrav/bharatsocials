import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bharatsocials/admins/UniAdmin/uniDashboard.dart';

class BroadcastChannelScreen extends StatefulWidget {
  @override
  _BroadcastChannelScreenState createState() => _BroadcastChannelScreenState();
}

class _BroadcastChannelScreenState extends State<BroadcastChannelScreen> {
  int _selectedIndex = 0; // Track bottom navigation index

  // Handle Bottom Navigation Item Taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on selected index
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UniAdminDashboard()),
        );

        break;
      case 1:
        // Campaign tab pressed

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BroadcastChannelScreen()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Broadcast Channel',
            style: TextStyle(color: AppColors.titleColor(context))),
        backgroundColor: AppColors.appBgColor(context),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.iconColor(context)),
          onPressed: () {
            Navigator.pop(context); // Navigate to the previous page
          },
        ),
      ),
      body: Container(
        color: AppColors.appBgColor(context),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              EventCard(
                width: screenWidth * 0.9,
                height: screenHeight * 0.35,
                textColor: AppColors.UpcomingeventCardBgColor(context),
              ),
              SizedBox(height: 16),
              EventCard(
                width: screenWidth * 0.9,
                height: screenHeight * 0.35,
                textColor: AppColors.UpcomingeventCardBgColor(context),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle action on FAB click
          print('FAB clicked');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyCustomForm()),
          );
        },
        backgroundColor: AppColors.FAB(context),
        child: Icon(Icons.add, color: AppColors.iconColor(context)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: AppColors.titleColor(context),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
              color: AppColors.iconColor(context),
              size: 32.0,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.bullhorn,
              color: AppColors.iconColor(context),
              size: 22.0,
            ),
            label: 'Broadcast Channel',
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final double width;
  final double height;
  final Color textColor;

  EventCard({
    required this.width,
    required this.height,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.UpcomingeventCardBgColor(context),
      elevation: 4,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event Name',
                style: TextStyle(
                    color: AppColors.eventCardTextColor(context),
                    fontSize: 18)),
            SizedBox(height: 8),
            Text('Event Date',
                style: TextStyle(
                    color: AppColors.eventCardTextColor(context),
                    fontSize: 16)),
            SizedBox(height: 8),
            Text('Event Location',
                style: TextStyle(
                    color: AppColors.eventCardTextColor(context),
                    fontSize: 16)),
            Spacer(),
            Text(
              'View More',
              style: TextStyle(
                  color: AppColors.mainButtonTextColor(context), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Form")),
      body: Center(child: Text("Form Content")),
    );
  }
}
