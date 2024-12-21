import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static final UserData _instance = UserData._privateConstructor();
  factory UserData() {
    return _instance;
  }
  UserData._privateConstructor();

  String? userId;
  String? name;
  String? email;
  String? imageUrl;
  String? role;

  bool _isDataLoaded = false;

  // Fetch current user from FirebaseAuth and Firestore
  Future<void> fetchUserData() async {
    if (_isDataLoaded)
      return; // If data is already loaded, no need to fetch again

    try {
      // Check if data is available in SharedPreferences (cached)
      bool isDataCached = await _isUserDataCached();
      if (isDataCached) {
        await _loadUserDataFromCache();
        return;
      }

      // If data is not cached, fetch it from Firestore
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return; // No user is logged in
      }

      userId = currentUser.uid;

      // Fetch only required fields from Firestore to save bandwidth
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;

        // Store minimal user data in memory (for app's lifetime)
        name = data['name'];
        email = data['email'];
        imageUrl = data['image'];
        role = data['role'];

        // Cache essential data in SharedPreferences
        await _cacheUserData();

        _isDataLoaded = true; // Mark data as loaded
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // Check if user data is cached in SharedPreferences
  Future<bool> _isUserDataCached() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userId');
  }

  // Load user data from SharedPreferences (cache)
  Future<void> _loadUserDataFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    name = prefs.getString('name');
    email = prefs.getString('email');
    imageUrl = prefs.getString('imageUrl');
    role = prefs.getString('role');
  }

  // Cache minimal user data into SharedPreferences
  Future<void> _cacheUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId!);
    prefs.setString('name', name!);
    prefs.setString('email', email!);
    prefs.setString('imageUrl', imageUrl!);
    prefs.setString('role', role!);
  }

  // Check if the user is logged in
  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  // Clear user data when logging out
  Future<void> clearUserData() async {
    userId = null;
    name = null;
    email = null;
    imageUrl = null;
    role = null;

    _isDataLoaded = false; // Reset the data load flag

    // Clear cached data from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
