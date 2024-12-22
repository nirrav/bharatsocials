import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bharatsocials/commonWidgets/widgets.dart';

class VolunteerRegistrationPage extends StatefulWidget {
  const VolunteerRegistrationPage({Key? key}) : super(key: key);

  @override
  _VolunteerRegistrationPageState createState() =>
      _VolunteerRegistrationPageState();
}

class _VolunteerRegistrationPageState extends State<VolunteerRegistrationPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController collegeNameController = TextEditingController();
  List<String> collegeNames = [];
  File? _image;

  @override
  void dispose() {
    firstNameController.dispose();
    emailController.dispose();
    phoneNoController.dispose();
    rollNoController.dispose();
    departmentController.dispose();
    collegeNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchCollegeNames();
  }

  void _fetchCollegeNames() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('adminRole', isEqualTo: 'college')
          .where('collegeName', isNotEqualTo: null)
          .get();

      setState(() {
        collegeNames = snapshot.docs
            .map((doc) => doc['collegeName'] as String)
            .toList();
      });
    } catch (e) {
      print('Error fetching college names: $e');
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _onSubmit() {
    if (_validateForm()) {
      print("Volunteer form submitted!");
      // Perform registration logic here
    } else {
      print("Volunteer form validation failed.");
    }
  }

  bool _validateForm() {
    if (firstNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneNoController.text.isEmpty ||
        rollNoController.text.isEmpty ||
        departmentController.text.isEmpty ||
        collegeNameController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Registration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldWidget(
              label: 'Full Name',
              controller: firstNameController,
              isDarkMode: isDarkMode,
            ),
            TextFieldWidget(
              label: 'Email',
              controller: emailController,
              isDarkMode: isDarkMode,
            ),
            TextFieldWidget(
              label: 'Phone Number',
              controller: phoneNoController,
              isDarkMode: isDarkMode,
            ),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue value) {
                return collegeNames.where((college) => college
                    .toLowerCase()
                    .contains(value.text.toLowerCase()));
              },
              onSelected: (String selection) {
                collegeNameController.text = selection;
              },
              fieldViewBuilder: (context, controller, focusNode, onSubmit) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'College Name'),
                );
              },
            ),
            TextFieldWidget(
              label: 'Department',
              controller: departmentController,
              isDarkMode: isDarkMode,
            ),
            TextFieldWidget(
              label: 'Roll Number',
              controller: rollNoController,
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 20),
            UploadButtonWidget(
              label: 'Upload ID Card',
              isDarkMode: isDarkMode,
              onImageSelected: (File? image) {
                setState(() {
                  _image = image;
                });
              },
            ),
            const SizedBox(height: 20),
            SubmitButtonWidget(
              isTermsAgreed: true,
              selectedRole: 'volunteer',
              onSubmit: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
