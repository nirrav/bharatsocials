import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CollegeProfileScreen(),
    );
  }
}

class CollegeProfileScreen extends StatelessWidget {
  const CollegeProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'College Profile',
          style: TextStyle(color: Colors.black), // Set text color to black
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // Set AppBar background color to white
        elevation: 0, // Removes shadow under the AppBar
        iconTheme: const IconThemeData(
            color: Colors.black), // Sets back button color to black
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile photo taking 25% of the screen
            Container(
              height: screenHeight * 0.25,
              child: Center(
                child: CircleAvatar(
                  radius: screenHeight * 0.1,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card containing name, code, and location with fixed size
            SizedBox(
              height: 250, // Fixed height for the card
              width: double.infinity, // Fixed width (full width)
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0,
                            bottom: 16.0), // Add top and bottom padding
                        child: Text(
                          'Name ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 16), // Padding between Name and Code
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0,
                            bottom: 16.0), // Add top and bottom padding
                        child: Text(
                          'Code ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 16), // Padding between Code and Location
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0,
                            bottom: 16.0), // Add top and bottom padding
                        child: Text(
                          'Location  ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Card containing number of volunteers with fixed size
            SizedBox(
              height: 100, // Fixed height for the card
              width: double.infinity, // Fixed width (full width)
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Number of Volunteers ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
