import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/volunteers/volDashboard.dart';
import 'package:bharatsocials/volunteers/volunteerData.dart'; // Import the VolunteerData class

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  bool isEditing = false; // Track if the page is in edit mode
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _rollNoController;
  late TextEditingController _departmentController;
  late TextEditingController _collegeController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VolunteerData?>(
      future: VolunteerData
          .fetchVolunteerData(), // Fetch volunteer data from Firestore
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator()); // Loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}')); // Error message
        } else if (!snapshot.hasData) {
          return const Center(
              child: Text('No Data Found')); // Handle no data case
        }

        VolunteerData volunteerData = snapshot.data!; // Get the volunteer data

        // Initialize text controllers with fetched data if in edit mode
        if (isEditing) {
          _nameController = TextEditingController(text: volunteerData.name);
          _emailController = TextEditingController(text: volunteerData.email);
          _rollNoController = TextEditingController(text: volunteerData.rollno);
          _departmentController =
              TextEditingController(text: volunteerData.department);
          _collegeController =
              TextEditingController(text: volunteerData.collegeName);
          _phoneController = TextEditingController(text: volunteerData.phone);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'View Profile',
              style: TextStyle(
                color: AppColors.titleTextColor(context),
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.titleColor(context),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.iconColor(context)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VolunteerDashboard(),
                  ),
                );
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture (Placeholder)
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.titleColor(context),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Name (uneditable)
                  TextField(
                    controller: TextEditingController(text: volunteerData.name),
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: UnderlineInputBorder(),
                    ),
                    readOnly: true, // Make name uneditable
                  ),
                  const SizedBox(height: 10),
                  // Email (uneditable)
                  TextField(
                    controller:
                        TextEditingController(text: volunteerData.email),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: UnderlineInputBorder(),
                    ),
                    readOnly: true, // Email is uneditable
                  ),
                  const SizedBox(height: 10),
                  // Roll No (uneditable)
                  TextField(
                    controller:
                        TextEditingController(text: volunteerData.rollno),
                    decoration: const InputDecoration(
                      labelText: 'Roll No',
                      border: UnderlineInputBorder(),
                    ),
                    readOnly: true, // Roll No is uneditable
                  ),
                  const SizedBox(height: 10),
                  // College Name (uneditable)
                  TextField(
                    controller:
                        TextEditingController(text: volunteerData.collegeName),
                    decoration: const InputDecoration(
                      labelText: 'College',
                      border: UnderlineInputBorder(),
                    ),
                    readOnly: true, // College name is uneditable
                  ),
                  const SizedBox(height: 10),
                  // Department (editable)
                  TextField(
                    controller:
                        TextEditingController(text: volunteerData.department),
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      border: UnderlineInputBorder(),
                    ),
                    readOnly:
                        !isEditing, // Make department editable only when isEditing is true
                  ),
                  const SizedBox(height: 10),
                  // Phone (editable)
                  TextField(
                    controller:
                        TextEditingController(text: volunteerData.phone),
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: UnderlineInputBorder(),
                    ),
                    readOnly:
                        !isEditing, // Make phone editable only when isEditing is true
                  ),
                  const SizedBox(height: 20),
                  // Edit/Submit Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = !isEditing; // Toggle edit state
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Submit' : 'Edit Profile',
                      style: TextStyle(
                          color: AppColors.mainButtonTextColor(context)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
