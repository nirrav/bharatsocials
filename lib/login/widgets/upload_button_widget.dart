import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image picker package

class UploadButtonWidget extends StatefulWidget {
  final String label;
  final bool isDarkMode;
  final Function(File?) onImageSelected; // Callback function to send image back

  const UploadButtonWidget({
    super.key,
    required this.label,
    required this.isDarkMode,
    required this.onImageSelected, // Pass the callback here
  });

  @override
  _UploadButtonWidgetState createState() => _UploadButtonWidgetState();
}

class _UploadButtonWidgetState extends State<UploadButtonWidget> {
  XFile? _image; // Variable to hold the selected image

  // Function to pick an image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Pick image from the gallery
    final XFile? pickedImage = await picker.pickImage(
      source:
          ImageSource.gallery, // You can also use ImageSource.camera for camera
    );

    if (pickedImage != null) {
      setState(() {
        _image = pickedImage; // Update the state with the picked image
      });
      print("Image selected: ${pickedImage.name}"); // Print the image filename
      widget.onImageSelected(
          File(pickedImage.path)); // Pass the image back to parent widget
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed:
                _pickImage, // Trigger the image picker when the button is pressed
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.isDarkMode ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(13), // Add border radius of 13
              ),
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.isDarkMode ? Colors.black : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // If an image is selected, show a thumbnail of the image
          if (_image != null)
            Image.file(
              File(_image!.path),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
        ],
      ),
    );
  }
}
