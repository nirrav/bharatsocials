import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VolunteerData {
  final String collegeName;
  final String department;
  final String email;
  final String fcmToken;
  final String image;
  final bool isVerified;
  final String name;
  final String phone;
  final String role;
  final String rollno;

  VolunteerData({
    required this.collegeName,
    required this.department,
    required this.email,
    required this.fcmToken,
    required this.image,
    required this.isVerified,
    required this.name,
    required this.phone,
    required this.role,
    required this.rollno,
  });

  // Method to fetch volunteer data
  static Future<VolunteerData?> fetchVolunteerData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('User is not logged in');
      return null; // Return null if user is not logged in
    }

    String? email = user.email;

    if (email == null || email.isEmpty) {
      print('User email is not available');
      return null; // Return null if email is not available
    }

    print('Logged in user email: $email'); // Debugging: Log email

    try {
      // Fetch the volunteer document from Firestore based on email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('volunteers')
          .where('email', isEqualTo: email)
          .get(const GetOptions(
              source: Source.server)); // Force fresh data from the server

      print('Query result count: ${querySnapshot.docs.length}');
      if (querySnapshot.docs.isEmpty) {
        print('No document found for this user with email: $email');
        return null; // Return null if no matching document is found
      }

      // Get the first matching document's ID
      String docId = querySnapshot.docs.first.id;
      print(
          'Document ID for user $email: $docId'); // Debugging: Log document ID

      // Fetch the document data using the document ID
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('volunteers')
          .doc(docId) // Use the document ID found
          .get();

      if (!docSnapshot.exists) {
        print('Document does not exist in Firestore');
        return null; // Return null if document does not exist
      }

      // Extract the data
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      // Return a VolunteerData object with the fetched data
      return VolunteerData(
        collegeName: data['collegeName'] ?? 'Not Provided',
        department: data['department'] ?? 'Not Provided',
        email: data['email'] ??
            email, // Use the logged-in user's email if not found
        fcmToken: data['fcmToken'] ?? 'Not Provided',
        image: data['image'] ?? 'Not Provided',
        isVerified: data['isVerified'] ?? false,
        name: data['name'] ?? 'Not Provided',
        phone: data['phone'] ?? 'Not Provided',
        role: data['role'] ?? 'Not Provided',
        rollno: data['rollno'] ?? 'Not Provided',
      );
    } catch (e) {
      print('Error fetching volunteer data: $e');
      return null; // Return null if any error occurs
    }
  }
}
