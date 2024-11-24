import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/volunteers/NotiPage.dart';
import 'package:bharatsocials/admins/UniAdmin/Boardcast.dart';
import 'package:bharatsocials/admins/UniAdmin/collegeAct.dart';
import 'package:bharatsocials/admins/UniAdmin/EventDetails.dart';
import 'package:bharatsocials/admins/UniAdmin/Unisidebar.dart'; // Import the SlideBar widget

class UniAdminDashboard extends StatefulWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Attach the scaffold key to Scaffold
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.iconColor(context)),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer
          },
        ),
        title: Text(
          'Dashboard',
          style: TextStyle(color: AppColors.titleTextColor(context)),
        ),
        actions: [
          IconButton(
            icon:
                Icon(Icons.notifications, color: AppColors.iconColor(context)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
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
              SizedBox(height: 8),
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
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => _buildIndicator(index, _currentEventIndex),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Colleges',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
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
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => _buildIndicator(index, _currentCollegeIndex),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[700],
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
              MaterialPageRoute(builder: (context) => UniAdminDashboard()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BroadcastChannelScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: '',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
      drawer: SlideBar(), // Use SlideBar as the drawer
    );
  }

  Widget _buildEventCard(int index) {
    return Card(
      color: AppColors.eventCardBgColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event Name $index'),
            SizedBox(height: 8),
            Text('Event Date'),
            SizedBox(height: 8),
            Text('Event Location'),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventDetailsScreen()),
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

  Widget _buildCollegeCard(int index) {
    return Card(
      color: AppColors.eventCardBgColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 8),
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
                  Text('College Name $index', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  ElevatedButton(
                    //Button
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CollegeActivityScreen()),
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

  Widget _buildIndicator(int index, int currentIndex) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: currentIndex == index ? 12 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.black : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
