import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<String>
      eventsPosted; // Changed to List<String> to hold an array of event IDs
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
    this.eventsPosted = const [], // Initialize with an empty list
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
        'eventsPosted': eventsPosted, // Now an array
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

    // Handle eventsPosted as a List<String>
    List<String> eventsPostedList = [];
    if (data['eventsPosted'] != null) {
      if (data['eventsPosted'] is List) {
        eventsPostedList = List<String>.from(data['eventsPosted']);
      } else if (data['eventsPosted'] is String) {
        // If eventsPosted is a string, split it by commas to form a list
        eventsPostedList = List<String>.from(data['eventsPosted'].split(','));
      }
    }

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
      eventsPosted: eventsPostedList, // Use the List<String> for eventsPosted
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
