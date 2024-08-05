import 'package:bharatsocials/screens/NGOList.dart';
import 'package:bharatsocials/screens/login-signup/login_popup.dart'; // Import the login screen
import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required bool isLoggedIn});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  late ScrollController _scrollController;
  Timer? _bannerTimer;
  int currentPage = 0;
  final int bannerCount = 4;
  final bool _isLoggedIn =
      true; // VARIABLE TO CHECK IF USER HAS LOGGED IN OR NO

  late List<String> bannerImages;
  List<String> events = [
    "Event 1: Health Camp on 5th Aug",
    "Event 2: Tree Plantation on 12th Aug",
    "Event 3: Education Workshop on 20th Aug",
    "Event 4: Women's Empowerment Session on 25th Aug",
  ];

  final Map<String, List<Map<String, dynamic>>> domainData = {
    'Sarva Sikhsha': [
      {
        'name': 'Education First NGO',
        'location': 'Ahmedabad',
        'color': '0xFFFFF8E0',
        'description':
            'Focuses on providing education to underprivileged children.',
        'imagePath': 'assets/education_first.png',
        'socialMedia': [
          {'iconCode': 0xe8b6, 'color': 0xFF3b5998} // Facebook icon
        ]
      },
      {
        'name': 'Learning Together',
        'location': 'Jaipur',
        'color': '0xFFE0E0FF',
        'description': 'Promotes collaborative learning and skill development.',
        'imagePath': 'assets/learning_together.png',
        'socialMedia': [
          {'iconCode': 0xe0be, 'color': 0xFF1DA1F2} // Twitter icon
        ]
      },
    ],
    'Women Empowerment': [
      {
        'name': 'Empower Women NGO',
        'location': 'Bangalore',
        'color': '0xFFFFE0E0',
        'description': 'Supports women in achieving economic independence.',
        'imagePath': 'assets/empower_women.png',
        'socialMedia': [
          {'iconCode': 0xe0b0, 'color': 0xFFDD4B39} // Instagram icon
        ]
      },
    ],
    'Environment Sustainability': [],
    'Health & Hygiene': [],
  };

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage);
    _scrollController = ScrollController();
    _startScrolling();

    bannerImages = List.generate(bannerCount,
        (index) => 'https://via.placeholder.com/300x150?text=Banner+$index');

    _bannerTimer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_pageController.hasClients) {
        if (currentPage < bannerCount - 1) {
          currentPage++;
        } else {
          currentPage = 0;
        }
        _pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void _startScrolling() {
    Future.delayed(const Duration(seconds: 2), () {
      if (_scrollController.hasClients) {
        _scrollController
            .animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 10),
          curve: Curves.linear,
        )
            .then((_) {
          if (_scrollController.hasClients) {
            _scrollController
                .jumpTo(_scrollController.position.minScrollExtent);
            _startScrolling();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _bannerTimer?.cancel();
    _bannerTimer = null;
    super.dispose();
  }

  void _handleDomainTap(String category) {
    if (_isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NGOListScreen(
            category: category,
            ngos: domainData[category]!,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            onLoginStatusChanged: (status) {
              // Handle the login status change here
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          children: <Widget>[
            // Marquee
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(198, 86, 218, 248),
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromRGBO(0, 0, 0, 0.343),
                    width: 1,
                  ),
                ),
              ),
              height: 50,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: Text(
                        events[index],
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 225,
              child: PageView.builder(
                controller: _pageController,
                itemCount: bannerImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(bannerImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () => _handleDomainTap('Sarva Sikhsha'),
                  child: SizedBox(
                    width: 160,
                    height: 160,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/texture.jpg'), // Replace with your background image path
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors
                              .transparent, // Semi-transparent overlay to ensure readability
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.school, size: 60, color: Colors.blue),
                            Text('Sarva ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(' Sikhsha ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                InkWell(
                  onTap: () => _handleDomainTap('Women Empowerment'),
                  child: SizedBox(
                    width: 160,
                    height: 160,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/texture.jpg'), // Replace with your background image path
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.woman, size: 60, color: Colors.purple),
                          Text('     Women ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(' Empowerment ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () =>
                            _handleDomainTap('Environment Sustainability'),
                        child: SizedBox(
                          width: 160,
                          height: 160,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/texture.jpg'), // Replace with your background image path
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.eco, size: 60, color: Colors.green),
                                Text('    Environment ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text('   Sustainability',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 50),
                      InkWell(
                        onTap: () => _handleDomainTap('Health & Hygiene'),
                        child: SizedBox(
                          width: 160,
                          height: 160,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/texture.jpg'), // Replace with your background image path
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.medical_services,
                                    size: 60, color: Colors.red),
                                Text('   Health & ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text('Hygiene',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
