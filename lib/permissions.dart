import 'package:permission_handler/permission_handler.dart';

class Permissions {
  // Function to check and request location permission
  static Future<bool> requestLocationPermission() async {
    // Check if the permission is granted
    PermissionStatus status = await Permission.location.status;

    // If permission is already granted, return true
    if (status.isGranted) {
      return true;
    }

    // If permission is not granted, request permission
    status = await Permission.location.request();

    // Return true if permission is granted, false otherwise
    return status.isGranted;
  }

  // Function to check and request camera permission (if needed)
  static Future<bool> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    }

    status = await Permission.camera.request();
    return status.isGranted;
  }

  // Function to check and request storage permission (if needed)
  static Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;

    if (status.isGranted) {
      return true;
    }

    status = await Permission.storage.request();
    return status.isGranted;
  }

  // Function to check and request multiple permissions at once
  static Future<Map<Permission, PermissionStatus>>
      requestMultiplePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
      Permission.storage,
    ].request();

    return statuses;
  }

  // Function to check if permissions are granted
  static Future<bool> checkAllPermissionsGranted() async {
    bool locationPermission = await Permission.location.isGranted;
    bool cameraPermission = await Permission.camera.isGranted;
    bool storagePermission = await Permission.storage.isGranted;

    return locationPermission && cameraPermission && storagePermission;
  }
}
