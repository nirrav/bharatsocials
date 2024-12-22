import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bharatsocials/commonWidgets/widgets.dart';

class NgoRegistrationPage extends StatefulWidget {
  const NgoRegistrationPage({Key? key}) : super(key: key);

  @override
  _NgoRegistrationPageState createState() => _NgoRegistrationPageState();
}

class _NgoRegistrationPageState extends State<NgoRegistrationPage> {
  final TextEditingController organizationNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  File? _image;

  @override
  void dispose() {
    organizationNameController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    cityController.dispose();
    super.dispose();
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
      print("NGO form submitted!");
      // Perform registration logic here
    } else {
      print("NGO form validation failed.");
    }
  }

  bool _validateForm() {
    if (organizationNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        contactNumberController.text.isEmpty ||
        cityController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(); // Navigate back to the previous screen
        return false; // Prevent the default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('NGO Registration'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldWidget(
                label: 'NGO Name',
                controller: organizationNameController,
                isDarkMode: isDarkMode,
              ),
              TextFieldWidget(
                label: 'NGO Email',
                controller: emailController,
                isDarkMode: isDarkMode,
              ),
              TextFieldWidget(
                label: 'Contact Number',
                controller: contactNumberController,
                isDarkMode: isDarkMode,
              ),
              TextFieldWidget(
                label: 'City',
                controller: cityController,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 20),
              UploadButtonWidget(
                label: 'Upload Government ID',
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
                selectedRole: 'ngo',
                onSubmit: _onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}