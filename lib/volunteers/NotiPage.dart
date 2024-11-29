import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});
  static const route = '/NotificationPage';

  @override
  Widget build(BuildContext context) {
    // Retrieve the RemoteMessage passed as argument
    final remoteMessage =
        ModalRoute.of(context)!.settings.arguments as RemoteMessage?;

    // Extract notification details
    final title = remoteMessage?.notification?.title ?? 'No title';
    final body = remoteMessage?.notification?.body ?? 'No body';
    final data = remoteMessage?.data.toString() ?? 'No data';

    return Scaffold(
      backgroundColor: AppColors.appBgColor(context),
      appBar: AppBar(title: Text('Notification Page for firebase')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Title: $title',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppColors.defualtTextColor(context))),
            const SizedBox(height: 10),
            Text('Body: $body',
                style: TextStyle(
                    fontSize: 15, color: AppColors.defualtTextColor(context))),
            const SizedBox(height: 10),
            Text('Data: $data',
                style: TextStyle(
                    fontSize: 15, color: AppColors.defualtTextColor(context))),
          ],
        ),
      ),
    );
  }
}
