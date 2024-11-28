import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatsocials/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bharatsocials/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bharatsocials/notifications.dart'; // Import notifications.dart

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize local notifications
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
      home: SplashScreen(),
    );
  }
}

Future<void> initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create a default notification channel for Android 8.0+ devices
  if (Platform.isAndroid) {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel', // Channel ID
      'Default Notifications', // Channel name
      description:
          'This is the default notification channel for app notifications',
      importance: Importance.high,
      playSound: true,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
