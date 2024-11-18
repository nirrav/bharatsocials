import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PasswordFieldWidget extends StatelessWidget {
  final String label;
  final bool isDarkMode;
  final TextEditingController controller;
  final bool showStrengthIndicator;
  final bool isPasswordVisible;
  final VoidCallback togglePasswordVisibility;
  final String passwordStrength; // Added to pass the strength value
  final ValueChanged<String> onPasswordChanged; // Callback for password change

  const PasswordFieldWidget({
    required this.label,
    required this.isDarkMode,
    required this.controller,
    required this.showStrengthIndicator,
    required this.isPasswordVisible,
    required this.togglePasswordVisibility,
    required this.passwordStrength, // Added to pass the strength value
    required this.onPasswordChanged, // Callback to handle password change
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  height: 1.5,
                ),
              ),
              if (showStrengthIndicator) ...[
                const SizedBox(width: 10),
                _buildPasswordStrengthDot(passwordStrength, 0),
                _buildPasswordStrengthDot(passwordStrength, 1),
                _buildPasswordStrengthDot(passwordStrength, 2),
              ]
            ],
          ),
          TextField(
            controller: controller,
            obscureText: !isPasswordVisible,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            onChanged: onPasswordChanged, // Notify parent widget of changes
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                height: 1.5,
              ),
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: isDarkMode ? Colors.white : Colors.black),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: isDarkMode ? Colors.white : Colors.black),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: togglePasswordVisibility,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthDot(String passwordStrength, int index) {
    Color color;
    if (passwordStrength == "strong") {
      color = index < 3 ? Colors.green : Colors.grey;
    } else if (passwordStrength == "medium") {
      color = index < 2 ? Colors.orange : Colors.grey;
    } else {
      color = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
