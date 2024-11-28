// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// // login_service.dart
// Future<void> onLogin({
//   required String email,
//   required String password,
//   required Function(bool) setLoading,
//   required Function(String) showSnackBar,
//   required Function(String, String?) onSuccess,
// }) async {
//   setLoading(true); // Start loading

//   if (email.isEmpty || password.isEmpty) {
//     setLoading(false); // Stop loading
//     showSnackBar('Please enter both email and password');
//     return;
//   }

//   try {
//     // Sign in with email and password
//     UserCredential userCredential = await FirebaseAuth.instance
//         .signInWithEmailAndPassword(email: email, password: password);

//     User? user = userCredential.user;
//     if (user == null) {
//       setLoading(false);
//       showSnackBar('Failed to fetch user data');
//       return;
//     }

//     // Print user's email and UID for debugging
//     print('Logged in as: ${user.email}, UID: ${user.uid}');

//     // Fetching user data from Firestore
//     String userRole = '';
//     String? adminRole; // Declare a variable for adminRole
//     print("Querying for volunteer...");
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('volunteers')
//         .where('email', isEqualTo: email)
//         .get();

//     if (snapshot.docs.isNotEmpty) {
//       userRole = 'volunteer';
//       print('User found as volunteer');
//     } else {
//       print("Querying for NGO...");
//       snapshot = await FirebaseFirestore.instance
//           .collection('ngos')
//           .where('email', isEqualTo: email)
//           .get();
//       if (snapshot.docs.isNotEmpty) {
//         userRole = 'ngo';
//         print('User found as NGO');
//       } else {
//         print("Querying for admin...");
//         snapshot = await FirebaseFirestore.instance
//             .collection('admins')
//             .where('email', isEqualTo: email)
//             .get();
//         if (snapshot.docs.isNotEmpty) {
//           userRole = 'admin';
//           DocumentSnapshot userDoc = snapshot.docs.first;
//           adminRole = userDoc['adminRole']; // Fetch the adminRole field
//           print('User found as admin, adminRole: $adminRole');
//         }
//       }
//     }

//     if (snapshot.docs.isNotEmpty) {
//       DocumentSnapshot userDoc = snapshot.docs.first;
//       print('Document ID: ${userDoc.id}');
//       print('User Role: $userRole'); // Print user role

//       // Return the role and adminRole using the onSuccess callback
//       onSuccess(userRole, adminRole); // Pass both userRole and adminRole
//     } else {
//       setLoading(false);
//       showSnackBar('User not found!');
//     }
//   } catch (e) {
//     setLoading(false); // Stop loading on error
//     showSnackBar('Error: $e');
//   }
// }
