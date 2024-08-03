import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.fromARGB(143, 155, 192, 227), // Light blue background
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
                    'LOGIN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Enter your details to get logged in to your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Username/Email',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIcon:
                          Icon(Icons.visibility_off, color: Colors.black),
                    ),
                    obscureText: true,
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle forgot password
                      },
                      child: const Text(
                        'Forgot Password?',
                        style:
                            TextStyle(color: Color.fromARGB(255, 24, 105, 211)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),
                  ElevatedButton(
                    onPressed: () {
                      // Handle login
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(127, 191, 220, 1),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text(
                      'Log in',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Handle register now
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Register Now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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
