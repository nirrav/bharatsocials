import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NgoData {
  final String ngoId;
  final String name;
  final String email;
  final String phone;
  final String city;
  final String fcmToken;
  final String image;
  final bool isVerified;
  final String role;

  NgoData({
    required this.ngoId,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.fcmToken,
    required this.image,
    required this.isVerified,
    required this.role,
  });

  // Method to fetch the data
  static Future<NgoData?> fetchNgoData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String email = user.email ?? ''; // Get the email of the current user
      print('Logged in user email: $email'); // Debugging: Log email

      try {
        // Fetch the ngo document from Firestore based on email
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('ngos') // Collection where the ngo document is stored
            .where('email', isEqualTo: email) // Search by email field
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Get the first matching document's ID
          String docId = querySnapshot.docs.first.id;
          print('Document ID for NGO $email: $docId');

          // Fetch the document data using the document ID
          DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
              .collection('ngos')
              .doc(docId) // Use the document ID found
              .get();

          if (docSnapshot.exists) {
            // Extract the data
            Map<String, dynamic> data =
                docSnapshot.data() as Map<String, dynamic>;

            // Return a NgoData object with the fetched data
            return NgoData(
              ngoId: docId, // Add the document ID for reference
              name: data['name'] ?? '',
              email: data['email'] ?? '',
              phone: data['phone'] ?? '',
              city: data['city'] ?? '',
              fcmToken: data['fcmToken'] ?? '',
              image: data['image'] ?? '',
              isVerified: data['isVerified'] ?? false,
              role: data['role'] ?? '',
            );
          } else {
            print('Document does not exist');
            return null;
          }
        } else {
          print('No document found for this NGO with email: $email');
          return null;
        }
      } catch (e) {
        print('Error fetching NGO data: $e');
        return null;
      }
    } else {
      print('User is not logged in');
      return null;
    }
  }
}
