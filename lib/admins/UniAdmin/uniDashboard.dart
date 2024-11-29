import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/volunteers/NotiPage.dart';
import 'package:bharatsocials/admins/UniAdmin/Boardcast.dart';
import 'package:bharatsocials/admins/UniAdmin/pendingNgo.dart';
import 'package:bharatsocials/admins/UniAdmin/EventDetails.dart';
import 'package:bharatsocials/admins/UniAdmin/pendingCollege.dart';
import 'package:bharatsocials/admins/CollegeAdmin/collegeAct.dart';
import 'package:bharatsocials/admins/UniAdmin/Unisidebar.dart'; // Import the SlideBar widget

class UniAdminDashboard extends StatefulWidget {
  const UniAdminDashboard({super.key});

  @override
  _UniAdminDashboardState createState() => _UniAdminDashboardState();
}

class _UniAdminDashboardState extends State<UniAdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _eventPageController = PageController();
  final PageController _collegePageController = PageController();

  int _currentEventIndex = 0;
  int _currentCollegeIndex = 0;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.iconColor(context)),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer
          },
        ),
        title: Center(
          child: Text(
            'Uni Dashboard',
            style: TextStyle(color: AppColors.titleTextColor(context)),
          ),
        ),
        actions: [
          IconButton(
            icon:
                Icon(Icons.notifications, color: AppColors.iconColor(context)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Upcoming Event',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 180,
                child: PageView.builder(
                  controller: _eventPageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentEventIndex = index;
                    });
                  },
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildEventCard(index);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => _buildIndicator(index, _currentEventIndex),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Colleges',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 180,
                child: PageView.builder(
                  controller: _collegePageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentCollegeIndex = index;
                    });
                  },
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildCollegeCard(index);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => _buildIndicator(index, _currentCollegeIndex),
                ),
              ),
              const SizedBox(height: 16),

              // Add Horizontal Buttons Below College Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHorizontalButton(
                    'Pending NGOs',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PendingNgoScreen()),
                      );
                    },
                  ),
                  _buildHorizontalButton(
                    'Pending Colleges',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PendingColleges()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.grey[700],
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UniAdminDashboard()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BroadcastChannelScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home', //All the Best Guys Good night
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Campaign',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
      drawer: const SlideBar(),
    );
  }

  // Method to build event card
  Widget _buildEventCard(int index) {
    return Card(
      color: AppColors.UpcomingeventCardBgColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Name $index',
              style: TextStyle(
                  color: AppColors.eventCardTextColor(context),
                  fontWeight: FontWeight.w500), // Set text color to black
            ),
            const SizedBox(height: 8),
            Text(
              'Event Date',
              style: TextStyle(
                  color: AppColors.eventCardTextColor(context),
                  fontWeight: FontWeight.w500), // Set text color to black
            ),
            const SizedBox(height: 8),
            Text(
              'Event Location',
              style: TextStyle(
                  color: AppColors.eventCardTextColor(context),
                  fontWeight: FontWeight.w500), // Set text color to black
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EventDetailsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainButtonColor(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'View More →',
                  style:
                      TextStyle(color: AppColors.mainButtonTextColor(context)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build college card
  Widget _buildCollegeCard(int index) {
    return Card(
      color: AppColors.UpcomingeventCardBgColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          Positioned(
            top: 19,
            left: 15,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: const Color.fromARGB(255, 66, 66, 66),
              child: Text(
                'Logo',
                style: TextStyle(
                    color: AppColors.eventCardTextColor(context), fontSize: 12),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('College Name $index',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CollegeActivityScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainButtonColor(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'View Activities →',
                      style: TextStyle(
                          color: AppColors.mainButtonTextColor(context)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build indicator dots
  Widget _buildIndicator(int index, int currentIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: currentIndex == index ? 12 : 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentIndex == index
            ? AppColors.mainButtonColor(context)
            : Colors.grey,
      ),
    );
  }

  Widget _buildHorizontalButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainButtonColor(context),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Set border radius to 20
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.mainButtonTextColor(
              context), // Text color based on theme
          fontWeight: FontWeight.w600, // Bold text for emphasis
          inherit: true, // Ensure consistent inheritance
        ),
      ),
    );
  }
}
