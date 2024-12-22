import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Method for verifying the NGO
Future<void> onNgoVerify(String documentId) async {
  try {
    await FirebaseFirestore.instance
        .collection('ngos')
        .doc(documentId)
        .update({'isVerified': true});

    print("NGO with ID: $documentId has been verified.");
  } catch (e) {
    print("Error verifying NGO: $e");
  }
}

// Method for rejecting the NGO with reason and timestamp
Future<void> onNgoReject(BuildContext context, String documentId) async {
  // Create a TextEditingController to manage the reason input
  TextEditingController reasonController = TextEditingController();

  // Show dialog to get reason for rejection
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Reason for Rejection",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Please provide a reason for rejection. This will help in processing the request.",
              style: TextStyle(color: AppColors.defualtTextColor(context)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: "Reason for Rejection",
                hintText: "Enter reason here",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              maxLines: 4,
              minLines: 1,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog on cancel
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.titleColor(context),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              backgroundColor: Colors.grey,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              String rejectionReason = reasonController.text.trim();

              if (rejectionReason.isNotEmpty) {
                try {
                  // Show a loading indicator
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  // Get the current timestamp
                  Timestamp rejectionTimestamp = Timestamp.now();

                  // Update the Firestore document with rejection data
                  await FirebaseFirestore.instance
                      .collection('ngos') // Collection name
                      .doc(documentId) // Directly reference the document by ID
                      .update({
                    'isRejected': true, // Mark as rejected
                    'isVerified': false, // Mark as unverified
                    'rejectionTimestamp':
                        rejectionTimestamp, // Add rejection timestamp
                    'reasonForRejection':
                        rejectionReason, // Store rejection reason
                  });

                  print("NGO with ID: $documentId has been rejected.");
                  Navigator.of(context)
                      .pop(); // Close the loading indicator dialog
                  Navigator.of(context).pop(); // Close the rejection dialog
                } catch (e) {
                  Navigator.of(context)
                      .pop(); // Close the loading indicator dialog
                  print("Error rejecting NGO: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("An error occurred. Please try again."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } else {
                // If no reason is provided, show a message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Please provide a reason for rejection")),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              backgroundColor: Colors.red,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text("Submit"),
          ),
        ],
      );
    },
  );
}

// Method for verifying the Volunteer
Future<void> onVolunteerVerify(String documentId) async {
  try {
    // Update the 'isVerified' field for the document with the given documentId
    await FirebaseFirestore.instance
        .collection('volunteers') // Collection for volunteers
        .doc(documentId) // Directly reference the document by ID
        .update({'isVerified': true}); // Mark as verified

    print("Volunteer with ID: $documentId has been verified.");
  } catch (e) {
    print("Error verifying Volunteer: $e");
  }
}

// Method for rejecting the Volunteer with reason and timestamp
Future<void> onVolunteerReject(BuildContext context, String documentId) async {
  // Create a TextEditingController to manage the reason input
  TextEditingController reasonController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Reason for Rejection",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Please provide a reason for rejection. This will help in processing the request.",
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: "Reason for Rejection",
                hintText: "Enter reason here",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              maxLines: 4,
              minLines: 1,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog on cancel
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.titleColor(context),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              backgroundColor: Colors.grey,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              String rejectionReason = reasonController.text.trim();

              if (rejectionReason.isNotEmpty) {
                try {
                  // Show a loading indicator
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  // Get the current timestamp
                  Timestamp rejectionTimestamp = Timestamp.now();

                  // Update the Firestore document with rejection data
                  await FirebaseFirestore.instance
                      .collection('volunteers') // Collection for volunteers
                      .doc(documentId) // Directly reference the document by ID
                      .update({
                    'isRejected': true, // Mark as rejected
                    'isVerified': false, // Mark as unverified
                    'rejectionTimestamp':
                        rejectionTimestamp, // Add rejection timestamp
                    'reasonForRejection':
                        rejectionReason, // Store rejection reason
                  });

                  print("Volunteer with ID: $documentId has been rejected.");
                  Navigator.of(context)
                      .pop(); // Close the loading indicator dialog
                  Navigator.of(context).pop(); // Close the rejection dialog
                } catch (e) {
                  Navigator.of(context)
                      .pop(); // Close the loading indicator dialog
                  print("Error rejecting Volunteer: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("An error occurred. Please try again."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } else {
                // If no reason is provided, show a message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Please provide a reason for rejection")),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              backgroundColor: Colors.red,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text("Submit"),
          ),
        ],
      );
    },
  );
}

// Method for verifying the College
Future<void> onCollegeVerify(String documentId) async {
  try {
    // Update the 'isVerified' field for the document with the given documentId
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(documentId) // Directly reference the document by ID
        .update({'isVerified': true}); // Mark as verified

    print("NGO with ID: $documentId has been verified.");
  } catch (e) {
    print("Error verifying NGO: $e");
  }
}

// Method for rejecting the College with reason and timestamp
Future<void> onCollegeReject(BuildContext context, String documentId) async {
  // Create a TextEditingController to manage the reason input
  TextEditingController reasonController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Reason for Rejection",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Please provide a reason for rejection. This will help in processing the request.",
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: "Reason for Rejection",
                hintText: "Enter reason here",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              maxLines: 4,
              minLines: 1,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog on cancel
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.titleColor(context),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              backgroundColor: Colors.grey,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              String rejectionReason = reasonController.text.trim();

              if (rejectionReason.isNotEmpty) {
                try {
                  // Show a loading indicator
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  // Get the current timestamp
                  Timestamp rejectionTimestamp = Timestamp.now();

                  // Update the Firestore document with rejection data
                  await FirebaseFirestore.instance
                      .collection('admins')
                      .doc(documentId)
                      .update({
                    'isRejected': true,
                    'isVerified': false,
                    'rejectionTimestamp': rejectionTimestamp,
                    'reasonForRejection': rejectionReason,
                  });

                  print("NGO with ID: $documentId has been rejected.");
                  Navigator.of(context)
                      .pop(); // Close the loading indicator dialog
                  Navigator.of(context).pop(); // Close the rejection dialog
                } catch (e) {
                  Navigator.of(context)
                      .pop(); // Close the loading indicator dialog
                  print("Error rejecting NGO: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("An error occurred. Please try again."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } else {
                // If no reason is provided, show a message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Please provide a reason for rejection")),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              backgroundColor: Colors.red,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text("Submit"),
          ),
        ],
      );
    },
  );
}
