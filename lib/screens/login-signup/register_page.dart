// register_page.dart
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _organDonor = 'Yes';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(143, 155, 192, 227),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Register',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'First Name',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.person, color: Colors.black),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon:
                          Icon(Icons.account_circle, color: Colors.black),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.email, color: Colors.black),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Contact No.',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.phone, color: Colors.black),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Blood Group',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.bloodtype, color: Colors.black),
                    ),
                    items: _bloodGroups.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: const TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a blood group';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Are you an organ donor?',
                          style: TextStyle(color: Colors.black)),
                      Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Radio<String>(
                                value: 'No',
                                groupValue: _organDonor,
                                activeColor: Colors.black,
                                onChanged: (value) {
                                  setState(() {
                                    _organDonor = value!;
                                  });
                                },
                              ),
                              const Text('No',
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio<String>(
                                value: 'Yes',
                                groupValue: _organDonor,
                                activeColor: Colors.black,
                                onChanged: (value) {
                                  setState(() {
                                    _organDonor = value!;
                                  });
                                },
                              ),
                              const Text('Yes',
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle registration
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(191, 235, 255, 1),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('Register',
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
