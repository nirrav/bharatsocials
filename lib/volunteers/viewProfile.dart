import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/login/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bharatsocials/volunteers/volDashboard.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  bool isEditing = false; // Track if the page is in edit mode
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _rollNoController;
  late TextEditingController _departmentController;
  late TextEditingController _collegeController;

  String uid = ""; // This will hold the Firestore document ID

  @override
  void initState() {
    super.initState();
    var currentUser = GlobalUser.currentUser;

    // Concatenate first_name, middle_name, and last_name to form the full name
    String fullName = '';
    if (currentUser != null) {
      fullName =
          '${currentUser.firstName ?? ''} ${currentUser.middleName ?? ''} ${currentUser.lastName ?? ''}';
    }

    // Initialize controllers with the current user data
    _nameController = TextEditingController(text: fullName.trim());
    _emailController = TextEditingController(text: currentUser?.email ?? 'N/A');
    _rollNoController =
        TextEditingController(text: currentUser?.rollNo ?? 'N/A');
    _departmentController =
        TextEditingController(text: currentUser?.department ?? 'N/A');
    _collegeController =
        TextEditingController(text: currentUser?.collegeName ?? 'N/A');

    // Fetch the document ID (uid) for the current user from Firestore
    _getUserId();
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _rollNoController.dispose();
    _departmentController.dispose();
    _collegeController.dispose();
    super.dispose();
  }

  // Fetch the user document ID (uid) from Firestore using email
  Future<void> _getUserId() async {
    try {
      var currentUser = GlobalUser.currentUser;
      String email = currentUser?.email ?? '';

      // Fetch the user document using email
      QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
          .collection('volunteers')
          .where('email', isEqualTo: email)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document per email, get the first document's id
        uid = userQuerySnapshot.docs.first.id;
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // Method to update user data in Firestore
  Future<void> _updateUserData() async {
    try {
      if (uid.isEmpty) return; // If uid is not available, exit

      // Collect the updated data from controllers
      String updatedName = _nameController.text;
      String updatedEmail = _emailController.text;
      String updatedRollNo = _rollNoController.text;
      String updatedDepartment = _departmentController.text;
      String updatedCollege = _collegeController.text;

      // Update the user document in Firestore
      await FirebaseFirestore.instance
          .collection('volunteers')
          .doc(uid)
          .update({
        'first_name':
            updatedName.split(' ')[0], // Assume first part is first_name
        'middle_name':
            updatedName.split(' ').length > 1 ? updatedName.split(' ')[1] : '',
        'last_name':
            updatedName.split(' ').length > 2 ? updatedName.split(' ')[2] : '',
        'email': updatedEmail,
        'roll_no': updatedRollNo,
        'department': updatedDepartment,
        'college_name': updatedCollege,
      });

      // Show confirmation after update
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      print("Error updating user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Profile',
          style: TextStyle(
            color: AppColors.titleTextColor(
                context), // Use dynamic color from AppColors
            fontFamily: GoogleFonts.poppins()
                .fontFamily, // Apply the font family properly
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
              // Profile Picture
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.titleColor(context),
                backgroundImage:
                    (GlobalUser.currentUser?.image?.isNotEmpty ?? false)
                        ? NetworkImage(GlobalUser.currentUser!.image!)
                        : null,
                child: (GlobalUser.currentUser?.image?.isEmpty ?? true)
                    ? const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.black54,
                      )
                    : null,
              ),
              const SizedBox(height: 20),
              // Name (uneditable)
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: UnderlineInputBorder(),
                ),
                readOnly: true, // Make name uneditable
              ),
              const SizedBox(height: 10),
              // Email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: UnderlineInputBorder(),
                ),
                readOnly: !isEditing,
              ),
              const SizedBox(height: 10),
              // Roll No
              TextField(
                controller: _rollNoController,
                decoration: const InputDecoration(
                  labelText: 'Roll No',
                  border: UnderlineInputBorder(),
                ),
                readOnly: !isEditing,
              ),
              const SizedBox(height: 10),
              // Department
              TextField(
                controller: _collegeController,
                decoration: const InputDecoration(
                  labelText: 'College',
                  border: UnderlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              // Department
              TextField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  border: UnderlineInputBorder(),
                ),
                readOnly: !isEditing,
              ),
              const SizedBox(height: 20),
              // Edit/Submit Button
              ElevatedButton(
                onPressed: () {
                  if (isEditing) {
                    _updateUserData();
                  }
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
                  style:
                      TextStyle(color: AppColors.mainButtonTextColor(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
