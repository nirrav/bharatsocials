// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/groups.dart';
import 'screens/events.dart';
import 'screens/sidebar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _children = [
    HomeScreen(
      isLoggedIn: true,
    ),
    GroupsScreen(),
    EventsScreen(),
  ];

  final List<String> _titles = [
    'Socials',
    'NGO Broadcast Page',
    'Registered Events',
  ];

  void onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold),
        backgroundColor: Color(0xFFCDEBF7),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            color: Color.fromRGBO(0, 0, 0, 0.3333333333333333),
          ),
        ),
      ),
      drawer: Sidebar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/appbackground.png'), // replace with your image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: _children,
              ),
            ),
            Container(
              height: 5,
              color: Colors.grey[300],
            ),
            BottomNavigationBar(
              backgroundColor: Color(0xFFCDEBF7),
              onTap: onTabTapped,
              currentIndex: _currentIndex,
              items: [
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
            ),
          ],
        ),
      ),
    );
  }
}
