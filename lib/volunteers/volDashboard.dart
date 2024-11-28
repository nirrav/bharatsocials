import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/BC/eventDetails.dart';
import 'package:bharatsocials/volunteers/sidebar.dart';
import 'package:bharatsocials/volunteers/NotiPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bharatsocials/common_widgets/event_card.dart' as commonWidgets;

class VolunteerDashboard extends StatefulWidget {
  const VolunteerDashboard({super.key});

  @override
  _VolunteerDashboardState createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  int _selectedIndex = 0; // Tracking the selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // Navigate to the SavedPage when the saved icon is tapped
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Placeholder(), // Redirect to SavedPage
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.titleColor(context),
        centerTitle: true,
        title: Text(
          'Vol Dashboard',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: AppColors.titleTextColor(context),
          ),
        ),
        actions: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.bell,
              color: AppColors.titleTextColor(context),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const NotificationPage()), // Notification page
              );
            },
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: FaIcon(
              FontAwesomeIcons.bars,
              color: AppColors.iconColor(context),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the sidebar
            },
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // Divider height
          child: Divider(
            color:
                AppColors.dividerColor(context), // Divider color based on theme
            thickness: 1,
            height: 1,
          ),
        ),
      ),

      drawer: const VolunteerSidebar(), // Sidebar remains
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Events',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: AppColors.defualtTextColor(context),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const Placeholder(), // Event details page
                        ),
                      );
                    },
                    child: Text(
                      'View All...',
                      style: TextStyle(
                        color: AppColors.subTextColor(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildAllEventsHorizontalList(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Attended Events',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: AppColors.defualtTextColor(context),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("View All... Attended Events tapped");
                    },
                    child: Text(
                      'View All...',
                      style: TextStyle(
                        color: AppColors.subTextColor(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildAllEventsHorizontalList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            color: AppColors.dividerColor(context), // Color based on theme
            thickness: 1,
            height: 1,
          ),
          BottomAppBar(
            color: AppColors.titleColor(context),
            shape: const CircularNotchedRectangle(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(
                    icon: FontAwesomeIcons.house,
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: FontAwesomeIcons.bookmark,
                    index: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
  }) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            icon,
            color: isSelected
                ? AppColors.iconColor(context)
                : AppColors.iconColor(context).withOpacity(0.6),
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildAllEventsHorizontalList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.AlleventCardBgColor(context),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.eventCardTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Event Date: 12 December 2024, 5:00 PM',
                    style:
                        TextStyle(color: AppColors.eventCardTextColor(context)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Event Location: New York',
                    style:
                        TextStyle(color: AppColors.eventCardTextColor(context)),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainButtonColor(context),
                      foregroundColor: AppColors.mainButtonTextColor(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const NgoEventDetailsPage(eventId: 'eventId'),
                        ),
                      );
                    },
                    child: const Text('View More'),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}



// Widget _buildAllEventsHorizontalList() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(3, (index) {
//           return Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: Container(
//               width: 250,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: AppColors.AlleventCardBgColor(context),
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     offset: const Offset(2, 2),
//                     blurRadius: 4,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Event Name',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.eventCardTextColor(context),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Event Date: 12 December 2024, 5:00 PM',
//                     style:
//                         TextStyle(color: AppColors.eventCardTextColor(context)),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Event Location: New York',
//                     style:
//                         TextStyle(color: AppColors.eventCardTextColor(context)),
//                   ),
//                   const SizedBox(height: 8),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.mainButtonColor(context),
//                       foregroundColor: AppColors.mainButtonTextColor(context),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               const NgoEventDetailsPage(eventId: 'eventId'),
//                         ),
//                       );
//                     },
//                     child: const Text('View More'),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }