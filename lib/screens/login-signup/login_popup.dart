import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'ngo_register_page.dart';

class LoginPopUp extends StatelessWidget {
  const LoginPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 155, 192, 227),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 100,
              backgroundColor: Color.fromARGB(255, 224, 224, 224),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(), // Navigate to LoginPage as a full-screen page
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: const Text(
                            "Register As ?",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(color: Colors.black),
                                  ),
                                ),
                                child: const Text(
                                  "User",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 45, 17, 17),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NgoRegisterPage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(color: Colors.black),
                                  ),
                                ),
                                child: const Text(
                                  "NGO",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
