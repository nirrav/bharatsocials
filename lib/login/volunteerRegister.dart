import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class TextFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isDarkMode;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const TextFieldWidget({
    Key? key,
    required this.label,
    required this.controller,
    required this.isDarkMode,
    this.inputFormatters,
    this.validator,
  }) : super(key: key);

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
      ),
    );
  }
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key

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
        collegeNames =
            snapshot.docs.map((doc) => doc['collegeName'] as String).toList();
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

  bool _validateForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_image == null) {
        // Show error if image is not selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ID Card upload is required')),
        );
        return false;
      }
      return true;
    }
    return false;
  }

  void _onSubmit() {
    if (_validateForm()) {
      print("Volunteer form submitted!");
      // Perform registration logic here
    } else {
      print("Volunteer form validation failed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        // Handle any necessary logic before the page closes
        return true; // Allow the page to close
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Register as Volunteer',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey, // Wrap the form with the Form widget
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pagination (Dot) Indicator
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
                SizedBox(height: 50),

                // Volunteer Registration Form
                TextFieldWidget(
                  label: 'Full Name',
                  controller: firstNameController,
                  isDarkMode: isDarkMode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Full Name is required';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 10),

                TextFieldWidget(
                  label: 'Email',
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
                SizedBox(height: 10),

                TextFieldWidget(
                  label: 'Phone Number',
                  controller: phoneNoController,
                  isDarkMode: isDarkMode,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // College Name Autocomplete
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
                      decoration:
                          const InputDecoration(labelText: 'College Name'),
                    );
                  },
                ),
                SizedBox(height: 10),

                TextFieldWidget(
                  label: 'Department',
                  controller: departmentController,
                  isDarkMode: isDarkMode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Department is required';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 10),

                TextFieldWidget(
                  label: 'Roll Number',
                  controller: rollNoController,
                  isDarkMode: isDarkMode,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6), // Limit to 6 digits
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Roll number is required';
                    }
                    if (value.length != 6) {
                      return 'Roll number must be 6 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Upload Button for ID Card
                UploadButtonWidget(
                  label: 'Upload ID Card',
                  isDarkMode: isDarkMode,
                  onImageSelected: (File? image) {
                    setState(() {
                      _image = image;
                    });
                  },
                ),
                SizedBox(height: 30),

                // Submit Button
                SubmitButtonWidget(
                  isTermsAgreed: true,
                  selectedRole: 'volunteer',
                  onSubmit: _onSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build the dot indicator
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

  // Method to build the line connecting dots
  Widget _buildConnectingLine(BuildContext context) {
    return Container(
      width: 80,
      height: 2,
      color: AppColors.getLineColor(context),
    );
  }
}
