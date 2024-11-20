import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  // Function to request storage permission
  static Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();

    // Continuously ask for permission if it is denied
    while (!status.isGranted) {
      // If denied, ask the user to allow permission
      print('Permission denied. Requesting again...');
      await Future.delayed(
          Duration(seconds: 2)); // Small delay before re-requesting
      status = await Permission.storage.request();
    }

    // If granted, return true
    print('Permission granted');
    return true;
  }
}
