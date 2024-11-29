import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bharatsocials/api/firebase_api.dart';
import 'package:bharatsocials/firebase_options.dart';
import 'package:bharatsocials/volunteers/NotiPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bharatsocials/notifications.dart'; // Import notifications.dart

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Pass the navigatorKey when creating the FirebaseApi instance
  final firebaseApi = FirebaseApi(navigatorKey: navigatorKey);

  await firebaseApi.initNotifications();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await initializeLocalNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bharat Socials',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white, // Light mode background color
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w500, // Medium weight
            fontSize: 16,
          ),
        ),
        useMaterial3: true, // Use Material 3
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor:
            const Color(0xFF333333), // Charcoal gray background for dark mode
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500, // Medium weight
            fontSize: 16,
          ),
        ),
        useMaterial3: true, // Use Material 3
      ),
      themeMode: ThemeMode
          .system, // Auto-switch between light/dark based on system theme
      navigatorKey: navigatorKey,
      home: const SplashScreen(),
      routes: {NotificationPage.route: (context) => const NotificationPage()},
    );
  }
}
