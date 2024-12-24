import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _isLoading =
      true; // Loading state to ensure data is fetched before rendering

  @override
  void initState() {
    super.initState();
    _loadState(); // Load saved state when the app starts
    _checkUserRole(); // Ensure user role is checked after data is loaded
  }

  // Load the saved state from SharedPreferences
  Future<void> _loadState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = prefs.getInt('selectedIndex') ?? 0;
      _isVolunteer = prefs.getBool('isVolunteer') ?? false;
    });
  }

  // Save the current state to SharedPreferences
  Future<void> _saveState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedIndex', _selectedIndex);
    await prefs.setBool('isVolunteer', _isVolunteer);
  }

  // Check the user's role
  Future<void> _checkUserRole() async {
    await UserData().fetchUserData(); // Fetch user data
    setState(() {
      _isVolunteer = UserData().role == 'volunteer';
      _isLoading = false; // Data is loaded, now we can show the UI
    });
  }

  // Dynamically changing content index
  Widget _currentPage() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_isVolunteer) {
      switch (_selectedIndex) {
        case 0:
          return const UpcomingCampaigns();
        case 3:
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

  // Get the title based on the selected index and user role
  String _getTitle() {
    if (_isVolunteer) {
      switch (_selectedIndex) {
        case 0:
          return 'Dashboard';
        case 3:
          return 'Saved Events';
        default:
          return 'Dashboard';
      }
    } else {
      switch (_selectedIndex) {
        case 0:
          return 'Upcoming Campaigns';
        case 1:
          return 'Current Campaigns';
        case 2:
          return 'Pending Volunteers';
        default:
          return 'Dashboard';
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      if (_isVolunteer) {
        if (index > 3) {
          _selectedIndex = 3;
        } else {
          _selectedIndex = index;
        }
      } else {
        if (index > 2) {
          _selectedIndex = 2;
        } else {
          _selectedIndex = index;
        }
      }
      _saveState(); // Save the updated state when the index changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.appBgColor(context),
        appBar: AppBar(
          backgroundColor: AppColors.titleColor(context),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getTitle(),
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
              onPressed: () {},
            ),
          ],
        ),
        drawer: const Sidebar(),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
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
                onPressed: () {},
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
      ),
    );
  }
}
