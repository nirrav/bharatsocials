import 'package:flutter/material.dart';
import 'package:bharatsocials/admins/UniAdmin/ColProfile.dart';

void main() {
  runApp(MaterialApp(
    home: CollegePage(),
  ));
}

class CollegePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('College Name'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                onTap: () {
                  // Action when the item is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CollegeProfileScreen()),
                  );
                  // Navigate to another page or perform another action here
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Item ${index + 1}', // Optional label
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
