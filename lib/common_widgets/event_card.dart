import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/common_widgets/event_details.dart';

class EventCard extends StatelessWidget {
  final String eventName;
  final String eventDate;
  final String eventLocation;

  const EventCard({
    super.key,
    required this.eventName,
    required this.eventDate,
    required this.eventLocation,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = AppColors.mainButtonColor(context);

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppColors.eventCardBgColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $eventName',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.eventCardTextColor(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: $eventDate',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.eventCardTextColor(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: $eventLocation',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.eventCardTextColor(context),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Placeholder(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: Text(
                  'View More',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.mainButtonTextColor(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
