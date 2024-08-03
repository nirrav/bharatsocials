import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
      backgroundColor: Color.fromARGB(143, 155, 192, 227),
      // appBar: AppBar(
      //   title: const Text('Register as NGO',
      //       style: TextStyle(color: Colors.black)),
      //   backgroundColor: Colors.lightBlue,
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
                        backgroundColor: Colors.lightBlue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      child: const Text('Submit',
                          style: TextStyle(color: Colors.black)),
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
          'Proof of Identity (POI)',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null) {
              setState(() {
                _uploadedFilePath = result.files.single.path;
              });
            }
          },
          child: const Text('Upload Document',
              style: TextStyle(color: Colors.black)),
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
