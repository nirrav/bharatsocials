import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final bool isActive;
  final bool isDarkMode;

  const DotIndicator({required this.isActive, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        color:
            isActive ? (isDarkMode ? Colors.white : Colors.black) : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
