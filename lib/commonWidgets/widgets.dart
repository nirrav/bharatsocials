import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/UserData.dart';
import 'package:bharatsocials/login/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Logout {
  // This method handles the logout process
  static Future<void> logout(BuildContext context) async {
    try {
      // Sign out the user using Firebase Auth
      await FirebaseAuth.instance.signOut();

      // Clear the user data
      await UserData().clearUserData();

      // Optionally, you can show a snackbar or a message indicating successful logout
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have been logged out successfully")),
      );

      // Redirect the user to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const LoginPage()), // Navigate to the Login page
      );
    } catch (e) {
      // Handle any errors that might occur during the logout process
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred while logging out")),
      );
    }
  }
}

class SubmitButtonWidget extends StatelessWidget {
  final bool isTermsAgreed;
  final VoidCallback onSubmit; // Define the onSubmit callback
  final String selectedRole; // Add selectedRole as a parameter

  const SubmitButtonWidget({
    super.key,
    required this.isTermsAgreed,
    required this.onSubmit,
    required this.selectedRole,
  });

  @override
  Widget build(BuildContext context) {
    // Get the appropriate button and text color based on the current theme
    Color buttonColor =
        AppColors.mainButtonColor(context); // Default button color
    Color buttonTextColor =
        AppColors.mainButtonTextColor(context); // Text color

    return SizedBox(
      height: 60, // Increase the height to ensure the text fits comfortably
      width: double.infinity, // Take full width for the button
      child: ElevatedButton(
        onPressed: isTermsAgreed
            ? onSubmit // Use the passed onSubmit function
            : null, // Only disable functionality, not color
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor, // Color remains consistent
          padding: const EdgeInsets.symmetric(vertical: 13), // Adjusted padding
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: Text(
          'Submit',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: buttonTextColor, // Text color remains consistent
          ),
        ),
      ),
    );
  }
}

class UploadButtonWidget extends StatefulWidget {
  final String label;
  final bool isDarkMode;
  final Function(File?) onImageSelected; // Callback function to send image back

  const UploadButtonWidget({
    super.key,
    required this.label,
    required this.isDarkMode,
    required this.onImageSelected, // Pass the callback here
  });

  @override
  _UploadButtonWidgetState createState() => _UploadButtonWidgetState();
}

class _UploadButtonWidgetState extends State<UploadButtonWidget> {
  XFile? _image; // Variable to hold the selected image

  // Function to pick an image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Pick image from the gallery
    final XFile? pickedImage = await picker.pickImage(
      source:
          ImageSource.gallery, // You can also use ImageSource.camera for camera
    );

    if (pickedImage != null) {
      setState(() {
        _image = pickedImage; // Update the state with the picked image
      });
      print("Image selected: ${pickedImage.name}"); // Print the image filename
      widget.onImageSelected(
          File(pickedImage.path)); // Pass the image back to parent widget
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed:
                _pickImage, // Trigger the image picker when the button is pressed
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.isDarkMode ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(13), // Add border radius of 13
              ),
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.isDarkMode ? Colors.black : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // If an image is selected, show a thumbnail of the image
          if (_image != null)
            Image.file(
              File(_image!.path),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
        ],
      ),
    );
  }
}

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
        color: AppColors.UpcomingeventCardBgColor(context),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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

class TextFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller; // The controller for the text field

  const TextFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    required bool isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    // Use AppColors methods to get the correct colors for the current theme
    Color textColor = AppColors.defualtTextColor(context);
    Color borderColor =
        AppColors.getLineColor(context); // Use getLineColor for the border

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: textColor), // Set text color using AppColors
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: textColor, // Set label color using AppColors
            height: 1.5,
          ),
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: borderColor), // Set border color using AppColors
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: borderColor), // Set border color using AppColors
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  final bool isActive;
  final bool isDarkMode;

  const DotIndicator(
      {super.key, required this.isActive, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        color:
            isActive ? (isDarkMode ? Colors.white : Colors.black) : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}

class DropdownFieldWidget extends StatelessWidget {
  final String label;
  final bool isDarkMode;

  const DropdownFieldWidget(
      {super.key, required this.label, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            height: 1.5,
          ),
          border: InputBorder.none,
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: isDarkMode ? Colors.white : Colors.black),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        items: <String>[
          'First Year',
          'Second Year',
          'Third Year',
          'Fourth Year'
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (_) {},
      ),
    );
  }
}

//Asmit
class AllEventsPage extends StatelessWidget {
  const AllEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonColor = AppColors.mainButtonColor(context);

    // EventCard Widget inside AllEventsPage
    Widget eventCard({
      required String eventName,
      required String eventDate,
      required String eventLocation,
      required VoidCallback onViewMore,
    }) {
      return Container(
        margin: const EdgeInsets.only(
            right: 16, bottom: 16), // margin between cards
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9), // Grey background for the event card
          borderRadius: BorderRadius.circular(8),
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
              // Event Name
              Text(
                'Name: $eventName',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis, // Handling text overflow
                maxLines: 1, // Limiting to 1 line
              ),
              const SizedBox(height: 8),
              // Event Date
              Text(
                'Date: $eventDate',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 8),
              // Event Location
              Text(
                'Location: $eventLocation',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const Spacer(), // Pushes the button to the bottom
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: onViewMore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.titleColor(context),
        title: Text(
          'All Events',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: AppColors.titleTextColor(context),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.iconColor(
              context), // Set back arrow color to match button text color
          onPressed: () {
            Navigator.pop(context);
          },
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          shrinkWrap: true, // Shrink the grid to fit its children
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Create a 2-column grid
            crossAxisSpacing: 16, // Horizontal space between items
            mainAxisSpacing: 16, // Vertical space between items
            childAspectRatio: 0.75, // Adjust height/width ratio for cards
          ),
          itemCount: 10, // Number of items
          itemBuilder: (context, index) {
            return eventCard(
              eventName: 'Event Name $index', // Example event name
              eventDate: '14th December 2024', // Example event date
              eventLocation: 'Location $index', // Example event location
              onViewMore: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const Placeholder(), // Pass the event data
                  ),
                );

                print("View More button pressed for Event $index");
              },
            );
          },
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Get the appropriate button and text color based on the current theme
    Color buttonColor = AppColors.mainButtonColor(context);
    Color buttonTextColor = AppColors.mainButtonTextColor(context);

    return SizedBox(
      height: 60, // Increase the height to ensure the text fits comfortably
      width: double.infinity, // Take full width for the button
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor, // Color remains consistent
          padding: const EdgeInsets.symmetric(vertical: 13), // Adjusted padding
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: Text(
          'Log In',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: buttonTextColor, // Text color remains consistent
          ),
        ),
      ),
    );
  }
}

class PasswordFieldWidget extends StatelessWidget {
  final String label;
  final bool isDarkMode;
  final TextEditingController controller;
  final bool showStrengthIndicator;
  final bool isPasswordVisible;
  final VoidCallback togglePasswordVisibility;
  final String passwordStrength; // Added to pass the strength value
  final ValueChanged<String> onPasswordChanged; // Callback for password change

  const PasswordFieldWidget({
    super.key,
    required this.label,
    required this.isDarkMode,
    required this.controller,
    required this.showStrengthIndicator,
    required this.isPasswordVisible,
    required this.togglePasswordVisibility,
    required this.passwordStrength, // Added to pass the strength value
    required this.onPasswordChanged, // Callback to handle password change
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  height: 1.5,
                ),
              ),
              if (showStrengthIndicator) ...[
                const SizedBox(width: 10),
                _buildPasswordStrengthDot(passwordStrength, 0),
                _buildPasswordStrengthDot(passwordStrength, 1),
                _buildPasswordStrengthDot(passwordStrength, 2),
              ]
            ],
          ),
          TextField(
            controller: controller,
            obscureText: !isPasswordVisible,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            onChanged: onPasswordChanged, // Notify parent widget of changes
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                height: 1.5,
              ),
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: isDarkMode ? Colors.white : Colors.black),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: isDarkMode ? Colors.white : Colors.black),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: togglePasswordVisibility,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthDot(String passwordStrength, int index) {
    Color color;
    if (passwordStrength == "strong") {
      color = index < 3 ? Colors.green : Colors.grey;
    } else if (passwordStrength == "medium") {
      color = index < 2 ? Colors.orange : Colors.grey;
    } else {
      color = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class UploadLogoButtonWidget extends StatefulWidget {
  final String label;
  final bool isDarkMode;

  const UploadLogoButtonWidget(
      {super.key, required this.label, required this.isDarkMode});

  @override
  _UploadLogoButtonWidgetState createState() => _UploadLogoButtonWidgetState();
}

class _UploadLogoButtonWidgetState extends State<UploadLogoButtonWidget> {
  XFile? _image; // Variable to hold the selected image

  // Function to pick an image (logo)
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Pick image from the gallery
    final XFile? pickedImage = await picker.pickImage(
      source:
          ImageSource.gallery, // You can also use ImageSource.camera for camera
    );

    if (pickedImage != null) {
      setState(() {
        _image = pickedImage; // Update the state with the picked image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed:
                _pickImage, // Trigger the image picker when the button is pressed
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.isDarkMode ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(13), // Add border radius of 13
              ),
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.isDarkMode ? Colors.black : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // If an image is selected, show a thumbnail of the image (logo)
          if (_image != null)
            Image.file(
              File(_image!.path),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
        ],
      ),
    );
  }
}

class EventDetailsPage extends StatelessWidget {
  final Map<String, dynamic>
      event; // This will hold the event details passed from the previous page

  const EventDetailsPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor(context),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // Standard back arrow
            color: AppColors.iconColor(context),
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
            color: AppColors.titleTextColor(context),
          ),
        ),
        centerTitle: true, // Center the title in the AppBar
        elevation: 0, // No shadow on app bar for a cleaner look
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Allow scrolling in case of overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEventDetailsBox(context),
              const SizedBox(height: 16),
              _buildPurposeBox(context, 'Purpose Of Event'),
              const SizedBox(height: 30), // Extra space before buttons
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
        color: AppColors.UpcomingeventCardBgColor(
            context), // Lighter grey for a softer look
        borderRadius:
            BorderRadius.circular(13), // Rounded corners for a more modern feel
        boxShadow: const [
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
          _buildInfoRow(context, 'Event Name:', event['eventName']),
          const SizedBox(height: 8),
          _buildInfoRow(context, 'Date:', event['eventDate']),
          const SizedBox(height: 8),
          _buildInfoRow(context, 'Location:', event['eventLocation']),
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
        color: AppColors.UpcomingeventCardBgColor(
            context), // Lighter grey for a softer look
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
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
          const SizedBox(height: 8),
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
          borderRadius: BorderRadius.circular(13), // Rounded corners for button
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
