import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();

  String? _bloodGroup;
  String? _gender;

  bool _isEditing = false;

  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              ProfileTextField(
                label: "Name",
                controller: _nameController,
                placeholder: "Name",
                isEditing: _isEditing,
              ),
              ProfileTextField(
                label: "Username",
                controller: _usernameController,
                placeholder: "Username",
                isEditing: _isEditing,
              ),
              ProfileTextField(
                label: "Email",
                controller: _emailController,
                placeholder: "example@example.com",
                isEditing: _isEditing,
              ),
              ProfileTextField(
                label: "Contact no",
                controller: _contactController,
                placeholder: "+91 0000000000",
                isEditing: _isEditing,
              ),
              ProfileDropdownField(
                label: "Blood Group",
                value: _bloodGroup,
                options: _bloodGroups,
                isEditing: _isEditing,
                onChanged: (newValue) {
                  setState(() {
                    _bloodGroup = newValue;
                  });
                },
              ),
              ProfileDropdownField(
                label: "Gender",
                value: _gender,
                options: _genders,
                isEditing: _isEditing,
                onChanged: (newValue) {
                  setState(() {
                    _gender = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    const Color.fromRGBO(152, 220, 247, 0.762), // Background color
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16.0), // Rounded corners
                    ),
                  ),
                  shadowColor: WidgetStateProperty.all(
                    const Color.fromARGB(255, 8, 7, 7)
                        .withOpacity(0.2), // Shadow color
                  ),
                  elevation:
                      WidgetStateProperty.all(4), // Elevation for shadow
                  side: WidgetStateProperty.all(
                    BorderSide(
                      color: const Color.fromARGB(255, 128, 131, 136)
                          .withOpacity(0.5), // Border color
                      width: 0.9, // Border width
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                child: Text(_isEditing ? "Save Profile" : "Edit Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String placeholder;
  final bool isEditing;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.placeholder,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            readOnly: !isEditing,
            decoration: InputDecoration(
              hintText: placeholder,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final bool isEditing;
  final void Function(String?) onChanged;

  const ProfileDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.isEditing,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: isEditing ? value : null,
            onChanged: isEditing ? onChanged : null,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
