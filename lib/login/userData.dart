import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  String documentId; // Field to store the document ID
  String email;
  String image;
  bool isVerified;
  String fcmToken;
  String role; // Either 'volunteer', 'ngo', or 'admin'
  String firstName;
  String middleName;
  String lastName;
  String phone;
  String rollNo;
  String department;
  String collegeName;
  String organizationName;
  String contactNumber;
  String city;
  String adminName;
  String adminPhone;
  String adminRole;
  String password; // Only for admin to manage registration

  // Constructor for UserData
  UserData({
    required this.documentId, // Include documentId as a required field
    required this.email,
    required this.image,
    required this.isVerified,
    required this.fcmToken,
    required this.role, // Set to 'volunteer' or 'ngo'
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.phone = '',
    this.rollNo = '',
    this.department = '',
    this.collegeName = '',
    this.organizationName = '',
    this.contactNumber = '',
    this.city = '',
    this.adminName = '',
    this.adminPhone = '',
    this.adminRole = '',
    this.password = '', // Admin's password for registration
  });

  // Convert the UserData instance into a map to store in Firestore
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'email': email,
      'image': image,
      'isVerified': isVerified,
      'fcmToken': fcmToken,
      'role': role,
    };

    if (role == 'volunteer') {
      data.addAll({
        'first_name': firstName,
        'middle_name': middleName,
        'last_name': lastName,
        'phone': phone,
        'roll_no': rollNo,
        'department': department,
        'college_name': collegeName,
      });
    } else if (role == 'ngo') {
      data.addAll({
        'organization_name': organizationName,
        'contact_number': contactNumber,
        'city': city,
      });
    } else if (role == 'admin') {
      data.addAll({
        'admin_name': adminName,
        'admin_phone': adminPhone,
        'admin_role': adminRole,
        'password':
            password, // Do not store password in plain text in real applications
      });

      if (adminRole == 'college') {
        data['college_name'] =
            collegeName; // Assuming admin can have a college name
      } else if (adminRole == 'uni') {
        data['university_name'] =
            collegeName; // Assuming admin can have a university name
      }
    }

    return data;
  }

  // Factory constructor to create an instance from Firestore document snapshot
  factory UserData.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return UserData(
      documentId: doc.id, // Get the document ID from Firestore
      email: data['email'] ?? '',
      image: data['image'] ?? '',
      isVerified: data['isVerified'] ?? false,
      fcmToken: data['fcmToken'] ?? '',
      role: data['role'] ?? '',
      firstName: data['first_name'] ?? '',
      middleName: data['middle_name'] ?? '',
      lastName: data['last_name'] ?? '',
      phone: data['phone'] ?? '',
      rollNo: data['roll_no'] ?? '',
      department: data['department'] ?? '',
      collegeName: data['college_name'] ?? '',
      organizationName: data['organization_name'] ?? '',
      contactNumber: data['contact_number'] ?? '',
      city: data['city'] ?? '',
      adminName: data['admin_name'] ?? '',
      adminPhone: data['admin_phone'] ?? '',
      adminRole: data['admin_role'] ?? '',
      password: data['password'] ?? '',
    );
  }
}

class GlobalUser {
  static UserData? currentUser;
}

class UserDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch the current user's data from Firestore and update GlobalUser
  Future<void> fetchCurrentUser() async {
    try {
      // Get the current user's UID from Firebase Authentication
      User? user = _auth.currentUser;
      if (user != null) {
        // Use the UID to fetch the document from Firestore
        DocumentSnapshot doc =
            await _db.collection('users').doc(user.uid).get();

        if (doc.exists) {
          // Update GlobalUser with the fetched data
          GlobalUser.currentUser = UserData.fromFirestore(doc);
        } else {
          // Handle the case where the user document is not found
          print("User document not found in Firestore");
        }
      } else {
        // Handle the case where the user is not logged in
        print("No user is currently logged in");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
}
