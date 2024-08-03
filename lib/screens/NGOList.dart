import 'package:bharatsocials/screens/ngoProfile.dart';
import 'package:flutter/material.dart';

class NGOListScreen extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> ngos;

  const NGOListScreen({super.key, required this.category, required this.ngos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFFCDEBF7),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0), // Height of the border
          child: Container(
            color: Colors.transparent, // Background color of the bottom area
            child: Container(
              height: 1.0, // Thickness of the border
              color: Colors.black, // Border color with opacity
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: ngos.length,
        itemBuilder: (context, index) {
          final ngo = ngos[index];
          final String name = ngo['name'] ?? 'No name';
          final String location = ngo['location'] ?? 'No location';
          final String description =
              ngo['description'] ?? 'No description available';
          final String imagePath =
              ngo['imagePath'] ?? 'assets/default_image.png';

          final List<SocialMedia> socialMedia =
              (ngo['socialMedia'] as List<dynamic>?)?.map((item) {
                    final int iconCode = item['iconCode'] as int;
                    final Color color = Color(item['color'] as int);
                    return SocialMedia(
                      IconData(iconCode, fontFamily: 'MaterialIcons'),
                      color,
                    );
                  }).toList() ??
                  [];

          return Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(152, 220, 247, 0.762),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 8, 7, 7).withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(6, 6),
                ),
              ],
              border: Border.all(
                color:
                    const Color.fromARGB(255, 128, 131, 136).withOpacity(0.5),
                width: 0.9,
              ),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(
                name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Location: $location',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward, color: Colors.black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NgoProfileScreen(
                      name: name,
                      location: location,
                      description: description,
                      imagePath: imagePath,
                      socialMedia: socialMedia,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
