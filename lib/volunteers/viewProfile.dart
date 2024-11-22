import 'package:bharatsocials/login/userData.dart';
import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:bharatsocials/volunteers/volDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewProfilePage extends StatefulWidget {
  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  bool isEditing = false; // Track if the page is in edit mode
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _rollNoController;
  late TextEditingController _departmentController;

  String uid = ""; // This will hold the Firestore document ID

  @override
  void initState() {
    super.initState();
    var currentUser = GlobalUser.currentUser;

    // Initialize controllers with the current user data
    _nameController =
        TextEditingController(text: currentUser?.firstName ?? 'N/A');
    _emailController = TextEditingController(text: currentUser?.email ?? 'N/A');
    _rollNoController =
        TextEditingController(text: currentUser?.rollNo ?? 'N/A');
    _departmentController =
        TextEditingController(text: currentUser?.department ?? 'N/A');

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
        uid = userQuerySnapshot
            .docs.first.id; // This is the Firestore-generated document ID
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

      // Update the user document in Firestore
      await FirebaseFirestore.instance.collection('volunteers').doc(uid).update({
        'first_name': updatedName,
        'email': updatedEmail,
        'roll_no': updatedRollNo,
        'department': updatedDepartment,
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
    // Get theme-dependent colors using the AppColors utility
    Color backgroundColor = AppColors.appBgColor(context);
    Color textColor = AppColors.defualtTextColor(context);
    Color buttonColor = AppColors.mainButtonColor(context);
    Color buttonTextColor = AppColors.mainButtonTextColor(context);

    // Get screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VolunteerDashboard(),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture (Placeholder for now, can be replaced with actual image)
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: GlobalUser.currentUser?.image.isNotEmpty ?? false
                  ? NetworkImage(GlobalUser.currentUser!.image)
                  : null, // Replace with actual image if available
              child: GlobalUser.currentUser?.image.isEmpty ?? true
                  ? const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.black54,
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            // Name (Display first name of the user)
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: UnderlineInputBorder(),
              ),
              readOnly: !isEditing,
            ),
            const SizedBox(height: 10),
            // College Name (Read-only)
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
              controller: _departmentController,
              decoration: const InputDecoration(
                labelText: 'Department',
                border: UnderlineInputBorder(),
              ),
              readOnly: !isEditing,
            ),
            const SizedBox(height: 20),
            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                if (isEditing) {
                  // When the button is pressed in edit mode, update data
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
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
