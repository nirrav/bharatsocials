import 'package:flutter/material.dart';
import 'home.dart';
import 'groups.dart';
import 'events.dart';

class NgoProfileScreen extends StatelessWidget {
  final String name;
  final String location;
  final String description;
  final String imagePath;
  final List<SocialMedia> socialMedia;

  const NgoProfileScreen({
    super.key,
    required this.name,
    required this.location,
    required this.description,
    required this.imagePath,
    required this.socialMedia,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: TextStyle(
              fontWeight: FontWeight.bold), // Fix: TextStyle was missing
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color.fromARGB(255, 125, 217, 239),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBanner(screenSize),
            _buildNgoInfo(screenSize),
            _buildAboutSection(screenSize),
            _buildSocialMediaSection(screenSize),
            _buildWebsiteSection(screenSize),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBanner(Size screenSize) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(15)),
          child: Container(
            width: screenSize.width,
            height: screenSize.height * 0.3,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/nature.jpg'), // replace with your image
                fit: BoxFit.cover,
              ),
              // gradient: LinearGradient(
              //   colors: [
              //     Color.fromARGB(255, 204, 110, 255),
              //     Color.fromARGB(255, 19, 114, 255),
              //     Color.fromARGB(255, 111, 229, 255),
              //   ],
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              // ),
            ),
            child: Center(
              child: Icon(
                Icons.image,
                size: 100,
                color: const Color.fromARGB(0, 189, 189, 189),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -screenSize.height * 0.08,
          left: screenSize.width * 0.03,
          child: CircleAvatar(
            radius: 75,
            backgroundImage: AssetImage(imagePath),
            backgroundColor: Color.fromARGB(255, 68, 229, 235),
            onBackgroundImageError: (_, __) {},
          ),
        ),
      ],
    );
  }

  Widget _buildNgoInfo(Size screenSize) {
    return Padding(
      padding: EdgeInsets.only(top: screenSize.width * 0.2),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: screenSize.width * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenSize.height * 0.01),
          Padding(
            // padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.001),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Domain: [Domain]', // Replace with actual domain if available
                  style: TextStyle(
                    fontSize: screenSize.width * 0.04,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Text(
                  'Location: $location',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.04,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(Size screenSize) {
    return Padding(
      padding: EdgeInsets.all(screenSize.width * 0.04),
      child: Container(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 205, 205, 205),
          borderRadius: BorderRadius.circular(screenSize.width * 0.04),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(
                fontSize: screenSize.width * 0.05,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            SizedBox(height: screenSize.height * 0.01),
            Text(
              description,
              style: TextStyle(
                fontSize: screenSize.width * 0.04,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('More'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection(Size screenSize) {
    return Padding(
      padding: EdgeInsets.all(screenSize.width * 0.04),
      child: Container(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(screenSize.width * 0.04),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Social',
              style: TextStyle(
                fontSize: screenSize.width * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screenSize.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: socialMedia
                  .map(
                    (media) => IconButton(
                      icon: Icon(media.icon),
                      color: media.color,
                      iconSize: screenSize.width * 0.1,
                      onPressed: () {},
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebsiteSection(Size screenSize) {
    return Padding(
      padding: EdgeInsets.all(screenSize.width * 0.04),
      child: Container(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(screenSize.width * 0.04),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Website',
              style: TextStyle(
                fontSize: screenSize.width * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screenSize.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.link),
                  color: Colors.white,
                  iconSize: screenSize.width * 0.1,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Groups',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Events',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GroupsScreen()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EventsScreen()),
            );
            break;
        }
      },
    );
  }
}

class SocialMedia {
  final IconData icon;
  final Color color;

  SocialMedia(this.icon, this.color);
}
