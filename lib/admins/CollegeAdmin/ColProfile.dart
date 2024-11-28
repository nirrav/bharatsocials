import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'collegeAdminData.dart'; // Import your College Admin Data class

class CollegeProfileScreen extends StatefulWidget {
  const CollegeProfileScreen({super.key});

  @override
  _CollegeProfileScreenState createState() => _CollegeProfileScreenState();
}

class _CollegeProfileScreenState extends State<CollegeProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _collegeNameController;
  bool _isEditing = false; // Flag to toggle between view and edit mode

  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty text
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _collegeNameController = TextEditingController();

    // Fetch data from Firestore when the widget is initialized
    _loadAdminData();
  }

  // Method to load admin data from Firestore
  Future<void> _loadAdminData() async {
    AdminData? adminData = await AdminData.fetchAdminData();
    if (adminData != null) {
      // Set the fetched data to the controllers
      _nameController.text = adminData.name;
      _emailController.text = adminData.email;
      _phoneController.text = adminData.phone;
      _collegeNameController.text = adminData.collegeName;
      setState(() {});
    }
  }

  // Method to update admin data in Firestore
  Future<void> _updateAdminData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch the user document ID
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('admins')
            .where('email', isEqualTo: user.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          String docId = querySnapshot.docs.first.id;
          // Update the document with the new data
          await FirebaseFirestore.instance
              .collection('admins')
              .doc(docId)
              .update({
            'name': _nameController.text,
            'phone': _phoneController.text,
            'collegeName': _collegeNameController.text,
          });

          // After updating, disable editing mode
          setState(() {
            _isEditing = false;
          });
        }
      }
    } catch (e) {
      print('Error updating admin data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'College Profile',
          style: TextStyle(color: AppColors.titleTextColor(context)),
        ),
        backgroundColor: AppColors.titleColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.iconColor(context)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<AdminData?>(
          future: AdminData.fetchAdminData(), // Fetch admin data
          builder: (context, snapshot) {
            // Check if the data is loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Check if there is an error fetching the data
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // If there is no data, return a message
            if (!snapshot.hasData) {
              return const Center(child: Text('No data available.'));
            }

            // Get the admin data from the snapshot
            AdminData? adminData = snapshot.data;

            return Column(
              children: [
                // Profile Picture (using CircleAvatar)
                SizedBox(
                  height: screenHeight * 0.25,
                  child: Center(
                    child: CircleAvatar(
                      radius: screenHeight * 0.1,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Name TextField
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: UnderlineInputBorder(),
                  ),
                  readOnly: !_isEditing, // Allow editing only when _isEditing is true
                ),
                const SizedBox(height: 10),

                // College Name TextField
                TextField(
                  controller: _collegeNameController,
                  decoration: const InputDecoration(
                    labelText: 'College Name',
                    border: UnderlineInputBorder(),
                  ),
                  readOnly: !_isEditing, // Allow editing only when _isEditing is true
                ),
                const SizedBox(height: 10),

                // Email TextField (Read-only)
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: UnderlineInputBorder(),
                  ),
                  readOnly: true, // Email should not be editable
                ),
                const SizedBox(height: 10),

                // Phone Number TextField
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: UnderlineInputBorder(),
                  ),
                  readOnly: !_isEditing, // Allow editing only when _isEditing is true
                ),
                const SizedBox(height: 20),

                // Edit/Save Profile Button
                ElevatedButton(
                  onPressed: () {
                    if (_isEditing) {
                      // If in editing mode, submit the changes
                      _updateAdminData();
                    } else {
                      // Otherwise, switch to editing mode
                      setState(() {
                        _isEditing = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainButtonColor(context), // Replace with your button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                  child: Text(
                    _isEditing ? 'Save Changes' : 'Edit Profile',
                    style:  TextStyle(color: AppColors.mainButtonTextColor(context)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
