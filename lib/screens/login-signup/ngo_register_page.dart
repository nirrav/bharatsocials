import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler package

class NgoRegisterPage extends StatefulWidget {
  const NgoRegisterPage({super.key});

  @override
  _NgoRegisterPageState createState() => _NgoRegisterPageState();
}

class _NgoRegisterPageState extends State<NgoRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String? _uploadedFilePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(143, 155, 192, 227),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage(
                    'assets/texture.jpg'), // Texture image for the background
                fit: BoxFit.cover, // Ensures the texture covers the container
              ),
              color: Colors
                  .transparent, // Keep the container background transparent
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      'Register as NGO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      labelText: 'Name',
                      prefixIcon:
                          const Icon(Icons.business, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      labelText: 'Cause',
                      prefixIcon:
                          const Icon(Icons.favorite, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    _buildDropdownField(
                      labelText: 'Domain',
                      prefixIcon: const Icon(Icons.domain, color: Colors.black),
                      items: const [
                        'Women Empowerment',
                        'Sarva Shiksha Abhiyan',
                        'Environmental Conservation',
                        'Blood Donation',
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      labelText: 'Location',
                      prefixIcon:
                          const Icon(Icons.location_on, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      labelText: 'Social',
                      prefixIcon: const Icon(Icons.public, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    _buildProofOfIdentityField(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle NGO registration
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 152, 220, 247), // Background color
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16.0), // Rounded corners
                          side: BorderSide(
                            color: const Color.fromARGB(255, 128, 131, 136)
                                .withOpacity(0.5), // Border color
                            width: 0.9, // Border width
                          ),
                        ),
                        elevation: 4, // Shadow depth
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 18, // Font size
                          fontWeight: FontWeight.bold, // Font weight
                          color: Colors.black, // Text color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required Icon prefixIcon,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
        prefixIcon: prefixIcon,
      ),
      style: const TextStyle(color: Colors.black),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField({
    required String labelText,
    required Icon prefixIcon,
    required List<String> items,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
        prefixIcon: prefixIcon,
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
      style: const TextStyle(color: Colors.black),
      onChanged: (newValue) {
        setState(() {
          // Handle changes here if necessary
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildProofOfIdentityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Proof of Identity (Copy of light bill)',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            // Request storage permission if necessary
            var status = await Permission.storage.status;

            if (!status.isGranted) {
              status = await Permission.storage.request();

              if (!status.isGranted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Storage permission is required to pick files.')),
                );
                return;
              }
            }

            try {
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null && result.files.isNotEmpty) {
                setState(() {
                  _uploadedFilePath = result.files.single.path;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No file selected')),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('An error occurred: $e')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color.fromARGB(255, 152, 220, 247), // Background color
            padding: const EdgeInsets.symmetric(vertical: 15),
            textStyle: const TextStyle(fontSize: 16, color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // Rounded corners
              side: BorderSide(
                color: const Color.fromARGB(255, 128, 131, 136)
                    .withOpacity(0.5), // Border color
                width: 0.9, // Border width
              ),
            ),
            elevation: 4, // Shadow depth
          ),
          child: const Text(
            'Upload',
            style: TextStyle(
              fontSize: 18, // Font size
              fontWeight: FontWeight.bold, // Font weight
              color: Colors.black, // Text color
            ),
          ),
        ),
        if (_uploadedFilePath != null)
          Text(
            'Selected File: ${_uploadedFilePath!.split('/').last}',
            style: const TextStyle(color: Colors.black),
          ),
      ],
    );
  }
}
