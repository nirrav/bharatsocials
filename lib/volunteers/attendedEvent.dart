import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendedEventPage extends StatelessWidget {
  const AttendedEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get theme-dependent colors using AppColors utility

    // Get screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.iconColor(context)),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: Text('Attended Event',
            style: TextStyle(color: AppColors.titleTextColor(context))),
        backgroundColor: AppColors.titleColor(context), // AppBar background
      ),
      body: SingleChildScrollView(
        // Add scrolling for small screens
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[
                      300], // You can adjust this if you want the theme color
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: DateTime.now(),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Month Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add month button logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.mainButtonColor(context), // Button color
                  ),
                  child: Text('Month',
                      style: TextStyle(
                          color: AppColors.mainButtonTextColor(
                              context))), // Button text color
                ),
              ),
              const SizedBox(height: 16),
              // Event Details Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[
                      300], // You can adjust this if you want the theme color
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Event Name',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.defualtTextColor(context))),
                    const SizedBox(height: 8),
                    Text('Event Date: 20/11/2024',
                        style: TextStyle(
                            fontSize: 16,
                            color: AppColors.defualtTextColor(context))),
                    const SizedBox(height: 8),
                    Text('Event Location: Online',
                        style: TextStyle(
                            fontSize: 16,
                            color: AppColors.defualtTextColor(context))),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // Add view more button logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainButtonColor(
                              context), // Button color
                        ),
                        child: Text('View More',
                            style: TextStyle(
                                color: AppColors.mainButtonTextColor(
                                    context))), // Button text color
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
