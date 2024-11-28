import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        title: Text("Reason for Rejection"),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(hintText: "Enter reason for rejection"),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // Get the reason input
              String rejectionReason = reasonController.text.trim();

              if (rejectionReason.isNotEmpty) {
                try {
                  // Get the current timestamp
                  Timestamp rejectionTimestamp = Timestamp.now();

                  // Update the Firestore document
                  await FirebaseFirestore.instance
                      .collection('ngos')
                      .doc(documentId)
                      .update({
                    'isRejected': true,
                    'isVerified': false,
                    'rejectionTimestamp': rejectionTimestamp,
                    'reasonForRejection': rejectionReason,
                  });

                  print("NGO with ID: $documentId has been rejected.");
                  // Close the dialog
                  Navigator.of(context).pop();
                } catch (e) {
                  print("Error rejecting NGO: $e");
                }
              } else {
                // If no reason is provided, show a message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Please provide a reason for rejection")),
                );
              }
            },
            child: Text("Submit"),
          ),
        ],
      );
    },
  );
}

// Method for verifying the NGO
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

// Method for rejecting the NGO with reason and timestamp
Future<void> onCollegeReject(BuildContext context, String documentId) async {
  // Create a TextEditingController to manage the reason input
  TextEditingController reasonController = TextEditingController();

  // Show dialog to get reason for rejection
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Reason for Rejection"),
        content: TextField(
          controller: reasonController,
          decoration:
              const InputDecoration(hintText: "Enter reason for rejection"),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog on cancel
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // Get the reason input
              String rejectionReason = reasonController.text.trim();

              if (rejectionReason.isNotEmpty) {
                try {
                  // Get the current timestamp
                  Timestamp rejectionTimestamp = Timestamp.now();

                  // Update the Firestore document with rejection data
                  await FirebaseFirestore.instance
                      .collection('admins')
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
                  // Close the dialog
                  Navigator.of(context).pop();
                } catch (e) {
                  print("Error rejecting NGO: $e");
                }
              } else {
                // If no reason is provided, show a message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Please provide a reason for rejection")),
                );
              }
            },
            child: const Text("Submit"),
          ),
        ],
      );
    },
  );
}
