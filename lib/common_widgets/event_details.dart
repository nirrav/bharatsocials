import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/colors.dart'; // Import AppColors
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.getButtonColor(context),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // Standard back arrow
            color: AppColors.getButtonTextColor(context),
          ),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Text(
          'Event Details',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600, // Slightly bold for better visibility
            color: AppColors.getButtonTextColor(context),
          ),
        ),
        centerTitle: true, // Center the title in the AppBar
        elevation: 0, // No shadow on app bar for a cleaner look
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Allow scrolling in case of overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEventDetailsBox(context),
              SizedBox(height: 16),
              _buildPurposeBox(context, 'Purpose Of Event'),
              SizedBox(height: 30), // Extra space before buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    context,
                    text: 'Not Interested',
                    color: Colors.red,
                    onPressed: () {
                      // Handle Not Interested action
                      const Placeholder();
                    },
                  ),
                  _buildActionButton(
                    context,
                    text: 'Interested',
                    color: Colors.green,
                    onPressed: () {
                      // Handle Interested action
                      const Placeholder();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Event Details Box (Combining name, date, and location in one container)
  Widget _buildEventDetailsBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Lighter grey for a softer look
        borderRadius:
            BorderRadius.circular(12), // Rounded corners for a more modern feel
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(context, 'Event Name:', 'Volunteer Meet'),
          SizedBox(height: 8),
          _buildInfoRow(context, 'Date:', '14th December 2024'),
          SizedBox(height: 8),
          _buildInfoRow(context, 'Location:', 'Borivali'),
        ],
      ),
    );
  }

  // Helper method for creating info rows (name-value pairs)
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium weight for readability
            color: Colors.black, // Set text color to black
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400, // Regular weight for description
            color: Colors.black, // Set text color to black
          ),
        ),
      ],
    );
  }

  // Purpose Box (Additional description area with more padding)
  Widget _buildPurposeBox(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600, // Bold for title
              color: Colors.black, // Set text color to black
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This event aims to gather volunteers to discuss and plan upcoming community service activities. Your participation will make a difference!',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400, // Regular weight for description
              color: Colors.black, // Set text color to black
            ),
          ),
        ],
      ),
    );
  }

  // Action Buttons (Styled with rounded corners and modern look)
  Widget _buildActionButton(BuildContext context,
      {required String text,
      required Color color,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Button color
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners for button
        ),
        elevation: 4, // Slight elevation for the button
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600, // Bold text for the button
          color: Colors.white,
        ),
      ),
    );
  }
}
