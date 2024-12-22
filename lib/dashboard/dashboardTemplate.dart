import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/UserData.dart';
import 'package:bharatsocials/commonWidgets/sidebar.dart';
import 'package:bharatsocials/commonWidgets/bottomNavbar.dart';
import 'package:bharatsocials/commonWidgets/pendingVolunteers.dart';
import 'package:bharatsocials/commonWidgets/horizontalWidgets.dart';

class DashboardTemplate extends StatefulWidget {
  const DashboardTemplate({super.key});

  @override
  _DashboardTemplateState createState() => _DashboardTemplateState();
}

class _DashboardTemplateState extends State<DashboardTemplate> {
  int _selectedIndex = 1;
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
      _isVolunteer = UserData().role ==
          'volunteer'; // Set the _isVolunteer flag based on the fetched role
    });
  }

  // Dynamically changing content index
  Widget _currentPage() {
    switch (_selectedIndex) {
      case 0:
        return const CurrentCampaigns();
      case 1:
        return const UpcomingCampaigns();
      case 2:
        return const PendingVolunteers();
      default:
        return const UpcomingCampaigns(); // Default content
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
      backgroundColor:
          AppColors.appBgColor(context), // Light background color for the body
      appBar: AppBar(
        backgroundColor:
            AppColors.titleColor(context), // Deep purple gradient for AppBar
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
      drawer: const Sidebar(), // Use the AdminSidebar here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _currentPage(), // Dynamically rendering content
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        // Use custom bottom nav here
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        isVolunteer: _isVolunteer, // Pass the volunteer flag
      ),
      floatingActionButton: !_isVolunteer
          ? FloatingActionButton(
              backgroundColor: Colors.deepOrange, // Bright accent color
              onPressed: () {
                // Placeholder for navigation to Event Form Page
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null, // Show nothing if the user is a volunteer
    );
  }
}

// Sample of a dynamic content class for Current Campaigns
class CurrentCampaigns extends StatelessWidget {
  const CurrentCampaigns({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader(context, title: 'Current Campaigns'),
        const SizedBox(height: 8),
        _buildCampaignsList(),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              color: Colors.deepPurple[700],
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            // Placeholder for navigation logic
          },
          child: const Text(
            'See More..',
            style: TextStyle(color: Colors.deepPurple, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildCampaignsList() {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Campaign ${index + 1}'),
          subtitle: const Text('Details of the campaign'),
          onTap: () {
            // Placeholder for navigating to campaign details
          },
        );
      },
    );
  }
}
