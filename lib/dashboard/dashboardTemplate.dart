import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/UserData.dart';
import 'package:bharatsocials/commonWidgets/sidebar.dart';
import 'package:bharatsocials/commonWidgets/savedPage.dart';
import 'package:bharatsocials/commonWidgets/bottomNavbar.dart';
import 'package:bharatsocials/commonWidgets/currentCampaigns.dart';
import 'package:bharatsocials/commonWidgets/pendingVolunteers.dart';
import 'package:bharatsocials/commonWidgets/horizontalWidgets.dart';

class DashboardTemplate extends StatefulWidget {
  const DashboardTemplate({super.key});

  @override
  _DashboardTemplateState createState() => _DashboardTemplateState();
}

class _DashboardTemplateState extends State<DashboardTemplate> {
  int _selectedIndex = 0;
  bool _isVolunteer = false; // Default to false (if user is not a volunteer)

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  // Check the user's role
  Future<void> _checkUserRole() async {
    await UserData().fetchUserData(); // Fetch user data
    setState(() {
      _isVolunteer = UserData().role == 'volunteer';
    });
  }

  // Dynamically changing content index
  Widget _currentPage() {
    if (_isVolunteer) {
      switch (_selectedIndex) {
        case 0:
          return const UpcomingCampaigns();
        case 3: // Saved Events index for volunteers
          return const SavedEventsPage();
        default:
          return const UpcomingCampaigns(); // Default content
      }
    } else {
      switch (_selectedIndex) {
        case 0:
          return const UpcomingCampaigns();
        case 1:
          return const CurrentCampaigns();
        case 2:
          return const PendingVolunteers();
        default:
          return const UpcomingCampaigns(); // Default content
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.titleColor(context),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(color: AppColors.titleTextColor(context)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_active,
              color: AppColors.iconColor(context),
            ),
            onPressed: () {
              // Placeholder for navigation to NotificationPage
            },
          ),
        ],
      ),
      drawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _currentPage(),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        isVolunteer: _isVolunteer,
      ),
      floatingActionButton: !_isVolunteer
          ? FloatingActionButton(
              backgroundColor: AppColors.mainButtonColor(context),
              onPressed: () {
                // Placeholder for navigation to Event Form Page
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
