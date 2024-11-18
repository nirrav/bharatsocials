import 'package:flutter/material.dart';

class DropdownFieldWidget extends StatelessWidget {
  final String label;
  final bool isDarkMode;

  const DropdownFieldWidget({required this.label, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            height: 1.5,
          ),
          border: InputBorder.none,
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: isDarkMode ? Colors.white : Colors.black),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        items: <String>[
          'First Year',
          'Second Year',
          'Third Year',
          'Fourth Year'
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (_) {},
      ),
    );
  }
}
