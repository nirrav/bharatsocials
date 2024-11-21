import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Method to initialize local notifications
Future<void> initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = const InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// Background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  // Handle background notifications here
}

// Method to display a local notification
Future<void> showNotification({String? title, String? body, int? id}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'messages_channel_id',
    'Messages',
    channelDescription: 'This channel is used for message notifications',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    id ?? 0,
    title,
    body,
    platformChannelSpecifics,
    payload: 'default_sound',
  );
}

// Handles specific message actions
void handleMessage(RemoteMessage message) {
  print('Received a message: ${message.data}');
  if (message.data['type'] == 'ngo_registration') {
    print('Navigating to the specific screen for NGO registration');
    // Navigate to the specific screen here
  }
}

// Initializes Firebase Messaging for foreground and background handling
Future<void> initializeFirebaseMessaging() async {
  // Check if the app was opened from a terminated state
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print('App opened from a terminated state!');
    handleMessage(initialMessage);
  }

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message while in the foreground!');
    if (message.notification != null) {
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        showNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          id: message.messageId.hashCode,
        );
      }
    }
  });

  // Handle messages when the app is in the background and opened
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Message clicked!');
    handleMessage(message);
  });
}
