import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bharatsocials/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bharatsocials/commonWidgets/widgets.dart';

class NgoRegistrationPage extends StatefulWidget {
  const NgoRegistrationPage({super.key});

  @override
  _NgoRegistrationPageState createState() => _NgoRegistrationPageState();
}

class TextFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isDarkMode;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const TextFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.isDarkMode,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        errorStyle: const TextStyle(color: Colors.red),
      ),
    );
  }
}

class _NgoRegistrationPageState extends State<NgoRegistrationPage> {
  final TextEditingController organizationNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    if (_formKey.currentState?.validate() ?? false) {
      print("NGO form submitted!");
      // Perform registration logic here
    } else {
      print("NGO form validation failed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        // Navigate back to the previous screen
        return true; // Prevent the default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Register as NGO',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(isActive: false, context: context),
                      _buildConnectingLine(context),
                      _buildDot(isActive: true, context: context),
                      _buildConnectingLine(context),
                      _buildDot(isActive: false, context: context),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                TextFieldWidget(
                  label: 'NGO Name',
                  controller: organizationNameController,
                  isDarkMode: isDarkMode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'NGO Full Name is required';
                    }
                    return null;
                  },
                ),
                TextFieldWidget(
                  label: 'NGO Email',
                  controller: emailController,
                  isDarkMode: isDarkMode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    // Check if the email contains '@' and '.com'
                    if (!value.contains('@') || !value.contains('.com')) {
                      return 'Email must contain "@" and ".com"';
                    }
                    return null;
                  },
                ),
                TextFieldWidget(
                  label: 'Contact Number',
                  controller: contactNumberController,
                  isDarkMode: isDarkMode,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Contact number is required';
                    }
                    if (value.length != 10) {
                      return 'Contact number must be 10 digits';
                    }
                    return null;
                  },
                ),
                TextFieldWidget(
                  label: 'City',
                  controller: cityController,
                  isDarkMode: isDarkMode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'City Name is required';
                    }
                    return null;
                  },
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
      ),
    );
  }
}

Widget _buildDot({required bool isActive, required BuildContext context}) {
  return Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      color: AppColors.getDotColor(context, isActive: isActive),
      shape: BoxShape.circle,
    ),
  );
}

Widget _buildConnectingLine(BuildContext context) {
  return Container(
    width: 80,
    height: 2,
    color: AppColors.getLineColor(context),
  );
}