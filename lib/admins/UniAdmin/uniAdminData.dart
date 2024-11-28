import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminData {
  final String POIurl;
  final String adminRole;
  final String email;
  final bool isVerified;
  final String name;
  final String phone;
  final String role;
  final String uniName;

  AdminData({
    required this.POIurl,
    required this.adminRole,
    required this.email,
    required this.isVerified,
    required this.name,
    required this.phone,
    required this.role,
    required this.uniName,
  });

  // Method to fetch the data
  static Future<AdminData?> fetchAdminData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String email = user.email ?? ''; // Get the email of the current user
      print('Logged in user email: $email'); // Debugging: Log email

      try {
        // Fetch the user document from Firestore based on email
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection(
                'admins') // Collection where the user document is stored
            .where('email', isEqualTo: email) // Search by email field
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Get the first matching document's ID
          String docId = querySnapshot.docs.first.id;
          print('Document ID for user $email: $docId');

          // Fetch the document data using the document ID
          DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
              .collection('admins')
              .doc(docId) // Use the document ID found
              .get();

          if (docSnapshot.exists) {
            // Extract the data
            Map<String, dynamic> data =
                docSnapshot.data() as Map<String, dynamic>;

            // Return an AdminData object with the fetched data
            return AdminData(
              POIurl: data['POIurl'] ?? '',
              adminRole: data['adminRole'] ?? '',
              email: data['email'] ?? '',
              isVerified: data['isVerified'] ?? false,
              name: data['name'] ?? '',
              phone: data['phone'] ?? '',
              role: data['role'] ?? '',
              uniName: data['uniName'] ?? '',
            );
          } else {
            print('Document does not exist');
            return null;
          }
        } else {
          print('No document found for this user with email: $email');
          return null;
        }
      } catch (e) {
        print('Error fetching admin data: $e');
        return null;
      }
    } else {
      print('User is not logged in');
      return null;
    }
  }
}
