import 'package:bharatsocials/screens/NGOList.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  late ScrollController _scrollController;
  Timer? _bannerTimer;
  int currentPage = 0;
  final int bannerCount = 4;

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
      // Add more NGOs with similar structure
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
      // Add more NGOs with similar structure
    ],
    'Environment Sustainability': [
      // Add NGOs
    ],
    'Health & Hygiene': [
      // Add NGOs
    ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          children: <Widget>[
            // Banner
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 198, 238, 247),
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
                            color: Color.fromARGB(255, 248, 68, 68),
                            fontSize: 20),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NGOListScreen(
                          category: 'Sarva Sikhsha',
                          ngos: domainData['Sarva Sikhsha']!,
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(162, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.school, size: 60, color: Colors.blue),
                          Text('Sarva ', style: TextStyle(fontSize: 18)),
                          Text(' Sikhsha ', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NGOListScreen(
                          category: 'Women Empowerment',
                          ngos: domainData['Women Empowerment']!,
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(162, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.woman, size: 60, color: Colors.purple),
                          Text('     Women ', style: TextStyle(fontSize: 18)),
                          Text(' Empowerment ', style: TextStyle(fontSize: 18)),
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NGOListScreen(
                                category: 'Environment Sustainability',
                                ngos: domainData['Environment Sustainability']!,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 140,
                          height: 140,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(162, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.eco, size: 60, color: Colors.green),
                                Text('    Environment ',
                                    style: TextStyle(fontSize: 18)),
                                Text('   Sustainability',
                                    style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 50),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NGOListScreen(
                                category: 'Health & Hygiene',
                                ngos: domainData['Health & Hygiene']!,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 140,
                          height: 140,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(162, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.medical_services,
                                    size: 60, color: Colors.red),
                                Text('   Health & ',
                                    style: TextStyle(fontSize: 18)),
                                Text('Hygiene', style: TextStyle(fontSize: 18)),
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
